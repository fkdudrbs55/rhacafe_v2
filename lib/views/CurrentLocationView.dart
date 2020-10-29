import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:rhacafe_v1/models/UserLocation.dart';
import 'package:rhacafe_v1/services/AlgoliaApplication.dart';
import 'package:rhacafe_v1/services/DatabaseService.dart';
import 'package:rhacafe_v1/services/LocationService.dart';
import 'package:rhacafe_v1/views/HomeView.dart';
import 'widgets/CurrentLocationCard.dart';
import 'package:algolia/algolia.dart';

class CurrentLocationView extends StatefulWidget{
  @override
  State<CurrentLocationView> createState() {
    return _CurrentLocationViewState();
  }

}


class _CurrentLocationViewState extends State<CurrentLocationView>{
  final sort = [
    '최신순',
    '평점순',
    '리뷰순',
  ];

  final sortEnglish = [
    'timestamp',
    'name',
    'name'
  ];

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
                Text(
                  '정렬',
                  style: textTheme.bodyText1,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(sort.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChoiceChip(
                          onSelected: (bool selected){
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

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    DatabaseService _db = DatabaseService();

    UserLocation currentLocation = Provider.of(context);

    if(currentLocation == null){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: CircularProgressIndicator()
        ),
      );
    }

    return FutureBuilder<List<AlgoliaObjectSnapshot>>(
      future: _db.getAlgoliaCafeSnapshotList(currentLocation.dong),
      builder: (context, snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting || snapshot.data == null){
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: CircularProgressIndicator()
            ),
          );
        }

        if (snapshot.data.isEmpty) {
          return Center(child: Text('아직 없습니다'));
        }
        List<CafeItem> cafeList = _db.deriveCafeListFromAlgolia(snapshot.data);

        if(_currentSort == 0) {
          cafeList.sort((a,b) => b.timestamp.compareTo(a.timestamp));
        } else if(_currentSort == 1) {
          cafeList.sort((a,b) => a.name.length.compareTo(b.name.length));
        } else{
          cafeList.sort((a,b) => a.contact.compareTo(b.contact));

        }

        return Column(
              children: <Widget>[
                Container(
                  height: 45,
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      InkWell(
//                        onTap: () => Navigator.of(context)
//                            .pushReplacement(PageRouteBuilder(
//                            pageBuilder: (_, __, ___) => HomeView(index:1),
//                          transitionDuration: Duration(seconds: 0)
//                        ),),
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
                        label: Text(sort[_currentSort], style: textTheme.bodyText2),
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
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                        return CurrentLocationCard(index, cafeList);
                      }, childCount: cafeList.length)),
                    ],
                  ),
                ),
              ],
            );
      }
    );
      }
  }

