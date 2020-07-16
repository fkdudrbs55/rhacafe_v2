import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:rhacafe_v1/models/ItemDetail.dart';

import '../DatabaseService.dart';

class DetailView extends StatelessWidget {

  final CafeItem item;

  DetailView(this.item);

  @override
  Widget build(BuildContext context) {

    var textTheme = Theme.of(context).textTheme;

    final DatabaseService _db = DatabaseService();

    return FutureBuilder<List<DocumentSnapshot>>(
      future: _db.getItemDetailList(item),
      builder: (context, snapshot) {

        DocumentSnapshot doc = snapshot.data.elementAt(0);

        ItemDetail itemDetail = ItemDetail.fromFirestore(doc);

        if (!snapshot.hasData) return new CircularProgressIndicator();

        return Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  FittedBox(
                      fit: BoxFit.contain,
                      child: CachedNetworkImage(
                        placeholder: (context, url) => CircularProgressIndicator(),
                        imageUrl: item.imageUrl,
                        fit: BoxFit.fitHeight,
                      )),
                  Text(itemDetail.comment, style: textTheme.bodyText1,)
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
