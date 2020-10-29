import 'package:flutter/material.dart';
import 'package:rhacafe_v1/services/AuthService.dart';

import 'HomeView.dart';

class LoginView extends StatelessWidget {
  LoginView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
              image: DecorationImage(
                image: const AssetImage('assets/images/CoffeeMugTop.png'),
                fit: BoxFit.cover,
              ),
              color: const Color(0xffffffff),
            ),
          ),
          Align(
            alignment: Alignment(0.0, -0.5),
            child: Text(
              '안녕',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 50,
                color: const Color(0xff707070),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Align(alignment: Alignment(0.0, 0.3), child: _signInButton(context))
        ],
      ),
    );
  }

  Widget _signInButton(context) {

    AuthService authService = new AuthService();

    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        authService.signInWithGoogle();
        if (await authService.signInWithGoogle()) {
          Navigator.of(context)
              .popAndPushNamed('/');        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
