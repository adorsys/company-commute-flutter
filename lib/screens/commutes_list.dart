import 'package:company_commute/data/repository.dart';
import 'package:company_commute/network/here_service.dart';
import 'package:company_commute/widget/commute_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommutesListScreen extends StatefulWidget {
  @override
  _CommutesListScreenState createState() => _CommutesListScreenState();
}

class _CommutesListScreenState extends State<CommutesListScreen> {
  // List holing all widgets to be displayed
  List<Widget> descriptionsWidgets = List<Widget>();

  @override
  void initState() {
    super.initState();
    Repository.instance.getFromCache().listen((latLon) async {
      CommuteDetailData commuteDetailData =
          await HereService.instance.getRouteDescription(latLon);
      if (this.mounted)
        setState(() {
          descriptionsWidgets.add(CommuteTile(
            context: context,
            commuteDetailData: commuteDetailData,
            geoPointStart: LatLng(latLon.latitude, latLon.longitude),
          ));
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Commutes List"),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Column(
              children: descriptionsWidgets,
            )
          ],
        ));
  }
}
