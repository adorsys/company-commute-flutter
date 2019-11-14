import 'dart:convert';

import 'package:company_commute/network/here_request.dart';
import 'package:flutter/material.dart';

// Trigger with: showSearch(context: context, delegate: AddressSearchDelegate());
// Returns here locationId on success and null on fail
class AddressSearchDelegate extends SearchDelegate {
  AddressSearchDelegate({this.currentAddress});

  String currentAddress;
  bool addressSet = false;
  // Is needed if the user pressed the check button an chooses the first result
  Map firstLocationId = Map();
  DateTime _lastKeyPress = DateTime.fromMillisecondsSinceEpoch(0);
  List<Widget> _resultsWidgets = List<Widget>();

  @override
  List<Widget> buildActions(BuildContext context) {
    if (currentAddress != null && !addressSet) {
      query = currentAddress;
      addressSet = true;
    }
    return [
      IconButton(
        icon: Icon(Icons.done),
        onPressed: () {
          if (firstLocationId.isNotEmpty) close(context, firstLocationId);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Do noting and keep current results displayed
    return _buildResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Check if the last key press was pressed half a second ago.
    // If the user is typing fast there would be a request send
    // for every key press. So the api calls are not used unnecessary.
    if (_lastKeyPress
        .add(Duration(milliseconds: 500))
        .isBefore(DateTime.now())) {
      _lastKeyPress = DateTime.now();
      return FutureBuilder(
        future: HereRequest.instance.getHereResponse(
            query: "query=" + query + "&resultType=houseNumber"),
        builder: (context, response) {
          if (response.connectionState == ConnectionState.done) {
            String contentString = response.data.body as String;
            final parsed = json.decode(contentString);
            // Parse json response and build widget list
            if (parsed.toString() != "{}") {
              List<dynamic> results = List<dynamic>();
              results = parsed["suggestions"];
              if (results.isNotEmpty) firstLocationId = results.first;
              _resultsWidgets = List<Widget>();
              results.forEach((resultLocation) {
                _resultsWidgets.add(ListTile(
                  title: Text(resultLocation["label"]),
                  onTap: () {
                    close(context, resultLocation);
                  },
                ));
              });
              return _buildResults();
            }
          }
          return Container();
        },
      );
    }
    return _buildResults();
  }

  Widget _buildResults() {
    return ListView.builder(
      itemCount: _resultsWidgets.length,
      itemBuilder: (context, count) {
        return _resultsWidgets[count];
      },
    );
  }
}
