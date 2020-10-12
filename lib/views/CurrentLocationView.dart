import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'widgets/CurrentLocationCard.dart';

class CurrentLocationView extends StatelessWidget {
  final sort = [
    '평점순',
    '리뷰순',
  ];

  final filter = [
    '공부하기 좋은',
    '대화하기 좋은',
  ];

  final int _value = 0;

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
                          selected: index == _value,
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
                          selected: index == _value,
                          label: Text(filter[index]),
                        ),
                      );
                    }))
              ],
            ),
          ]);
        });
  }

  Future<String> _getCurrentLocationString() async {

    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    return _getAddressFromLatLng(position);
  }

  Future<String> _getAddressFromLatLng(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude, localeIdentifier: 'ko_KR');

    Placemark place = placemarks[0];

    return "${place.subLocality} ${place.thoroughfare}";
  }

  //TODO 4. 현재 위치 파악(o) + 위치 기반해서 인접 카페를 검색/지도 상에 보여주기(Algolia)

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return FutureBuilder<Object>(
      future: _getCurrentLocationString(),
      builder: (context, snapshot) {
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
                          snapshot.data,
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
    );
  }
}
