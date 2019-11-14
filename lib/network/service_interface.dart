import 'package:google_maps_flutter/google_maps_flutter.dart';

// The Interface is needed to declare which two functions the underlying data base must provide
abstract class ServiceInterface {
  setLatLon(LatLng latLng) {}
  Stream<LatLng> getFromStream() {}
  Stream<LatLng> getFromCache() {}
}
