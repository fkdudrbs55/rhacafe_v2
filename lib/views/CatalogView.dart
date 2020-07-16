import 'package:flutter/material.dart';
import 'package:rhacafe_v1/views/widgets/DefaultAppBar.dart';
import './DetailView.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';

class CatalogView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemsList = Provider.of<List<CafeItem>>(context);

    if (itemsList == null) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        appBar: DefaultAppBar().build(context),
        body: CustomScrollView(slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return _CatalogCard(index, itemsList);
          }, childCount: itemsList.length)),
        ]),
      );
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
            child: Text(item.location, style: textTheme.subtitle2),
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
