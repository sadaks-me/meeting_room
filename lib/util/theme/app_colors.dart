import 'package:flutter/material.dart';

class AppColors {
  static const white = const Color(0xffffffff);
  static const grey = const Color(0xffe0e2e2);
  static const brownGrey = const Color(0xff808080);
  static const indigoBlue = const Color(0xff0071bc);
  static const darkishBlue = const Color(0xff004995);
  static const black = const Color(0xff181e26);
  static const seaFoamBlue = const Color(0xff78c6d1);
  static const eggBlue = const Color(0xffa6e3ef);
  static const dustyRed = const Color(0xffce384d);
  static const lightBlueGrey = const Color(0xffbdd8db);
  static const darkBrown = const Color(0xff3f3f3f);

  static List<ColorModel> appColors = [
    ColorModel(
      "white",
      white,
    ),
    ColorModel(
      "grey",
      grey,
    ),
    ColorModel(
      "brownGrey",
      brownGrey,
    ),
    ColorModel(
      "indigoBlue",
      indigoBlue,
    ),
    ColorModel(
      "darkishBlue",
      darkishBlue,
    ),
    ColorModel(
      "black",
      black,
    ),
    ColorModel(
      "seaFoamBlue",
      seaFoamBlue,
    ),
    ColorModel(
      "eggBlue",
      eggBlue,
    ),
    ColorModel(
      "dustyRed",
      dustyRed,
    ),
    ColorModel(
      "lightBlueGrey",
      lightBlueGrey,
    ),
    ColorModel(
      "darkBrown",
      darkBrown,
    )
  ];
}

class ColorModel {
  final String name;
  final Color color;

  ColorModel(this.name, this.color);

  @override
  String toString() {
    return "$name ($color)";
  }
}
