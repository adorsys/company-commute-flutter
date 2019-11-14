import 'dart:async';
import 'dart:convert';

import 'package:company_commute/utils/keys.dart';
import 'package:company_commute/widget/custom_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'here_response.dart';

/// The HereService is used as singleton
class HereService {
  HereService._privateConstructor();
  static final HereService _instance = HereService._privateConstructor();
  static HereService get instance {
    return _instance;
  }

  /// Returns null if no maneuvers are found 
  Future<List<Maneuver>> getManeuvers(LatLng latLng) async {
    try {
      HereResponse response = await HereService.instance.fetchHereResponse(latLng);
      return response.response.route[0].leg[0].maneuver;
    } catch (_) {
      return null;
    }
  }

  Future<HereResponse> fetchHereResponse(LatLng latLng) async {
    http.Response response = await getHereResponse(latLng);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return HereResponse.fromJson(jsonDecode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load HereResponse');
    }
  }

  Future<http.Response> getHereResponse(LatLng latLng) {
    String startLatLng =
        latLng.latitude.toString() + "," + latLng.longitude.toString();
    String endLatLng = adorsysLatLng.latitude.toString() +
        "," +
        adorsysLatLng.longitude.toString();

    String url = "https://route.api.here.com/routing/7.2/calculateroute.json"
            "?app_id=" +
        APP_ID +
        "&app_code=" +
        APP_CODE +
        "&waypoint0=" +
        startLatLng +
        "&waypoint1=" +
        endLatLng +
        "&mode=fastest;car"; //;bicycle but could lead to no road found!

    return http.get(url);
  }

  Future<CommuteDetailData> getRouteDescription(LatLng latLng) async {
    http.Response response = await getHereResponse(latLng);
    List<String> descriptionList = getDescriptionList(response);
    List<String> imageList = getImageList(response);
    String title = getTitle(response);

    CommuteDetailData commuteDetail =
        CommuteDetailData(descriptionList, imageList, title);
    return commuteDetail;
  }

  List<String> getDescriptionList(http.Response response) {
    String routeDescriptionJson = response.body;
    List<String> resultsDescription = List<String>();

    HereResponse hereResponse =
        HereResponse.fromJson(jsonDecode(routeDescriptionJson));
    hereResponse.response.route.first.leg.forEach((leg) {
      leg.maneuver.forEach((maneuver) {
        // Remove the HTML-Elemnts in the response
        String sub = maneuver.instruction;
        sub = sub.replaceAllMapped(RegExp("(?<=\<)(.*?)(?=\>)"), (_) {
          return "";
        });
        sub = sub.replaceAll("<", "");
        sub = sub.replaceAll(">", "");
        resultsDescription.add(sub);
      });
    });

    return resultsDescription;
  }

  String getTitle(http.Response response) {
    String routeStartNameJson = response.body;
    HereResponse hereResponse =
        HereResponse.fromJson(jsonDecode(routeStartNameJson));
    return hereResponse.response.route.first.waypoint.first.mappedRoadName;
  }

  List<String> getImageList(http.Response response) {
    String routeImageJson = response.body;
    List<String> resultsImageUrl = List<String>();
    HereResponse hereResponse =
        HereResponse.fromJson(jsonDecode(routeImageJson));
    hereResponse.response.route.first.leg.forEach((leg) {
      leg.maneuver.forEach((maneuver) {
        resultsImageUrl.add(HereService.instance.getImageUrl(
            maneuver.position.latitude.toString(),
            maneuver.position.longitude.toString()));
      });
    });
    return resultsImageUrl;
  }

  String getImageUrl(String latitude, String longitude) {
    return "https://image.maps.api.here.com/mia/1.6/mapview"
            "?app_id=" +
        APP_ID +
        "&app_code=" +
        APP_CODE +
        "&c=" +
        latitude +
        "," +
        longitude +
        "&t=0%20&z=15%20";
  }
}

// Data class for holding everything related to CommuteDetail
class CommuteDetailData {
  List<String> commutes;
  List<String> imageUrl;
  String title;

  CommuteDetailData(
      List<String> commutes, List<String> imageUrls, String title) {
    this.commutes = commutes;
    this.imageUrl = imageUrls;
    this.title = title;
  }
}
