import 'package:flutter/material.dart';
import 'package:adobe_xd/page_link.dart';
import 'widgets/CatalogCard.dart';
import './DetailView.dart';
import 'widgets/DefaultAppBar.dart';

class CatalogView extends StatelessWidget {
  CatalogView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(0.0, 57.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => DetailView(),
                ),
              ],
              child:
                  // Adobe XD layer: 'CatalogCard' (component)
                  CatalogCard(),
            ),
          ),
          Transform.translate(
            offset: Offset(0.0, 1.0),
            child:
                // Adobe XD layer: 'DefaultAppBar' (component)
                DefaultAppBar(),
          ),
        ],
      ),
    );
  }
}
