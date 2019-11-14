import 'dart:async';

import 'package:company_commute/network/service_interface.dart';
import 'package:company_commute/network/steam_join_latlng.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// The MockService is used as singelton
class MockService implements ServiceInterface {
  MockService._privateConstructor();
  static final MockService _instance = MockService._privateConstructor();
  static MockService get instance {
    return _instance;
  }

  // List holding the new adresses in RAM
  List<LatLng> _loadedLatLng = List<LatLng>();

  @override
  setLatLon(LatLng latLng) {
    _loadedLatLng.add(latLng);
  }

  @override
  Stream<LatLng> getFromCache() {
    return joinStreamsLatLng(Stream.fromIterable([LatLng(49, 11)]),
        Stream.fromIterable(_loadedLatLng));
  }

  @override
  Stream<LatLng> getFromStream() {
    return joinStreamsLatLng(Stream.fromIterable([LatLng(49, 11)]),
        Stream.fromIterable(_loadedLatLng));
  }
}
