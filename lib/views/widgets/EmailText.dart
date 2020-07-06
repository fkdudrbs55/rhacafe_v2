import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmailText extends StatelessWidget {
  EmailText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Adobe XD layer: 'Surface' (shape)
        Container(
          width: 328.0,
          height: 56.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(width: 2.0, color: const Color(0xb2000000)),
          ),
        ),
        Transform.translate(
          offset: Offset(16.0, 16.0),
          child: Text(
            'Email',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: const Color(0x99000000),
              letterSpacing: 0.152,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Transform.translate(
          offset: Offset(16.0, 58.0),
          child: Text(
            'Assistive text',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              color: const Color(0x80000000),
              letterSpacing: 0.40440000915527347,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Transform.translate(
          offset: Offset(292.0, 16.0),
          child:
              // Adobe XD layer: 'Icon / Visibility /…' (group)
              Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(1.0, 5.0),
                child: SvgPicture.string(
                  _svg_3encvw,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
              // Adobe XD layer: 'Box' (shape)
              Container(
                width: 24.0,
                height: 24.0,
                decoration: BoxDecoration(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const String _svg_3encvw =
    '<svg viewBox="1.0 5.0 22.0 15.0" ><path transform="translate(-12.0, 44.0)" d="M 24 -39 C 19 -39 14.72999954223633 -35.88999938964844 13 -31.5 C 14.72999954223633 -27.11000061035156 19 -24 24 -24 C 29 -24 33.27000045776367 -27.11000061035156 35 -31.5 C 33.27000045776367 -35.88999938964844 29 -39 24 -39 Z M 24 -26.5 C 21.23999977111816 -26.5 19 -28.73999977111816 19 -31.5 C 19 -34.2599983215332 21.23999977111816 -36.5 24 -36.5 C 26.76000022888184 -36.5 29 -34.2599983215332 29 -31.5 C 29 -28.73999977111816 26.76000022888184 -26.5 24 -26.5 Z M 24 -34.5 C 22.34000015258789 -34.5 21 -33.15999984741211 21 -31.5 C 21 -29.84000015258789 22.34000015258789 -28.5 24 -28.5 C 25.65999984741211 -28.5 27 -29.84000015258789 27 -31.5 C 27 -33.15999984741211 25.65999984741211 -34.5 24 -34.5 Z" fill="#000000" fill-opacity="0.5" stroke="none" stroke-width="1" stroke-opacity="0.5" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
