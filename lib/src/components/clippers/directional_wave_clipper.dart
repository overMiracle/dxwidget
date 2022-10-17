import 'package:dxwidget/src/components/clippers/index.dart';
import 'package:flutter/material.dart';

/// [DxDirectionalWaveClipper] is the clipper which extends the [CustomClipper]
/// and clips the container in the shape of the wave.
///
/// [DxClipperVerticalPosition] is the parameter which decides the vertical position
/// [DxClipperVerticalPosition.top] or [DxClipperVerticalPosition.bottom] from the the container
/// is to be clipped.
/// Default value of Vertical Position is [DxClipperVerticalPosition.bottom]
///
/// [DxClipperHorizontalPosition] is the parameter which decides the horizontal position
/// [DxClipperHorizontalPosition.left] or [DxClipperHorizontalPosition.right] from the the
/// container is be clipped.
/// Default value of Horizontal Position is [DxClipperHorizontalPosition.left]
///
/// The [getClip] method is called whenever the custom clip needs to be updated.
///
/// The [shouldReclip] method is called when a new instance of the class
/// is provided, to check if the new instance actually represents different
/// information.
class DxDirectionalWaveClipper extends CustomClipper<Path> {
  final DxClipperVerticalPosition verticalPosition;
  final DxClipperHorizontalPosition horizontalPosition;

  DxDirectionalWaveClipper({
    this.verticalPosition = DxClipperVerticalPosition.bottom,
    this.horizontalPosition = DxClipperHorizontalPosition.left,
  });

  @override
  Path getClip(Size size) {
    var path = Path();
    Offset firstControlPoint;
    Offset firstEndPoint;
    Offset secondControlPoint;
    Offset secondEndPoint;
    if (verticalPosition == DxClipperVerticalPosition.bottom &&
        horizontalPosition == DxClipperHorizontalPosition.left) {
      firstEndPoint = Offset(size.width * .5, size.height - 20);
      firstControlPoint = Offset(size.width * .25, size.height - 30);
      secondEndPoint = Offset(size.width, size.height - 50);
      secondControlPoint = Offset(size.width * .75, size.height - 10);

      path
        ..lineTo(0.0, size.height)
        ..quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
        ..quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
        ..lineTo(size.width, 0.0)
        ..close();
    } else if (verticalPosition == DxClipperVerticalPosition.bottom &&
        horizontalPosition == DxClipperHorizontalPosition.right) {
      firstEndPoint = Offset(size.width * .5, size.height - 20);
      firstControlPoint = Offset(size.width * .25, size.height - 10);
      secondEndPoint = Offset(size.width, size.height);
      secondControlPoint = Offset(size.width * .75, size.height - 30);

      path
        ..lineTo(0.0, size.height - 30)
        ..quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
        ..quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
        ..lineTo(size.width, 0.0)
        ..close();
    } else if (verticalPosition == DxClipperVerticalPosition.top &&
        horizontalPosition == DxClipperHorizontalPosition.right) {
      firstEndPoint = Offset(size.width * .5, 20);
      firstControlPoint = Offset(size.width * .25, 10);
      secondEndPoint = Offset(size.width, 0);
      secondControlPoint = Offset(size.width * .75, 30);

      path
        ..lineTo(0, 30)
        ..quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
        ..quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
        ..lineTo(size.width, size.height)
        ..lineTo(0.0, size.height)
        ..close();
    } else {
      firstEndPoint = Offset(size.width * .5, 20);
      firstControlPoint = Offset(size.width * .25, 30);
      secondEndPoint = Offset(size.width, 50);
      secondControlPoint = Offset(size.width * .75, 10);

      path
        ..quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
        ..quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
        ..lineTo(size.width, size.height)
        ..lineTo(0.0, size.height)
        ..close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => oldClipper != this;
}
