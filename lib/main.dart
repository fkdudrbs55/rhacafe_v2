import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhacafe_v1/AuthProvider.dart';
import 'package:rhacafe_v1/views/CatalogView.dart';
import 'package:rhacafe_v1/views/LoginView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AuthProvider _auth = AuthProvider.instance();
  final bool isLogged = await _auth.isLogged();
  final MyApp myApp = MyApp(
    initialRoute: isLogged ? '/catalog' : '/',
  );
  runApp(myApp);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final String initialRoute;

  MyApp({this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) {
            return AuthProvider.instance();
          },
        ),

      ],
      child: MaterialApp(
        routes: {
          '/': (context) => LoginView(),
          '/catalog': (context) => CatalogView(),
        },
        initialRoute: '/',
        title: 'Flutter Demo',
      ),
    );
  }
}
