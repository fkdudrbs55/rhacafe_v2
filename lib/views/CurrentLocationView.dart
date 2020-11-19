import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:rhacafe_v1/models/UserLocation.dart';
import 'package:rhacafe_v1/services/DatabaseService.dart';
import 'widgets/CurrentLocationCard.dart';
import 'package:algolia/algolia.dart';

class CurrentLocationView extends StatefulWidget {
  final String query;

  CurrentLocationView({this.query});

  @override
  State<CurrentLocationView> createState() {
    return _CurrentLocationViewState();
  }
}

class _CurrentLocationViewState extends State<CurrentLocationView> {

  //TODO isEndOfCollection, isInitialLoad 이대로 괜찮나?

  ScrollController _scrollController;
  bool isInitialLoad = true;
  bool isEndOfCollection = false;
  List<CafeItem> lastCafeItemList = [];
  List<CafeItem> nextCafeItemList = [];
  static const limit = 8;
  int page = 0;

  final DatabaseService _db = DatabaseService();

  final sort = [
    '최신순',
    '평점순',
    '리뷰순',
  ];

  final sortEnglish = ['timestamp', 'name', 'name'];

  final filter = [
    '공부하기 좋은',
    '대화하기 좋은',
  ];

  int _currentFilter = 0;
  int _currentSort = 0;

  void sortModalBottomSheet(context) {
    var textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                  child: Text(
                    '정렬',
                    style: textTheme.bodyText1,
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(sort.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChoiceChip(
                          onSelected: (bool selected) {
                            setState(() {
                              _currentSort = index;
                            });

                            Navigator.pop(context);
                          },
                          selected: _currentSort == index,
                          label: Text(sort[index]),
                        ),
                      );
                    }))
              ],
            ),
          ]);
        });
  }

  void filterModalBottomSheet(context) {
    var textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  '필터',
                  style: textTheme.bodyText1,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(filter.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChoiceChip(
                          selected: index == 0,
                          label: Text(filter[index]),
                        ),
                      );
                    }))
              ],
            ),
          ]);
        });
  }

  //TODO 위치 기반해서 인접 카페를 검색/지도 상에 보여주기(Algolia)

  void _onLoading() async {


    if (!isEndOfCollection) {

      page++;

      List<AlgoliaObjectSnapshot> newList =
          await DatabaseService.getAlgoliaCafeSnapshotList(widget.query, page);

      print('Length of newList is ${newList.length.toString()}');

      List<CafeItem> newDerivedList = DatabaseService.deriveCafeListFromAlgolia(newList);
      for (int i = 0; i < newDerivedList.length; i++) {
        lastCafeItemList.add(newDerivedList[i]);
      }

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

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _onLoading();
    }
  }

  @override
  Widget build(BuildContext context) {

    print('isInitialLoad is $isInitialLoad, isEndOfCollection is $isEndOfCollection');

    return buildFutureBuilder(context, query: widget.query);
  }

  Widget buildFutureBuilder(BuildContext context, {String query}) {
    var textTheme = Theme.of(context).textTheme;

    if (query != null) {
      return FutureBuilder<List<AlgoliaObjectSnapshot>>(
          future: DatabaseService.getAlgoliaCafeSnapshotList(query, page),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                                    isInitialLoad == true) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            List<CafeItem> cafeList =
            DatabaseService.deriveCafeListFromAlgolia(snapshot.data);

            print(cafeList.length);

            lastCafeItemList = cafeList;

            if (_currentSort == 0) {
              cafeList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
            } else if (_currentSort == 1) {
              cafeList.sort((a, b) => a.name.length.compareTo(b.name.length));
            } else {
              cafeList.sort((a, b) => a.contact.compareTo(b.contact));
            }


            if (isInitialLoad) {

              nextCafeItemList = cafeList;

              if(snapshot.data.isEmpty){
                return Center(child: Text('아직 없습니다'));}
            }


            return Column(
              children: <Widget>[
                Container(
                  height: 45,
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      ActionChip(
                        label: Text(sort[_currentSort],
                            style: textTheme.bodyText2),
                        onPressed: () => sortModalBottomSheet(context),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      ActionChip(
                        label: Text('1km', style: textTheme.bodyText2),
                        onPressed: () => null,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      ActionChip(
                        label: Text('필터', style: textTheme.bodyText2),
                        onPressed: () => filterModalBottomSheet(context),
                      ),
                      SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                ),
                buildScrollView(nextCafeItemList)
              ],
            );
          });
    } else {
      UserLocation currentLocation = Provider.of(context);

      if (currentLocation == null) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return FutureBuilder<List<AlgoliaObjectSnapshot>>(
          future: DatabaseService.getAlgoliaCafeSnapshotList(currentLocation.dong, page),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                    isInitialLoad == true) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (isInitialLoad) {
              if(snapshot.data.isEmpty){
              return Center(child: Text('아직 없습니다'));}
            }

            List<CafeItem> cafeList =
            DatabaseService.deriveCafeListFromAlgolia(snapshot.data);

            lastCafeItemList = cafeList;

            if (_currentSort == 0) {
              cafeList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
            } else if (_currentSort == 1) {
              cafeList.sort((a, b) => a.name.length.compareTo(b.name.length));
            } else {
              cafeList.sort((a, b) => a.contact.compareTo(b.contact));
            }

            if(isInitialLoad){
              nextCafeItemList = cafeList;
            }

            return Column(
              children: <Widget>[
                Container(
                  height: 45,
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () => setState(() {}),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.place),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              currentLocation.stringRep,
                              style: textTheme.headline5,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      ActionChip(
                        label: Text(sort[_currentSort],
                            style: textTheme.bodyText2),
                        onPressed: () => sortModalBottomSheet(context),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      ActionChip(
                        label: Text('1km', style: textTheme.bodyText2),
                        onPressed: () => null,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      ActionChip(
                        label: Text('필터', style: textTheme.bodyText2),
                        onPressed: () => filterModalBottomSheet(context),
                      ),
                      SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                ),
                    buildScrollView(nextCafeItemList)
              ],
            );
          });
    }
  }

  Widget buildScrollView(List<CafeItem> itemList) {
    return Expanded(
        child: CustomScrollView(controller: _scrollController,
            physics: ClampingScrollPhysics(),
            slivers: [
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return CurrentLocationCard(index, itemList);
      }, childCount: itemList.length)),
      SliverToBoxAdapter(child: showFooter(itemList.length))
    ]));
  }

  Widget showFooter(int length) {
    if (!isEndOfCollection && length > 7) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return null;
    }
  }
}
