import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Adobe XD layer: 'Surface' (shape)
        Container(
          width: 360.0,
          height: 48.0,
          decoration: BoxDecoration(
            color: const Color(0xffffffff),
          ),
        ),
        Transform.translate(
          offset: Offset(0.0, 47.0),
          child:
              // Adobe XD layer: 'Divider' (shape)
              Container(
            width: 360.0,
            height: 1.0,
            decoration: BoxDecoration(
              color: const Color(0x1a000000),
            ),
          ),
        ),
        // Adobe XD layer: 'SavedTab' (group)
        Stack(
          children: <Widget>[
            // Adobe XD layer: 'Box' (shape)
            Container(
              width: 120.0,
              height: 48.0,
              decoration: BoxDecoration(),
            ),
            Transform.translate(
              offset: Offset(0.0, 46.0),
              child:
                  // Adobe XD layer: 'Selected' (shape)
                  Container(
                width: 120.0,
                height: 2.0,
                decoration: BoxDecoration(
                  color: const Color(0xff212121),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(42.0, 13.0),
              child: SizedBox(
                width: 36.0,
                child: Text(
                  '저장',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: const Color(0xff212121),
                    letterSpacing: 1.2473999786376953,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        Transform.translate(
          offset: Offset(120.0, 0.0),
          child:
              // Adobe XD layer: 'EvaluationTab' (group)
              Stack(
            children: <Widget>[
              // Adobe XD layer: 'Box' (shape)
              Container(
                width: 120.0,
                height: 48.0,
                decoration: BoxDecoration(),
              ),
              Transform.translate(
                offset: Offset(42.0, 13.0),
                child: SizedBox(
                  width: 36.0,
                  child: Text(
                    '평가',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: const Color(0x99000000),
                      letterSpacing: 1.2473999786376953,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: Offset(240.0, 0.0),
          child:
              // Adobe XD layer: 'ReviewTab' (group)
              Stack(
            children: <Widget>[
              // Adobe XD layer: 'Box' (shape)
              Container(
                width: 120.0,
                height: 48.0,
                decoration: BoxDecoration(),
              ),
              Transform.translate(
                offset: Offset(42.0, 13.0),
                child: SizedBox(
                  width: 36.0,
                  child: Text(
                    '리뷰',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: const Color(0x99000000),
                      letterSpacing: 1.2473999786376953,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
