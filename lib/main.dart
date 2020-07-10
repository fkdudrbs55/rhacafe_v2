import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhacafe_v1/views/CatalogView.dart';
import 'package:rhacafe_v1/views/HomeView.dart';
import 'package:rhacafe_v1/views/LoginView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged
        )

      ],
      child: MaterialApp(
        routes: {
          '/': (context) => LoginView(),
          '/catalog': (context) => CatalogView(),
          '/home': (context) => HomeView()
        },
        initialRoute: '/home',
        title: 'Flutter Demo',
      ),
    );
  }
}
