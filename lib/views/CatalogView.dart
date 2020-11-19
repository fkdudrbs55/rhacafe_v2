import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhacafe_v1/notifiers/CafeNotifier.dart';
import 'package:rhacafe_v1/services/DatabaseService.dart';
import 'package:rhacafe_v1/views/widgets/CatalogItem.dart';
import './DetailView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'HomeView.dart';

class CatalogView extends StatefulWidget {
  @override
  State<CatalogView> createState() {
    return _CatalogViewState();
  }
}

class _CatalogViewState extends State<CatalogView> {
  List<CafeItem> lastCafeItemList = [];
  List<CafeItem> nextCafeItemList = [];
  DocumentSnapshot lastVisible;
  final _db = DatabaseService();
  ScrollController _scrollController;
  bool isInitialLoad = true;
  bool isEndOfCollection = false;
  static const limit = 5;
  CafeNotifier cafeNotifier;

  @override
  void initState() {
    super.initState();

    cafeNotifier =
        Provider.of<CafeNotifier>(context, listen: false);

    DatabaseService.getCafeList(cafeNotifier, limit);

    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  Widget buildScrollView(context, List<CafeItem> itemsList) {
    print('buildScrollView itemsList length is ${itemsList.length.toString()}');

    return Scaffold(
      body: CustomScrollView(
          controller: _scrollController,
          physics: ClampingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
//                return buildCatalogCard(index, itemsList);
              return CatalogItem(itemsList.elementAt(index));
              }, childCount: itemsList.length),
            ),
            SliverToBoxAdapter(child: showFooter())
          ]),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _onLoading2();
    }
  }

  Widget showFooter() {
    if (!isEndOfCollection) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return null;
    }
  }

  void _onLoading() async {
    if (!isEndOfCollection) {
      List<DocumentSnapshot> newList =
          await DatabaseService.getCafeSnapshotList(limit,
              lastVisible: lastVisible);

      print(newList.length.toString());

      List<CafeItem> newDerivedList =
          DatabaseService.deriveCafeListFromSnapshots(newList);
      for (int i = 0; i < newDerivedList.length; i++) {
        lastCafeItemList.add(newDerivedList[i]);
      }

      print(newList.elementAt(newList.length - 1) == lastVisible);

      if (newList.length < limit ||
          newDerivedList.elementAt(newList.length - 1) ==
              lastCafeItemList.elementAt(lastCafeItemList.length - 1)) {
        isEndOfCollection = true;
      }

      nextCafeItemList = lastCafeItemList;

      setState(() {
        isInitialLoad = false;
      });
    } else {
      Flushbar(
        message: "불러드릴 정보가 없습니다",
        duration: Duration(seconds: 2),
      )..show(context);

      return;
    }
  }



  void _onLoading2() async {

    if(!isEndOfCollection){

      DocumentSnapshot lastVisible = cafeNotifier.getLastVisible();

      DatabaseService.getUpdatedCafeList(cafeNotifier, limit, lastVisible);

      isInitialLoad = false;

      print(lastVisible == cafeNotifier.getLastVisible());

      //TODO 1. ChangeNotifier는 어떻게 작동하지? 예를 들어 이거 같은 경우 여기까지 실행되는게 맞나?
      if(lastVisible == cafeNotifier.getLastVisible()){
        setState(() {
          isEndOfCollection = true;
        });
      }

    } else {
      Flushbar(
        message: "불러드릴 정보가 없습니다",
        duration: Duration(seconds: 2),
      )..show(context);

      return;
    }
  }

//TODO PS. ViewModel로 옮길 수 있는 부분들이 없나?

  @override
  Widget build(BuildContext context) {
    cafeNotifier = Provider.of<CafeNotifier>(context);

    if (cafeNotifier.getCafeList().isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('No data yet'),
        ),
      );
    }else {
      return buildScrollView(context, cafeNotifier.getCafeList());
    }

//    return FutureBuilder<List<DocumentSnapshot>>(
//        future: DatabaseService.getCafeSnapshotList(limit),
//        builder: (context, snapshot) {
//          if (snapshot.connectionState == ConnectionState.waiting &&
//              isInitialLoad == true) {
//            return Container(
//              width: MediaQuery.of(context).size.width,
//              height: MediaQuery.of(context).size.height,
//              child: Center(child: CircularProgressIndicator()),
//            );
//          }
//
//          List<DocumentSnapshot> data = snapshot.data;
//
//          List<CafeItem> itemsList = DatabaseService.deriveCafeListFromSnapshots(data);
//
//          lastCafeItemList = itemsList;
//          lastVisible = data.elementAt(itemsList.length - 1);
//
//          if (itemsList.isEmpty) {
//            return Scaffold(
//              body: Center(
//                child: Text('No data yet'),
//              ),
//            );
//          } else if (nextCafeItemList.isEmpty) {
//            return buildScrollView(context, lastCafeItemList);
//          } else {
//            return buildScrollView(context, nextCafeItemList);
//          }
//        });
  }

  Widget imageSlider(List<String> imageUrls, BuildContext context) {
    if (imageUrls.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(color: Colors.white),
      );
    } else {
      return Column(
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1,
              enableInfiniteScroll: false,
              height: MediaQuery.of(context).size.height / 3,
            ),
            items: imageUrls
                .map(
                  (e) => Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          imageUrl: e,
//                  fit: BoxFit.cover,
                        )),
                  ),
                )
                .toList(),
          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: imageUrls.map((url) {
//              int index = imageUrls.indexOf(url);
//              return Container(
//                width: 8.0,
//                height: 8.0,
//                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                decoration: BoxDecoration(
//                  shape: BoxShape.circle,
//                  color: _current == index
//                      ? Color.fromRGBO(0, 0, 0, 0.9)
//                      : Color.fromRGBO(0, 0, 0, 0.4),
//                ),
//              );
//            }).toList(),
//          )
        ],
      );
    }
  }

  //TODO ViewModel로..?
  Widget showScore(List<double> scores) {
    if (scores.isEmpty || scores == null) {
      return Text('');
    } else {
      double sum = 0.0;

      for (int i = 0; i < scores.length; i++) {
        sum = sum + scores[i];
      }

      double averageScore = sum / scores.length;

      return Text(
        averageScore.toStringAsFixed(1).toString(),
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.brown),
      );
    }
  }

  Widget buildCatalogCard(int index, List<CafeItem> itemsList) {
    var textTheme = Theme.of(context).textTheme;

    final item = itemsList.elementAt(index);

    return InkWell(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DetailView(item))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          imageSlider(item.imageUrl, context),
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 0.0),
            child:
                Text(item.location.substring(0, 6), style: textTheme.subtitle2),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
            child: Row(
              children: <Widget>[
                Text(item.title, style: textTheme.headline3),
                Spacer(),
                showScore(item.scores)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
            child: Text(item.subtitle, style: textTheme.subtitle1),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 20.0),
            child: Text(item.content, style: textTheme.bodyText1),
          ),
        ]));
  }

}
