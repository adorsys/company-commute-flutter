/// Generated from json
class HereResponse {
  Response response;

  HereResponse({this.response});

  HereResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  List<Route> route;

  Response({this.route});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['route'] != null) {
      route = new List<Route>();
      json['route'].forEach((v) {
        route.add(new Route.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.route != null) {
      data['route'] = this.route.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Route {
  List<Waypoint> waypoint;
  List<Leg> leg;
  Summary summary;

  Route({this.waypoint, this.leg, this.summary});

  Route.fromJson(Map<String, dynamic> json) {
    if (json['waypoint'] != null) {
      waypoint = new List<Waypoint>();
      json['waypoint'].forEach((v) {
        waypoint.add(new Waypoint.fromJson(v));
      });
    }
    if (json['leg'] != null) {
      leg = new List<Leg>();
      json['leg'].forEach((v) {
        leg.add(new Leg.fromJson(v));
      });
    }
    summary =
        json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.waypoint != null) {
      data['waypoint'] = this.waypoint.map((v) => v.toJson()).toList();
    }
    if (this.leg != null) {
      data['leg'] = this.leg.map((v) => v.toJson()).toList();
    }
    if (this.summary != null) {
      data['summary'] = this.summary.toJson();
    }
    return data;
  }
}

class Waypoint {
  String linkId;
  MappedPosition mappedPosition;
  OriginalPosition originalPosition;
  String mappedRoadName;

  Waypoint({this.linkId, this.mappedPosition, this.originalPosition});

  Waypoint.fromJson(Map<String, dynamic> json) {
    linkId = json['linkId'];
    mappedRoadName = json['mappedRoadName'];
    mappedPosition = json['mappedPosition'] != null
        ? new MappedPosition.fromJson(json['mappedPosition'])
        : null;
    originalPosition = json['originalPosition'] != null
        ? new OriginalPosition.fromJson(json['originalPosition'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['linkId'] = this.linkId;
    if (this.mappedPosition != null) {
      data['mappedPosition'] = this.mappedPosition.toJson();
    }
    if (this.originalPosition != null) {
      data['originalPosition'] = this.originalPosition.toJson();
    }
    return data;
  }
}

class MappedPosition {
  double latitude;
  double longitude;

  MappedPosition({this.latitude, this.longitude});

  MappedPosition.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class OriginalPosition {
  double latitude;
  double longitude;

  OriginalPosition({this.latitude, this.longitude});

  OriginalPosition.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Leg {
  List<Maneuver> maneuver;

  Leg({this.maneuver});

  Leg.fromJson(Map<String, dynamic> json) {
    if (json['maneuver'] != null) {
      maneuver = new List<Maneuver>();
      json['maneuver'].forEach((v) {
        maneuver.add(new Maneuver.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.maneuver != null) {
      data['maneuver'] = this.maneuver.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Maneuver {
  Position position;
  String instruction;
  String id;

  Maneuver({this.position, this.instruction, this.id});

  Maneuver.fromJson(Map<String, dynamic> json) {
    position = json['position'] != null
        ? new Position.fromJson(json['position'])
        : null;
    instruction = json['instruction'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.position != null) {
      data['position'] = this.position.toJson();
    }
    data['instruction'] = this.instruction;
    data['id'] = this.id;
    return data;
  }
}

class Position {
  double latitude;
  double longitude;

  Position({this.latitude, this.longitude});

  Position.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Summary {
  int distance;
  int baseTime;
  List<String> flags;
  String text;
  int travelTime;

  Summary(
      {this.distance, this.baseTime, this.flags, this.text, this.travelTime});

  Summary.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    baseTime = json['baseTime'];
    flags = json['flags'].cast<String>();
    text = json['text'];
    travelTime = json['travelTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    data['baseTime'] = this.baseTime;
    data['flags'] = this.flags;
    data['text'] = this.text;
    data['travelTime'] = this.travelTime;
    return data;
  }
}
