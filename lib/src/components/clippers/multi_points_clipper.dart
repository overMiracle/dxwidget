import 'package:dxwidget/src/components/clippers/index.dart';
import 'package:flutter/material.dart';

/// [DxMultiPointsClipper] is the clipper which extends the [CustomClipper]
/// and clips the edge of the container in zig-zag shape.
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
class DxMultiPointsClipper extends CustomClipper<Path> {
  final double heightOfPoint;
  final int numberOfPoints;
  final DxClipperSides side;

  DxMultiPointsClipper(
    this.side, {
    this.heightOfPoint = 12,
    this.numberOfPoints = 16,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    double x = 0.0;
    double y = size.height;
    double increment = size.width / numberOfPoints / 2;

    if (side == DxClipperSides.bottom || side == DxClipperSides.vertical) {
      while (x < size.width) {
        x += increment;
        y = (y == size.height) ? size.height - heightOfPoint : size.height;
        path.lineTo(x, y);
      }
    }
    path.lineTo(size.width, 0.0);

    x = size.width;
    y = 0.0;
    if (side == DxClipperSides.vertical) {
      while (x > 0) {
        x -= increment;
        y = (y == 0) ? 0 + heightOfPoint : 0;
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => oldClipper != this;
}
