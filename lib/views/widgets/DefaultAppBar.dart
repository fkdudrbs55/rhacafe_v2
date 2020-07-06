import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rhacafe_v1/AuthProvider.dart';

class DefaultAppBar extends StatelessWidget {
  DefaultAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    AuthProvider authService = Provider.of(context);

    return Stack(
      children: <Widget>[
        // Adobe XD layer: 'Surface' (shape)
        SvgPicture.string(
          _svg_tf1dg7,
          allowDrawingOutsideViewBox: true,
        ),
        Transform.translate(
          offset: Offset(324.0, 15.0),
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
        Transform.translate(
          offset: Offset(10.0, 13.0),
          child:
              // Adobe XD layer: 'TextField' (text)
              Text(
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
        RaisedButton(
          onPressed: () {
            authService.signOutGoogle();
            Navigator.pushReplacementNamed(context, '/catalog');
          },
          child: Text('Sign out'),
        )
      ],
    );
  }
}

const String _svg_6jwmxu =
    '<svg viewBox="3.0 3.0 17.5 17.5" ><path transform="translate(-905.0, 1418.0)" d="M 920.5020141601563 -1404 L 919.7080078125 -1404 L 919.4320068359375 -1404.274047851563 C 920.406982421875 -1405.411010742188 921 -1406.885009765625 921 -1408.5 C 921 -1412.089965820313 918.0900268554688 -1415 914.5 -1415 C 910.9099731445313 -1415 908 -1412.089965820313 908 -1408.5 C 908 -1404.910034179688 910.9099731445313 -1402 914.5 -1402 C 916.114990234375 -1402 917.5880126953125 -1402.592041015625 918.7249755859375 -1403.566040039063 L 919.0009765625 -1403.2919921875 L 919.0009765625 -1402.5 L 923.9990234375 -1397.509033203125 L 925.489990234375 -1399 L 920.5020141601563 -1404 L 920.5020141601563 -1404 Z M 914.5 -1404 C 912.0139770507813 -1404 910 -1406.014038085938 910 -1408.5 C 910 -1410.984985351563 912.0139770507813 -1413 914.5 -1413 C 916.9849853515625 -1413 919 -1410.984985351563 919 -1408.5 C 919 -1406.014038085938 916.9849853515625 -1404 914.5 -1404 L 914.5 -1404 Z" fill="#000000" fill-opacity="0.5" stroke="none" stroke-width="1" stroke-opacity="0.5" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_tf1dg7 =
    '<svg viewBox="0.0 0.0 360.0 55.0" ><path transform="translate(-580.0, 1439.0)" d="M 580 -1384.000122070313 L 940 -1384.000122070313 L 940 -1439.000122070313 L 580 -1439.000122070313 L 580 -1384.000122070313 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
