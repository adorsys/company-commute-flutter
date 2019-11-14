import 'dart:math';

import 'package:flutter/material.dart';

class QuarterCircleButton extends StatelessWidget {
  @required
  final Widget child;
  @required
  final CircleAlignment circleAlignment;
  @required
  final Color backgroundColor;
  @required
  final double width;
  @required
  final double height;

  const QuarterCircleButton(
      {this.child,
      @required this.circleAlignment,
      this.backgroundColor,
      this.width = 80,
      this.height = 80});

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: circleAlignment == CircleAlignment.topLeft
            ? Alignment.topLeft
            : circleAlignment == CircleAlignment.topRight
                ? Alignment.topRight
                : circleAlignment == CircleAlignment.bottomLeft
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
        children: <Widget>[
          SizedBox(
            height: height,
            width: width,
            child: QuarterCircle(
                color: backgroundColor, circleAlignment: circleAlignment),
          ),
          SizedBox(
              height: height - (height / 4),
              width: width - (width / 4),
              child: Align(
                alignment: circleAlignment == CircleAlignment.topLeft
                    ? Alignment.topLeft
                    : circleAlignment == CircleAlignment.topRight
                        ? Alignment.topRight
                        : circleAlignment == CircleAlignment.bottomLeft
                            ? Alignment.bottomLeft
                            : Alignment.bottomRight,
                child: Padding(
                    padding: EdgeInsets.only(
                        bottom: 16.0, right: 16.00, left: 16.00),
                    child: child),
              ))
        ]);
  }
}

enum CircleAlignment {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class QuarterCircle extends StatelessWidget {
  final CircleAlignment circleAlignment;
  final Color color;

  const QuarterCircle({
    this.color = Colors.grey,
    this.circleAlignment = CircleAlignment.topLeft,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRect(
        child: CustomPaint(
          painter: QuarterCirclePainter(
            circleAlignment: circleAlignment,
            color: color,
          ),
        ),
      ),
    );
  }
}

class QuarterCirclePainter extends CustomPainter {
  final CircleAlignment circleAlignment;
  final Color color;

  const QuarterCirclePainter({this.circleAlignment, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.height, size.width);
    final offset = circleAlignment == CircleAlignment.topLeft
        ? Offset(.0, .0)
        : circleAlignment == CircleAlignment.topRight
            ? Offset(size.width, .0)
            : circleAlignment == CircleAlignment.bottomLeft
                ? Offset(.0, size.height)
                : Offset(size.width, size.height);
    canvas.drawCircle(offset, radius, Paint()..color = color);
  }

  @override
  bool shouldRepaint(QuarterCirclePainter oldDelegate) {
    return color == oldDelegate.color &&
        circleAlignment == oldDelegate.circleAlignment;
  }
}
