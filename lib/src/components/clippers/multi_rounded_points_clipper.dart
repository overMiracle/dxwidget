import 'package:dxwidget/src/components/clippers/index.dart';
import 'package:flutter/material.dart';

/// [DxMultipleRoundedPointsClipper] is the clipper which extends the
/// [CustomClipper] and clips the edge of the container in circular points
/// shape.
///
/// [heightOfPoint] is the parameter which decides the height of the point.
/// Default value of height of point is [12.0].
///
/// [numberOfPoints] is the parameter which decides the number of points.
/// Default value of number of points is [16].
///
/// [DxClipperSides] is the parameter which decides the side of points [DxClipperSides.bottom] or
/// [DxClipperSides.vertical] on which side the container is to be clipped.
///
/// The [getClip] method is called whenever the custom clip needs to be updated.
///
/// The [shouldReclip] method is called when a new instance of the class
/// is provided, to check if the new instance actually represents different
/// information.
class DxMultipleRoundedPointsClipper extends CustomClipper<Path> {
  final DxClipperSides side;
  final int numberOfPoints;
  final double heightOfPoint;

  DxMultipleRoundedPointsClipper(
    this.side, {
    this.heightOfPoint = 12,
    this.numberOfPoints = 16,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    double x = 0;
    double y = size.height;
    double yControlPoint = size.height - heightOfPoint;
    double increment = size.width / numberOfPoints;

    if (side == DxClipperSides.bottom || side == DxClipperSides.vertical) {
      while (x < size.width) {
        path.quadraticBezierTo(x + increment / 2, yControlPoint, x + increment, y);
        x += increment;
      }
    }

    path.lineTo(size.width, 0.0);

    if (side == DxClipperSides.vertical) {
      while (x > 0) {
        path.quadraticBezierTo(x - increment / 2, heightOfPoint, x - increment, 0);
        x -= increment;
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => oldClipper != this;
}
