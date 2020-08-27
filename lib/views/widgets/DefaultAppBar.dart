import 'package:flutter/material.dart';
import 'package:rhacafe_v1/locationData.dart';
import 'package:rhacafe_v1/views/ProfileView.dart';
import 'package:rhacafe_v1/views/widgets/CustomSearchDelegate.dart';

import '../SearchView.dart';

class DefaultAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(45.0),
      child: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(''),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showCustomSearch(context: context, delegate: SearchView());
            },
          ),

          PopupMenuButton<Choice>(
            itemBuilder: (BuildContext context) {
              return choices.skip(2).map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];
