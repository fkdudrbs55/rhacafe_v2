import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';

import '../DetailView.dart';

class CurrentLocationCard extends StatelessWidget {
  final int index;
  final List<CafeItem> cafeItemList;

  CurrentLocationCard(this.index, this.cafeItemList);

  Widget showScore(List<double> scores){
    if(scores.isEmpty || scores == null){
      return Text('');
    } else {

      double sum = 0.0;

      for(int i = 0 ; i < scores.length ; i++){
        sum = sum + scores[i];
      }

      double averageScore = sum/scores.length;

      return Text(averageScore.toStringAsFixed(1).toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown),);
    }
  }
  
  @override
  Widget build(BuildContext context) {

    CafeItem cafeItem = cafeItemList[index];

    var textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => DetailView(cafeItem))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
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
                  imageUrl: cafeItem.imageUrl[0],
                  fit: BoxFit.fitHeight,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(cafeItem.name, style: textTheme.headline5,),
//                        Spacer(),
                        showScore(cafeItem.scores)
                      ],
                    ),
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
        ),
      ),
    );
  }
}
