import 'package:flutter/material.dart';
import 'package:rhacafe_v1/views/CatalogView.dart';
import 'package:rhacafe_v1/views/LoginView.dart';
import 'package:rhacafe_v1/views/ProfileView.dart';
import 'package:rhacafe_v1/views/SearchView.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeView extends StatefulWidget {
  HomeView({
    Key key,
  }) : super(key: key);

  @override
  State<HomeView> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  final bodyList = [CatalogView(), SearchView(), ProfileView()];

  int _currentIndex = 0;

  void onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('HomeView Build loaded');

    var textTheme = Theme.of(context).textTheme;

    FirebaseUser user = Provider.of(context);

    if (user == null) {
      return LoginView();
    } else if (user != null) {
      return WillPopScope(
          onWillPop: () async {
            if (_currentIndex == 0) {
              return showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  content: new Text('Do you want to exit RhaCafe?',
                      style: textTheme.bodyText1),
                  actions: <Widget>[
                    new GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Text("NO"),
                    ),
                    SizedBox(height: 16),
                    new GestureDetector(
                      onTap: () => Navigator.of(context).pop(true),
                      child: Text("YES"),
                    ),
                  ],
                ),
              );
            } else {
              onTapTapped(0);
              return null;
            }
          },
          child: Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.brown,
                onTap: onTapTapped,
                currentIndex: _currentIndex,
                items: [
                  BottomNavigationBarItem(
                      icon: new Icon(Icons.home),
                      title: Text(
                        '홈',
                        style: textTheme.subtitle2,
                      )),
                  BottomNavigationBarItem(
                      icon: new Icon(Icons.location_on),
                      title: Text(
                        '현재위치',
                        style: textTheme.subtitle2,
                      )),
                  BottomNavigationBarItem(
                      icon: new Icon(Icons.person),
                      title: Text(
                        '마이페이지',
                        style: textTheme.subtitle2,
                      ))
                ],
              ),
              backgroundColor: const Color(0xffffffff),
              body: IndexedStack(
                index: _currentIndex,
                children: bodyList,
              )));
    } else {
      return CircularProgressIndicator();
    }
  }
}
