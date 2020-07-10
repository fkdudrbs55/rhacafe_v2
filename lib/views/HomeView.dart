import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhacafe_v1/views/CatalogView.dart';
import 'package:rhacafe_v1/views/LoginView.dart';

class HomeView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    FirebaseUser user = Provider.of(context);

    if(user == null){
      return LoginView();
    }else if(user != null){
      return CatalogView();
    }

  }

}