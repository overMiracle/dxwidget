import 'package:flutter/material.dart';

/// The painter widget to render the right clip path of the timeline item
class DxBubbleTimelineRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path
      ..lineTo(0, size.height)
      ..lineTo(size.width / 2 + 3, size.height)
      ..lineTo(size.width / 2 + 3, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// The painter widget to render the left clip path of the timeline item
class DxBubbleTimelineLeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2 - 3, size.height)
      ..lineTo(size.width / 2 - 3, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
