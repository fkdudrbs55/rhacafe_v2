import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rhacafe_v1/constants/ui.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';

import '../DetailView.dart';

class CatalogItem extends StatelessWidget {
  CafeItem item;

  CatalogItem(this.item);

  Widget imageSlider(List<String> imageUrls, BuildContext context) {
    if (imageUrls.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(color: Colors.white),
      );
    } else {
      return Column(
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1,
              enableInfiniteScroll: false,
              height: MediaQuery.of(context).size.height / 3,
            ),
            items: imageUrls
                .map(
                  (e) => Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: FittedBox(
                    fit: BoxFit.cover,
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      imageUrl: e,
//                  fit: BoxFit.cover,
                    )),
              ),
            )
                .toList(),
          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: imageUrls.map((url) {
//              int index = imageUrls.indexOf(url);
//              return Container(
//                width: 8.0,
//                height: 8.0,
//                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                decoration: BoxDecoration(
//                  shape: BoxShape.circle,
//                  color: _current == index
//                      ? Color.fromRGBO(0, 0, 0, 0.9)
//                      : Color.fromRGBO(0, 0, 0, 0.4),
//                ),
//              );
//            }).toList(),
//          )
        ],
      );
    }
  }

  Widget showScore(List<double> scores) {
    if (scores.isEmpty || scores == null) {
      return Text('');
    } else {
      double sum = 0.0;

      for (int i = 0; i < scores.length; i++) {
        sum = sum + scores[i];
      }

      double averageScore = sum / scores.length;

      return Text(
        averageScore.toStringAsFixed(1).toString(),
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.brown),
      );
    }
  }

  Widget build(BuildContext context) {

    var textTheme = Theme.of(context).textTheme;

    return Container(
      child: item == LoadingIndicatorTitle
          ? CircularProgressIndicator()
          : InkWell(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => DetailView(item))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            imageSlider(item.imageUrl, context),
            Padding(
              padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 0.0),
              child:
              Text(item.location.substring(0, 6), style: textTheme.subtitle2),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
              child: Row(
                children: <Widget>[
                  Text(item.title, style: textTheme.headline3),
                  Spacer(),
                  showScore(item.scores)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
              child: Text(item.subtitle, style: textTheme.subtitle1),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 20.0),
              child: Text(item.content, style: textTheme.bodyText1),
            ),
          ]))
    );
  }
}
