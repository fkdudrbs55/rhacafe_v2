import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CurrentLocationCard extends StatelessWidget {
  final int index;

  CurrentLocationCard(this.index);

  @override
  Widget build(BuildContext context) {

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
                CircularProgressIndicator(),
              imageUrl: "https://firebasestorage.googleapis.com/v0/b/providershopper-b9c69.appspot.com/o/cafe_images%2Fgwanja.jpg?alt=media&token=5b2edb9a-d663-4c3f-bc25-3290574f7c18",
              fit: BoxFit.fitHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('스코프', style: textTheme.headline5,),
                SizedBox(height: 4,),
                Text('수요미식회: 부암동 영국식 베이커리', style: textTheme.subtitle1,),
                SizedBox(height: 4,),
                Text('서울특별시 종로구 창의문로 149', style: textTheme.bodyText2,),
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
