import 'package:company_commute/network/here_request.dart';
import 'package:company_commute/utils/colors.dart';
import 'package:company_commute/data/repository.dart';
import 'package:company_commute/widget/address_search_delegate.dart';
import 'package:company_commute/widget/custom_map.dart';
import 'package:company_commute/widget/quarter_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddCommuteScreen extends StatefulWidget {
  @override
  _AddCommuteScreenState createState() => _AddCommuteScreenState();
}

class _AddCommuteScreenState extends State<AddCommuteScreen> {
  // The addCommuteMapKey is needed to access the map state
  GlobalKey _addCommuteMapKey = GlobalKey<CustomMapState>();
  // The mapController is neede to manipulate the map
  GoogleMapController _mapController;
  LatLng _result;
  String _currentAddress;

  /// Needed for allocation the mapController
  _onMapCreated(GoogleMapController controller) {
    loadCustomMapStyle(controller);
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add address"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              // Calls search Delegate
              var resultLocation = await showSearch(
                  context: context,
                  delegate:
                      AddressSearchDelegate(currentAddress: _currentAddress));
              // Checks is result is no null and draws it on map
              if (resultLocation != null) {
                _currentAddress = resultLocation["label"];
                _result = await HereRequest.instance.getLatLngFromLocationId(
                    resultLocation["locationId"]);
                if (_result != null) {
                  removePolylines(_addCommuteMapKey);
                  await drawManeuversFromResult(_addCommuteMapKey, _result);
                  smallZoom(_mapController);
                  return;
                }
              }
            },
          ),
        ],
      ),
      body: Stack(children: <Widget>[
        CustomMap(
          key: _addCommuteMapKey,
          onMapCreated: _onMapCreated,
        ),
        // Display safe button only if adress is found
        (_currentAddress != null)
            ? GestureDetector(
                child: Container(
                    alignment: Alignment.bottomRight,
                    child: QuarterCircleButton(
                      child: Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      backgroundColor: adorsysColor,
                      circleAlignment: CircleAlignment.bottomRight,
                    )),
                onTap: () {
                  // Saves the new adress
                  Repository.instance.setLatLon(_result);
                  Navigator.pop(context, _result);
                })
            : Container(),
      ]),
    );
  }
}
