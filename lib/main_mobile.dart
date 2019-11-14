import 'package:company_commute/screens/add_commute.dart';
import 'package:company_commute/screens/commutes_list.dart';
import 'package:company_commute/utils/colors.dart';
import 'package:company_commute/data/repository.dart';
import 'package:company_commute/widget/custom_map.dart';
import 'package:company_commute/widget/quarter_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

start() => runApp(CommuteApp());

class CommuteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Company Commute',
        theme: ThemeData(
            primarySwatch: adorsysColor,
            floatingActionButtonTheme:
                FloatingActionButtonThemeData(backgroundColor: Colors.white)),
        home: MainMobileScreen(title: 'Flutter Company Commute'));
  }
}

class MainMobileScreen extends StatefulWidget {
  MainMobileScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainMobileScreenState createState() => _MainMobileScreenState();
}

class _MainMobileScreenState extends State<MainMobileScreen> {
  GlobalKey mainMapKey = GlobalKey<CustomMapState>();
  GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    Repository.instance.getFromWS().listen((latLon) {
      setState(() {
        drawManeuversFromResult(mainMapKey, latLon);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CommutesListScreen()),
              );
            },
          )
        ],
      ),
      body: Stack(children: <Widget>[
        CustomMap(
          key: mainMapKey,
          onMapCreated: _onMapCreated,
        ),
        GestureDetector(
            child: Container(
                alignment: Alignment.bottomLeft,
                child: QuarterCircleButton(
                  child: Image.asset('assets/adorsys_centered.png'),
                  backgroundColor: adorsysColor,
                  circleAlignment: CircleAlignment.bottomLeft,
                )),
            onTap: () async {
              removePolylines(mainMapKey);
              mainMapKey.currentState.setState(() {});
              smallZoom(mapController);
              await redrawPolylineOnMap(mainMapKey, 500);
              bigZoom(mapController);
            }),
        GestureDetector(
            child: Container(
                alignment: Alignment.bottomRight,
                child: QuarterCircleButton(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: adorsysColor,
                  circleAlignment: CircleAlignment.bottomRight,
                )),
            onTap: () async {
              LatLng result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddCommuteScreen()));

              if (result == null) return;
              await drawManeuversFromResult(mainMapKey, result);
              zoomAnimation(mapController);
            })
      ]),
    );
  }

  // Callback required by Google Maps
  void _onMapCreated(GoogleMapController controller) {
    loadCustomMapStyle(controller);
    setState(() {
      mapController = controller;
      bigZoom(mapController);
    });
  }
}
