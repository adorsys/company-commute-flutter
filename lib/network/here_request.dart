import 'dart:async';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:company_commute/utils/keys.dart';

/// The HereRequest is used as singelton
class HereRequest {
  HereRequest._privateConstructor();
  static final HereRequest _instance = HereRequest._privateConstructor();
  static HereRequest get instance {
    return _instance;
  }

  Future<Response> getHereResponse(
      {String domain = "autocomplete.geocoder.api.here.com/6.2/suggest.json",
      String query = ""}) {
    var url = "https://" +
        domain +
        "?app_id=" +
        APP_ID +
        "&app_code=" +
        APP_CODE +
        "&" +
        query;

    return get(url);
  }

  Future<LatLng> getLatLngFromLocationId(String locationId) async {
    var url = "http://geocoder.api.here.com/6.2/geocode.json?locationid=" +
        locationId +
        "&app_id=" +
        APP_ID +
        "&app_code=" +
        APP_CODE;

    Response response = await get(url);
    String responseString = response.body.toString();
    String startWord = '"DisplayPosition":{"Latitude":';
    String endWord = "},";

    // Filter the latitude and longitude from the json
    try {
      int startIndex = responseString.indexOf(startWord);
      int endIndex = responseString.indexOf(endWord, startIndex);
      String newJson =
          "{" + responseString.substring(startIndex, endIndex) + "}}";
      var jsonObj = jsonDecode(newJson);
      double latitude = (jsonObj["DisplayPosition"]["Latitude"]);
      double longitude = (jsonObj["DisplayPosition"]["Longitude"]);

      return LatLng(latitude, longitude);
    } catch (_) {
      return null;
    }
  }
}
