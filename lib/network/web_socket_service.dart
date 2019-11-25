import 'dart:async';

import 'package:company_commute/network/service_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:io' show Platform;

/// The WebSocketService is used as singelton
class WebSocketService implements ServiceInterface {
  WebSocketService._privateConstructor();
  static final WebSocketService _instance =
      WebSocketService._privateConstructor();
  static WebSocketService get instance {
    return _instance;
  }

  WebSocketChannel _socket = IOWebSocketChannel.connect((!Platform.isAndroid)
      ? 'ws://127.0.0.1:4040/'
      : 'ws://10.0.2.2:4040/');

  List<LatLng> _loadedLatLng = List<LatLng>();

  @override
  setLatLon(LatLng latLng) {
    _socket.sink
        .add(latLng.latitude.toString() + "," + latLng.longitude.toString());
  }

  @override
  Stream<LatLng> getFromCache() {
    return Stream.fromIterable(_loadedLatLng);
  }

  @override
  Stream<LatLng> getFromStream() {
    return _socket.stream.map((data) {
      String responseData = data.toString();
      // From the responseData the latitude and logitute will be extracted
      List<String> responseSplit = responseData.split(",");
      double latitude = double.tryParse(responseSplit.first);
      double longitude = double.tryParse(responseSplit.last);
      LatLng newLatLng = LatLng(latitude, longitude);

      _loadedLatLng.add(newLatLng);
      return newLatLng;
    });
  }
}
