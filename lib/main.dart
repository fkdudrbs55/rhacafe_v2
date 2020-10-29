import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rhacafe_v1/views/LoginView.dart';
import 'models/UserLocation.dart';
import 'services/LocationService.dart';
import 'package:rhacafe_v1/views/HomeView.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'services/DatabaseService.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final DatabaseService _db = DatabaseService();
    final LocationService _ls = LocationService();

    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged
        ),

//        StreamProvider<List<CafeItem>>.value(value: _db.streamCafeList()),

        FutureProvider<UserLocation>.value(
          value: _ls.getCurrentLocationString(),
        )

      ],
      child: MaterialApp(
        routes: {
          '/': (context) => HomeView(),
          '/login': (context) => LoginView()
        },

        initialRoute: '/',
        theme: ThemeData(
          fontFamily: 'Roboto',
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            headline2: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            headline3: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            subtitle1: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            subtitle2: TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
            bodyText1: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            bodyText2: TextStyle(fontSize: 10, fontWeight: FontWeight.w100),
            headline4: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
            headline5: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
          )
        ),
      ),
    );
  }
}
