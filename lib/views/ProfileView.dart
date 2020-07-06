import 'package:flutter/material.dart';
import 'widgets/ProfileTab.dart';

class ProfileView extends StatelessWidget {
  ProfileView({
    Key key,
  }) : super(key: key);

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
        ],
      ),
    );
  }
}
