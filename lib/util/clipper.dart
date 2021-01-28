import 'package:flutter/material.dart';

class RectClipper extends CustomClipper<Rect> {
  RectClipper();

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width - 0, size.height - 0);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
