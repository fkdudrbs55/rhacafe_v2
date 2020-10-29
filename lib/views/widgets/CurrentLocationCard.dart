import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';

class CurrentLocationCard extends StatelessWidget {
  final int index;
  final List<CafeItem> cafeItemList;

  CurrentLocationCard(this.index, this.cafeItemList);

  @override
  Widget build(BuildContext context) {

    CafeItem cafeItem = cafeItemList[index];

    var textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            height: 100,
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  Container(
                    width: 100,
                    height: 100,
                    child: Center(
                        child: CircularProgressIndicator()
                    ),
                  ),
              imageUrl: cafeItem.imageUrl,
              fit: BoxFit.fitHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(cafeItem.name, style: textTheme.headline5,),
                SizedBox(height: 4,),
                Text(cafeItem.subtitle, style: textTheme.subtitle1,),
                SizedBox(height: 4,),
                Text(cafeItem.location, style: textTheme.bodyText2,),
                SizedBox(height: 4,),
                Text('1만원 이하 / 1인       591m ', style: textTheme.bodyText2,)

              ],
            ),
          )
        ],
      ),
    );
  }
}
