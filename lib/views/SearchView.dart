import 'package:flutter/material.dart';
import 'package:rhacafe_v1/views/CatalogView.dart';
import '../locationData.dart';
import 'package:rhacafe_v1/views/widgets/CustomSearchDelegate.dart';

class SearchView extends CustomSearchDelegate<String> {
  final regions = LocationData().seoulRegions;

  static const recentRegions = [];

  @override
  String get searchFieldLabel => '지하철역, 동, 가게 이름';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  //TODO 2. Query는 무조건 CurrentLocationView로 이어져서 리스트 + 필터 보여줄 수 있도록
  //TODO 3. 비완전 검색어(현재는 위치만 구현, 음식점 명까지) 관련해서 구현 가능할지.
  //TODO 3.1 위치, 카페명 분리 + Algolia implementation

  @override
  Widget buildResults(BuildContext context) {
    return CatalogView(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentRegions
        : regions.where((element) => element.contains(query)).toList();

    //TODO 색 칠해지는거 실제 query에 맞춰서 되는걸로 바꿀 수 없을까

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
          onTap: () {
            query = suggestionList[index];
            showResults(context);
          },
          leading: Icon(Icons.place),
          title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.grey))
                ]),
          )),
      itemCount: suggestionList.length,
    );
  }
}

//class SearchView extends StatefulWidget {
//  SearchView({Key key}) : super(key: key);
//
//  @override
//  State<StatefulWidget> createState() {
//    return _SearchViewState();
//  }
//}
//
//class _SearchViewState extends State<SearchView> {
//  @override
//  Widget build(BuildContext context) {
//    throw UnimplementedError();
//  }
//}
