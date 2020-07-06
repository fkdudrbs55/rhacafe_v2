import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CatalogCard extends StatelessWidget {
  CatalogCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(17.0, 288.33),
          child:
              // Adobe XD layer: 'CatalogCardExpln' (text)
              SizedBox(
            width: 326.0,
            height: 82.0,
            child: Text(
              'Greyhound divisively hello coldly wonderfully marginally far…\nBlah Blah\nBlah Blah',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: const Color(0x99000000),
                letterSpacing: 0.252,
                height: 1.4285714285714286,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(17.0, 234.0),
          child:
              // Adobe XD layer: 'CatalogCardTitle' (group)
              Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(0.0, 6.0),
                child:
                    // Adobe XD layer: 'box' (shape)
                    Container(
                  width: 326.0,
                  height: 40.0,
                  decoration: BoxDecoration(),
                ),
              ),
              // Adobe XD layer: 'Title' (text)
              Text(
                '강남역 최고의 돼지고기 집',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  color: const Color(0xde000000),
                  letterSpacing: 0.25799999237060545,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
              Transform.translate(
                offset: Offset(0.0, 31.0),
                child:
                    // Adobe XD layer: 'Subtitle' (text)
                    Text(
                  '서울 강남역',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 10,
                    color: const Color(0xde000000),
                    letterSpacing: 0.17399999618530276,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        // Adobe XD layer: 'Image' (shape)
        Container(
          width: 360.0,
          height: 228.0,
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
          offset: Offset(17.5, 287.5),
          child: SvgPicture.string(
            _svg_ffe4ru,
            allowDrawingOutsideViewBox: true,
          ),
        ),
      ],
    );
  }
}

const String _svg_ffe4ru =
    '<svg viewBox="17.5 287.5 17.0 1.0" ><path transform="translate(17.5, 287.5)" d="M 0 0 L 17 0" fill="none" stroke="#707070" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
