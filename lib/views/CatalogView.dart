import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rhacafe_v1/services/DatabaseService.dart';
import 'package:rhacafe_v1/views/widgets/DefaultAppBar.dart';
import './DetailView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';

class CatalogView extends StatelessWidget {
  final String query;

  CatalogView({this.query = ''});

  Widget buildScrollView(List<CafeItem> itemsList) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return _CatalogCard(index, itemsList);
        }, childCount: itemsList.length)),
      ]),
    );
  }

  //TODO PS. ViewModel로 옮길 수 있는 부분들이 없나?
  //TODO 1. CatalogView는 무조건 그냥 블로그 형식으로. 한 번에 호출하는 포스트 개수 제한(10) + 스크롤 시 추가 호출
  @override
  Widget build(BuildContext context) {
    final _db = DatabaseService();

    if (query != '') {
      return StreamBuilder<List<CafeItem>>(
          stream: Firestore.instance
              .collection('SampleCollection')
              .where('region', isEqualTo: query)
              .snapshots()
              .map((list) => list.documents
                  .map((doc) => _db.deriveCafeItem(doc))
                  .toList()),
          builder: (context, snapshot) {
            List<CafeItem> itemsList = snapshot.data;

            if(snapshot.data == null){
              return CircularProgressIndicator();
            }

            if (itemsList.isEmpty) {
              return Scaffold(
                body: Center(
                  child: Text('No data yet'),
                ),
              );
            } else {
              return buildScrollView(itemsList);
            }
          });
    } else {
      return StreamBuilder<List<CafeItem>>(
          stream: Firestore.instance
              .collection('SampleCollection')
              .limit(10)
              .snapshots()
              .map((list) => list.documents
                  .map((doc) => _db.deriveCafeItem(doc))
                  .toList()),
          builder: (context, snapshot) {

            if(snapshot.data == null){
              return CircularProgressIndicator();
            }

            List<CafeItem> itemsList = snapshot.data;

            if (itemsList.isEmpty) {
              return Scaffold(
                body: Center(
                  child: Text('No data yet'),
                ),
              );
            } else {
              return buildScrollView(itemsList);
            }
          });
    }
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
          FittedBox(
              fit: BoxFit.contain,
              child: CachedNetworkImage(
                placeholder: (context, url) => CircularProgressIndicator(),
                imageUrl: item.imageUrl,
                fit: BoxFit.fitHeight,
              )),
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
