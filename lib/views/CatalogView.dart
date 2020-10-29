import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rhacafe_v1/services/DatabaseService.dart';
import 'package:rhacafe_v1/views/widgets/DefaultAppBar.dart';
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
  static const lengthOfCollection = 8;
  static const limit = 5;

  @override
  void initState() {
    super.initState();

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
                return _CatalogCard(index, itemsList);
              }, childCount: itemsList.length),
            ),
            SliverToBoxAdapter(child: showFooter())
          ]),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _onLoading();
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

    if(!isEndOfCollection){
      List<DocumentSnapshot> newList =
      await _db.getCafeSnapshotList(limit, lastVisible: lastVisible);

      print(newList.length.toString());

      List<CafeItem> newDerivedList = _db.deriveCafeListFromSnapshots(newList);
      for (int i = 0; i < newDerivedList.length; i++) {
        lastCafeItemList.add(newDerivedList[i]);
      }

      print(newList.elementAt(newList.length -1) == lastVisible);

      if (newList.length < limit || newDerivedList.elementAt(newList.length -1) == lastCafeItemList.elementAt(lastCafeItemList.length -1)) {

        isEndOfCollection = true;

      }

      nextCafeItemList = lastCafeItemList;

      setState(() {
        isInitialLoad = false;
      });
    } else{
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
    return FutureBuilder<List<DocumentSnapshot>>(
        future: _db.getCafeSnapshotList(limit),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              isInitialLoad == true) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          List<DocumentSnapshot> data = snapshot.data;

          List<CafeItem> itemsList = _db.deriveCafeListFromSnapshots(data);

          lastCafeItemList = itemsList;
          lastVisible = data.elementAt(itemsList.length - 1);

          if (itemsList.isEmpty) {
            return Scaffold(
              body: Center(
                child: Text('No data yet'),
              ),
            );
          } else if (nextCafeItemList.isEmpty) {
            return buildScrollView(context, lastCafeItemList);
          } else {
            return buildScrollView(context, nextCafeItemList);
          }
        });
  }
}

class _CatalogCard extends StatelessWidget {
  final int index;
  final List<CafeItem> itemsList;

  _CatalogCard(this.index, this.itemsList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final item = itemsList.elementAt(index);

    var textTheme = Theme.of(context).textTheme;

    return InkWell(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DetailView(item))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
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
                  imageUrl: item.imageUrl,
//                  fit: BoxFit.fitHeight,
                )),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 0.0),
            child:
                Text(item.location.substring(0, 6), style: textTheme.subtitle2),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
            child: Text(item.title, style: textTheme.headline3),
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
