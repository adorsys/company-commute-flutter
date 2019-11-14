import 'package:company_commute/utils/colors.dart';
import 'package:company_commute/network/here_service.dart';
import 'package:flutter/material.dart';

class CommuteDetailScreen extends StatefulWidget {
  CommuteDetailScreen(
      {this.commuteDetailData,
      this.commuteColor,
      this.firstImage,
      this.imageKey});

  @required
  final CommuteDetailData commuteDetailData;
  @required
  final Color commuteColor;
  @required
  final Widget firstImage;
  @required
  final UniqueKey imageKey;

  @override
  _CommuteDetailScreenState createState() => _CommuteDetailScreenState();
}

class _CommuteDetailScreenState extends State<CommuteDetailScreen> {
  PageController pageController;
  Duration pageAnimationDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Commute from " + widget.commuteDetailData.title,
          overflow: TextOverflow.fade,
        ),
        centerTitle: true,
      ),
      body: Container(
        color: widget.commuteColor,
        child: PageView.builder(
          controller: pageController,
          itemCount: widget.commuteDetailData.commutes.length - 1,
          itemBuilder: (context, c) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  FloatingActionButton(
                      heroTag: null,
                      mini: true,
                      child: Icon(
                        Icons.chevron_left,
                        color: (c != 0) ? adorsysColor : Colors.grey,
                        size: 40,
                      ),
                      onPressed: () {
                        pageController.previousPage(
                            duration: pageAnimationDuration, curve: Curves.linear);
                      }),
                  Expanded(
                    child: Center(
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Wrap(
                            children: <Widget>[
                              Center(
                                child: Hero(
                                  tag: widget.imageKey,
                                  child: (c == 0)
                                      ? widget.firstImage
                                      : Image.network(
                                          widget.commuteDetailData.imageUrl[c],
                                          fit: BoxFit.fitWidth,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  widget.commuteDetailData.commutes[c],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                      heroTag: null,
                      mini: true,
                      child: Icon(
                        Icons.chevron_right,
                        color:
                            (c != widget.commuteDetailData.commutes.length - 2)
                                ? adorsysColor
                                : Colors.grey,
                        size: 40,
                      ),
                      onPressed: () {
                        pageController.nextPage(
                            duration: pageAnimationDuration, curve: Curves.linear);
                      })
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
