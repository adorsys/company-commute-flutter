import 'dart:async';

import 'package:company_commute/network/mock_service.dart';
import 'package:company_commute/network/service_interface.dart';
import 'package:company_commute/network/web_socket_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// The repository was created to abstract the underlying data provider from the
/// rest of the app. So we can easily change the backend later.

class Repository implements ServiceInterface {
  Repository._privateConstructor();
  static final Repository _instance = Repository._privateConstructor();
  static Repository get instance {
    return _instance;
  }

  // For changing between on device data base or real web socket
  // If true the on device data safeing is enabled
  bool mock = true;

  @override
  void setLatLon(LatLng latLng) {
    if (mock) {
      return MockService.instance.setLatLon(latLng);
    } else {
      return WebSocketService.instance.setLatLon(latLng);
    }
  }

  @override
  Stream<LatLng> getFromCache() {
    if (mock) {
      return MockService.instance.getFromCache();
    } else {
      return WebSocketService.instance.getFromCache();
    }
  }

  @override
  Stream<LatLng> getFromWS() {
    if (mock) {
      return MockService.instance.getFromWS();
    } else {
      return WebSocketService.instance.getFromWS();
    }
  }
}
