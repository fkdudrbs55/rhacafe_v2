import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rhacafe_v1/AuthProvider.dart';

class DefaultAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AuthProvider authService = new AuthProvider();

    return AppBar(
      title: const Text('Basic AppBar'),
      actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(choices[0].icon),
          onPressed: () {
          },
        ),
        // action button
        IconButton(
          icon: Icon(choices[1].icon),
          onPressed: () {
          },
        ),
        // overflow menu
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
