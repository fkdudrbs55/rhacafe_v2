import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:algolia/algolia.dart';

class SearchViewModel  {

  Algolia algolia = Algolia.init(applicationId: 'V6ANRWWF6Y', apiKey: 'f7e7431412856392e357989c015e80eb');

  Future<List<CafeItem>> currentLocationList() async {
    AlgoliaQuery indexQuery = await algolia.instance.index('dev_rhacafe');

  }



}