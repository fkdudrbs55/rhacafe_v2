import 'package:flutter/material.dart';

class SearchViewCard extends StatelessWidget {
  SearchViewCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Adobe XD layer: 'Surface' (shape)
        Container(
          width: 336.0,
          height: 86.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: const Color(0xffffffff),
            border: Border.all(width: 1.0, color: const Color(0x1f000000)),
          ),
        ),
        Transform.translate(
          offset: Offset(90.0, 32.0),
          child: Text(
            '수요미식회: 부암동 영국식 베이커리',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 10,
              color: const Color(0x99000000),
              letterSpacing: 0.17399999618530276,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Transform.translate(
          offset: Offset(90.0, 16.0),
          child: Text(
            '스코프',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 10,
              color: const Color(0xde000000),
              letterSpacing: 0.12899999618530272,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        // Adobe XD layer: 'Image' (shape)
        Container(
          width: 86.0,
          height: 86.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
            image: DecorationImage(
              image: const AssetImage(''),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(90.0, 51.0),
          child: Text(
            '서울특별시 종로구 창의문로 149',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 8,
              color: const Color(0x99000000),
              letterSpacing: 0.1391999969482422,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Transform.translate(
          offset: Offset(90.0, 68.0),
          child: Text(
            '2만원 이하 / 1인',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 8,
              color: const Color(0x99000000),
              letterSpacing: 0.1391999969482422,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Transform.translate(
          offset: Offset(187.0, 69.0),
          child: Text(
            '500m',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 8,
              color: const Color(0x99000000),
              letterSpacing: 0.1391999969482422,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
