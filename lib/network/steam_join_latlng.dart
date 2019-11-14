import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

// JoinStreams enables to Stream data from RAM and WebSocket
// This is needed for different Screens
Stream<LatLng> joinStreamsLatLng(Stream a, Stream b) {
  StreamController<LatLng> streamController = StreamController<LatLng>();
  a.listen((e) => streamController.add(e));
  b.listen((e) => streamController.add(e));
  return streamController.stream;
}
