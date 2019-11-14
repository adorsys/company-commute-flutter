import 'dart:async';
import 'dart:math';

import 'package:company_commute/network/here_response.dart';
import 'package:company_commute/network/here_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// Custom version of Google Maps for our project
class CustomMap extends StatefulWidget {
  CustomMap({
    Key key,
    this.onMapCreated,
  }) : super(key: key);
  @required
  final MapCreatedCallback onMapCreated;

  @override
  State createState() => CustomMapState();
}

class CustomMapState extends State<CustomMap> {
  Set<Polyline> polyline = {};
  BitmapDescriptor adorsysBitmap;
  Map<String, List<LatLng>> allPoints = Map<String, List<LatLng>>();

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(2, 2)),
            'assets/marker_adorsys_small.png')
        .then((onValue) {
      adorsysBitmap = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      polylines: polyline,
      myLocationButtonEnabled: false,
      onMapCreated: widget.onMapCreated,
      initialCameraPosition: CameraPosition(target: adorsysLatLng, zoom: 12.0),
      markers: Set.from([
        Marker(
          markerId: MarkerId('adorsysMarker'),
          onTap: () async {
            String url = 'https://adorsys.de';
            if (await canLaunch(url)) {
              await launch(url);
            }
          },
          position: adorsysLatLng,
          icon: adorsysBitmap,
        )
      ]),
    );
  }
}

LatLng adorsysLatLng = LatLng(49.459775, 11.029788);

zoomAnimation(GoogleMapController mapController) {
  smallZoom(mapController);
  Future.delayed(Duration(milliseconds: 3000), () {
    bigZoom(mapController);
  });
}

smallZoom(GoogleMapController mapController) {
  mapController.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(bearing: 0.0, target: adorsysLatLng, tilt: 30.0, zoom: 11.0),
  ));
}

bigZoom(GoogleMapController mapController) {
  mapController.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(bearing: 0.0, target: adorsysLatLng, tilt: 30.0, zoom: 14.0),
  ));
}

removePolylines(GlobalKey<CustomMapState> mapState) {
  mapState.currentState.polyline = {};
}

drawPolylineOnMapFromPointList(
    GlobalKey<CustomMapState> mapState, List<LatLng> points) {
  double opacityPercentage = 0.0;

  Timer.periodic(Duration(milliseconds: 100), (timer) {
    if (opacityPercentage >= 1) {
      timer.cancel();
      return;
    }
    mapState.currentState.polyline.add(Polyline(
        polylineId: PolylineId(points.hashCode.toString()),
        visible: true,
        points: points,
        color:
            randomColorFromPoint(points.first).withOpacity(opacityPercentage),
        width: 4));
    mapState.currentState.setState(() {});
    opacityPercentage += 0.05;
  });
}

// Used for the animation button
Future<bool> redrawPolylineOnMap(
    GlobalKey<CustomMapState> mapState, int durationMilliseconds) {
  int counter = 0;
  if (mapState.currentState.allPoints.isEmpty) return true as Future<bool>;
  Timer.periodic(Duration(milliseconds: durationMilliseconds), (timer) {
    if (mapState.currentState.allPoints.length > counter) {
      drawPolylineOnMapFromPointList(
          mapState, mapState.currentState.allPoints.values.toList()[counter]);
      counter++;
    } else {
      timer.cancel();
    }
  });
  return Future.delayed(
      Duration(
          milliseconds:
              durationMilliseconds * mapState.currentState.allPoints.length,
          seconds: 2), () {
    return true;
  });
}

// Gets waypoint list based on the LatLng given and draws it to map
Future drawManeuversFromResult(
    GlobalKey<CustomMapState> mapState, LatLng result) async {
  List<Maneuver> maneuvers = await HereService.instance.getManeuvers(result);

  if (maneuvers != null) _drawPolylinesFromManeuvers(mapState, maneuvers);
}

loadCustomMapStyle(GoogleMapController mapController) {
  mapController.setMapStyle(
      '[ { "elementType": "geometry", "stylers": [ { "color": "#f5f5f5" } ] }, { "elementType": "labels.icon", "stylers": [ { "visibility": "off" } ] }, { "elementType": "labels.text.fill", "stylers": [ { "color": "#ff00557e" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "visibility": "off" } ] }, { "featureType": "administrative", "elementType": "geometry", "stylers": [ { "color": "#929292" } ] }, { "featureType": "administrative.land_parcel", "elementType": "labels.text.fill", "stylers": [ { "color": "#0061ff" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#eeeeee" } ] }, { "featureType": "poi", "elementType": "labels.text.fill", "stylers": [ { "color": "#757575" } ] }, { "featureType": "poi.park", "elementType": "geometry", "stylers": [ { "color": "#e5e5e5" } ] }, { "featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [ { "color": "#9e9e9e" } ] }, { "featureType": "road", "elementType": "geometry", "stylers": [ { "color": "#ffffff" } ] }, { "featureType": "road.arterial", "elementType": "labels.text.fill", "stylers": [ { "color": "#757575" } ] }, { "featureType": "road.highway", "elementType": "geometry", "stylers": [ { "color": "#dadada" } ] }, { "featureType": "road.highway", "elementType": "labels.text.fill", "stylers": [ { "color": "#616161" } ] }, { "featureType": "road.local", "elementType": "labels.text.fill", "stylers": [ { "color": "#9e9e9e" } ] }, { "featureType": "transit.line", "elementType": "geometry", "stylers": [ { "color": "#e5e5e5" } ] }, { "featureType": "transit.station", "elementType": "geometry", "stylers": [ { "color": "#eeeeee" } ] }, { "featureType": "water", "elementType": "geometry", "stylers": [ { "color": "#c9c9c9" } ] }, { "featureType": "water", "elementType": "labels.text.fill", "stylers": [ { "color": "#9e9e9e" } ] } ]');
}

// Deterministic function for colors so that the color is the same for every device
Color randomColorFromPoint(LatLng latLng) {
  return Colors.primaries[Random((latLng.latitude * latLng.longitude).toInt())
      .nextInt(Colors.primaries.length)];
}

_drawPolylinesFromManeuvers(
    GlobalKey<CustomMapState> mapState, List<Maneuver> maneuverList) {
  List<LatLng> points = List<LatLng>();
  maneuverList.forEach((maneuver) async {
    points.add(LatLng(maneuver.position.latitude, maneuver.position.longitude));
  });
  mapState.currentState.allPoints.addAll({points.first.toString(): points});
  drawPolylineOnMapFromPointList(mapState, points);
}
