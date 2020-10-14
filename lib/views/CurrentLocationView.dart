import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rhacafe_v1/models/UserLocation.dart';
import 'package:rhacafe_v1/services/LocationService.dart';
import 'widgets/CurrentLocationCard.dart';
import 'package:algolia/algolia.dart';

class CurrentLocationView extends StatelessWidget {
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

  //TODO 4. 현재 위치 파악(o) + 위치 기반해서 인접 카페를 검색/지도 상에 보여주기(Algolia)

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    UserLocation currentLocation = Provider.of(context);

    return Column(
          children: <Widget>[
            Container(
              height: 45,
              width: double.maxFinite,
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () => print('Hello'),
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
                    return CurrentLocationCard(index);
                  }, childCount: 10)),
                ],
              ),
            ),
          ],
        );
      }
  }

