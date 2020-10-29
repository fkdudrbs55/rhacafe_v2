import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:rhacafe_v1/models/UserLocation.dart';

class LocationService{

  UserLocation _currentLocation;

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }

  Future<UserLocation> getCurrentLocationString() async {

    Position position =
    await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude, localeIdentifier: 'ko_KR');

    Placemark place = placemarks[0];

    String rep = "${place.subLocality} ${place.thoroughfare}";

    return UserLocation(latitude: position.latitude, longitude: position.longitude, stringRep: rep, dong: place.thoroughfare);
  }

  Future<String> getAddressFromLatLng(Position position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude, localeIdentifier: 'ko_KR');

    Placemark place = placemarks[0];

    return "${place.subLocality} ${place.thoroughfare}";
  }

//  Future<String> _getCurrentLocationString() async {
//
//    Position position =
//    await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
//
//    return _getAddressFromLatLng(position);
//  }
//
//  Future<String> _getAddressFromLatLng(Position position) async {
//    List<Placemark> placemarks =
//    await placemarkFromCoordinates(position.latitude, position.longitude, localeIdentifier: 'ko_KR');
//
//    Placemark place = placemarks[0];
//
//    return "${place.subLocality} ${place.thoroughfare}";
//  }
}