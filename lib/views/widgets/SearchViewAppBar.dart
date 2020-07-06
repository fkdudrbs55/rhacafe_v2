import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchViewAppBar extends StatelessWidget {
  SearchViewAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(0.0, 102.0),
          child:
              // Adobe XD layer: 'Divider' (group)
              Stack(
            children: <Widget>[
              // Adobe XD layer: 'Divider' (shape)
              SvgPicture.string(
                _svg_f6z0fm,
                allowDrawingOutsideViewBox: true,
              ),
            ],
          ),
        ),
        // Adobe XD layer: 'Surface' (shape)
        SvgPicture.string(
          _svg_v92yj8,
          allowDrawingOutsideViewBox: true,
        ),
        Transform.translate(
          offset: Offset(9.0, 13.0),
          child: Text(
            '부암동 98-2',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              color: const Color(0xde000000),
              letterSpacing: 0.25799999237060545,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Transform.translate(
          offset: Offset(294.0, 13.0),
          child:
              // Adobe XD layer: 'Buttons / Outlined …' (group)
              Stack(
            children: <Widget>[
              Container(
                width: 52.0,
                height: 24.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: const Color(0xffffffff),
                  border:
                      Border.all(width: 1.0, color: const Color(0xffc3c3c3)),
                ),
              ),
              Transform.translate(
                offset: Offset(10.0, 4.0),
                child: SizedBox(
                  width: 32.0,
                  child: Text(
                    '1km',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      color: const Color(0x61000000),
                      letterSpacing: 1.069199981689453,
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
          offset: Offset(11.0, 52.0),
          child:
              // Adobe XD layer: 'Surface' (shape)
              Container(
            width: 336.0,
            height: 41.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(width: 2.0, color: const Color(0xb2000000)),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(45.0, 66.0),
          child: Text(
            '키워드를 입력해주세요. 예)카페',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              color: const Color(0x99000000),
              letterSpacing: 0.11399999999999999,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Transform.translate(
          offset: Offset(18.0, 60.0),
          child:
              // Adobe XD layer: 'Icon / Search / Fil…' (group)
              Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(0.0, 0.0),
                child:
                    // Adobe XD layer: 'Box' (shape)
                    Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(),
                ),
              ),
              Transform.translate(
                offset: Offset(3.0, 3.0),
                child: SvgPicture.string(
                  _svg_6jwmxu,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const String _svg_f6z0fm =
    '<svg viewBox="0.0 0.0 360.0 1.0" ><path transform="translate(-75.0, 1525.0)" d="M 75.00000762939453 -1524 L 435 -1524 L 435 -1525 L 75.00000762939453 -1525 L 75.00000762939453 -1524 Z" fill="#000000" fill-opacity="0.12" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_v92yj8 =
    '<svg viewBox="0.0 0.0 360.0 102.0" ><path transform="translate(-580.0, 1439.0)" d="M 580 -1337.000122070313 L 940 -1337.000122070313 L 940 -1439.000122070313 L 580 -1439.000122070313 L 580 -1337.000122070313 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_6jwmxu =
    '<svg viewBox="3.0 3.0 17.5 17.5" ><path transform="translate(-905.0, 1418.0)" d="M 920.5020141601563 -1404 L 919.7080078125 -1404 L 919.4320068359375 -1404.274047851563 C 920.406982421875 -1405.411010742188 921 -1406.885009765625 921 -1408.5 C 921 -1412.089965820313 918.0900268554688 -1415 914.5 -1415 C 910.9099731445313 -1415 908 -1412.089965820313 908 -1408.5 C 908 -1404.910034179688 910.9099731445313 -1402 914.5 -1402 C 916.114990234375 -1402 917.5880126953125 -1402.592041015625 918.7249755859375 -1403.566040039063 L 919.0009765625 -1403.2919921875 L 919.0009765625 -1402.5 L 923.9990234375 -1397.509033203125 L 925.489990234375 -1399 L 920.5020141601563 -1404 L 920.5020141601563 -1404 Z M 914.5 -1404 C 912.0139770507813 -1404 910 -1406.014038085938 910 -1408.5 C 910 -1410.984985351563 912.0139770507813 -1413 914.5 -1413 C 916.9849853515625 -1413 919 -1410.984985351563 919 -1408.5 C 919 -1406.014038085938 916.9849853515625 -1404 914.5 -1404 L 914.5 -1404 Z" fill="#000000" fill-opacity="0.5" stroke="none" stroke-width="1" stroke-opacity="0.5" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
