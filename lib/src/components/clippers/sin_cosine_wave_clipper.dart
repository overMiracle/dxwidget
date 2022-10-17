import 'package:dxwidget/src/components/clippers/index.dart';
import 'package:flutter/material.dart';

/// [SinCosineWaveClipper] is the clipper which extends the [CustomClipper]
/// and clips the container in the shape of the sine cosine wave.
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
class DxSinCosineWaveClipper extends CustomClipper<Path> {
  final DxClipperVerticalPosition verticalPosition;
  final DxClipperHorizontalPosition horizontalPosition;

  DxSinCosineWaveClipper({
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
      path.lineTo(0.0, size.height - 20);

      firstControlPoint = Offset(size.width / 4, size.height);
      firstEndPoint = Offset(size.width / 2, size.height - 40.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

      secondControlPoint = Offset(size.width - (size.width / 3.25), size.height - 65);
      secondEndPoint = Offset(size.width, size.height - 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height - 40);
      path.lineTo(size.width, 0.0);
      path.close();
    } else if (verticalPosition == DxClipperVerticalPosition.bottom &&
        horizontalPosition == DxClipperHorizontalPosition.right) {
      path.lineTo(0.0, size.height - 40);
      firstControlPoint = Offset(size.width / 3.25, size.height - 65);
      firstEndPoint = Offset(size.width / 2, size.height - 40);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

      secondControlPoint = Offset(size.width / 1.25, size.height);
      secondEndPoint = Offset(size.width, size.height - 30);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height - 20);
      path.lineTo(size.width, 0.0);
      path.close();
    } else if (verticalPosition == DxClipperVerticalPosition.top &&
        horizontalPosition == DxClipperHorizontalPosition.right) {
      path.lineTo(0.0, 20);
      firstControlPoint = Offset(size.width / 3.25, 65);
      firstEndPoint = Offset(size.width / 2, 40);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

      secondControlPoint = Offset(size.width / 1.25, 0);
      secondEndPoint = Offset(size.width, 30);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    } else {
      path.lineTo(0.0, 20);

      firstControlPoint = Offset(size.width / 4, 0.0);
      firstEndPoint = Offset(size.width / 2, 40.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

      secondControlPoint = Offset(size.width - (size.width / 3.25), 65);
      secondEndPoint = Offset(size.width, 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => oldClipper != this;
}
