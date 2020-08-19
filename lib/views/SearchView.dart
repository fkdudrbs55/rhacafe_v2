import 'package:flutter/material.dart';
import 'package:rhacafe_v1/views/widgets/DefaultAppBar.dart';
import 'widgets/SearchViewAppBar.dart';
import 'widgets/SearchViewCard.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar().build(context),
      body: CustomScrollView(slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return SearchViewCard(index);
            }, childCount: 1)),
      ]),
    );
  }
}


