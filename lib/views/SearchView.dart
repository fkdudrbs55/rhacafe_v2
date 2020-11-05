import 'package:flutter/material.dart';
import 'package:rhacafe_v1/views/CatalogView.dart';
import '../locationData.dart';
import 'package:rhacafe_v1/views/widgets/CustomSearchDelegate.dart';
import 'CurrentLocationView.dart';


class SearchView extends SearchDelegate<String> {
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

  @override
  Widget buildResults(BuildContext context) {
//    return SearchResultView(query);
  return CurrentLocationView(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentRegions
        : regions.where((element) => element.contains(query)).toList();

    //TODO 효과적인 Suggestion은 무엇일까

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
