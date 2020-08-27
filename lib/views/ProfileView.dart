import 'package:flutter/material.dart';
import 'package:rhacafe_v1/services/AuthService.dart';
import 'package:rhacafe_v1/views/LoginView.dart';
import 'widgets/ProfileTab.dart';

class ProfileView extends StatelessWidget {
  ProfileView({
    Key key,
  }) : super(key: key);

  AuthService authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: Stack(
          children: <Widget>[
            Transform.translate(
              offset: Offset(0.0, 119.0),
              child:
                  // Adobe XD layer: 'ProfileTab' (component)
                  ProfileTab(),
            ),
            RaisedButton(
              child: Text('Logout'),
              onPressed: () {
                authService.signOut();

                //Necessary since although CatalogView is reloaded, this is a separate route
                //and thus this view itself is not reloaded.
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LoginView()));

              },
            )
          ],
        ));
  }
}
