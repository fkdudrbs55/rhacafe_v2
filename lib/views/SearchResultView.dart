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

class SearchResultView extends StatelessWidget {

  final query;

  SearchResultView(this.query);

  final sort = [
    '평점순',
    '리뷰순',
  ];

  final filter = [
    '공부하기 좋은',
    '대화하기 좋은',
  ];

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
                          selected: index == 0,
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

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    DatabaseService _db = DatabaseService();

    return FutureBuilder<List<AlgoliaObjectSnapshot>>(
        future: _db.getAlgoliaCafeSnapshotList(query),
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Center(child: Text('아직 없습니다'));
          }

          List<CafeItem> cafeList = _db.deriveCafeListFromAlgolia(snapshot.data);

          return Column(
            children: <Widget>[
              Container(
                height: 45,
                width: double.maxFinite,
                child: Row(
                  children: <Widget>[
//                    InkWell(
//                      onTap: () => Navigator.of(context)
//                          .pushReplacement(PageRouteBuilder(
//                          pageBuilder: (_, __, ___) => HomeView(index:1),
//                          transitionDuration: Duration(seconds: 0)
//                      ),),
//                      child: Row(
//                        children: <Widget>[
//                          Icon(Icons.),
//                          SizedBox(
//                            width: 4,
//                          ),
//                          Text(
//                            query,
//                            style: textTheme.headline5,
//                          ),
//                        ],
//                      ),
//                    ),
                    Spacer(),
                    ActionChip(
                      label: Text('평점순', style: textTheme.bodyText2),
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

