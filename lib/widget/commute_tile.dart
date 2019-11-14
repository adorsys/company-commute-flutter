
import 'package:company_commute/network/here_service.dart';
import 'package:company_commute/screens/commute_detail.dart';
import 'package:company_commute/widget/custom_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommuteTile extends StatelessWidget {
  const CommuteTile({
    Key key,
    @required this.context,
    @required this.commuteDetailData,
    @required this.geoPointStart,
  }) : super(key: key);

  final BuildContext context;
  final CommuteDetailData commuteDetailData;
  final LatLng geoPointStart;

  @override
  Widget build(BuildContext context) {
    Color randomColor = randomColorFromPoint(
        LatLng(geoPointStart.latitude, geoPointStart.longitude));
    UniqueKey uniqueImageKey = UniqueKey();

    String imageUrl = HereService.instance.getImageUrl(
        geoPointStart.latitude.toString(), geoPointStart.longitude.toString());
    Widget image = Image.network(
      imageUrl,
      width: 300,
      height: 300,
      fit: BoxFit.fitWidth,
    );
    return Wrap(
      children: <Widget>[
        Card(
          color: randomColor,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommuteDetailScreen(
                          commuteDetailData: commuteDetailData,
                          commuteColor: randomColor,
                          firstImage: image,
                          imageKey: uniqueImageKey,
                        )),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: <Widget>[
                  Hero(
                      tag: uniqueImageKey,
                      child: Container(height: 100, width: 100, child: image)),
                  Expanded(
                    child: Wrap(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            commuteDetailData.title,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          color: Colors.transparent,
        )
      ],
    );
  }
}
