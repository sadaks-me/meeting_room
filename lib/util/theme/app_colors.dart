import 'package:flutter/material.dart';

class AppColors {
  static const white = const Color(0xffffffff);
  static const backgroud2 = const Color(0xffe0e2e2);
  static const brownGrey = const Color(0xff808080);
  static const primaryColor = const Color(0xff0071bc);
  static const darkishBlue = const Color(0xff004995);
  static const backgroud = const Color(0xff181e26);
  static const seafoamBlue = const Color(0xff78c6d1);
  static const robinSEggBlue = const Color(0xffa6e3ef);
  static const dustyRed = const Color(0xffce384d);
  static const lightBlueGrey = const Color(0xffc8d4d6);
  static const lightBlueGreyTwo = const Color(0xffbdd8db);
  static const fillDarker = const Color(0xff313131);
  static const fillDark = const Color(0xff3f3f3f);

  static List<ColorModel> appColors = [
    ColorModel(
      "white",
      white,
    ),
    ColorModel(
      "backgroud2",
      backgroud2,
    ),
    ColorModel(
      "brownGrey",
      brownGrey,
    ),
    ColorModel(
      "primaryColor",
      primaryColor,
    ),
    ColorModel(
      "darkishBlue",
      darkishBlue,
    ),
    ColorModel(
      "backgroud",
      backgroud,
    ),
    ColorModel(
      "seafoamBlue",
      seafoamBlue,
    ),
    ColorModel(
      "robinSEggBlue",
      robinSEggBlue,
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
      "lightBlueGreyTwo",
      lightBlueGreyTwo,
    ),
    ColorModel(
      "fillDarker",
      fillDarker,
    ),
    ColorModel(
      "fillDark",
      fillDark,
    )
  ];
}

class ColorModel {
  final String name;
  final Color color;

  ColorModel(this.name, this.color);
}
