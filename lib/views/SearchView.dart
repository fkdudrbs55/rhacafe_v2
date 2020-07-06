import 'package:flutter/material.dart';
import 'widgets/SearchViewAppBar.dart';
import 'widgets/SearchViewCard.dart';

class SearchView extends StatelessWidget {
  SearchView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(0.0, 0.0),
            child:
                // Adobe XD layer: 'SearchViewAppBar' (component)
                SearchViewAppBar(),
          ),
          Transform.translate(
            offset: Offset(12.0, 113.0),
            child:
                // Adobe XD layer: 'SearchViewCard' (component)
                SearchViewCard(),
          ),
        ],
      ),
    );
  }
}
