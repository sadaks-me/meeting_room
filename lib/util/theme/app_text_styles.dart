import 'package:flutter/material.dart';

import 'app_colors.dart';

/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5

class AppTextStyles {
  static const headingTypeA = const TextStyle(
      color: const Color(0xff000000),
      fontWeight: FontWeight.w500,
      fontFamily: "PublicSans",
      fontStyle: FontStyle.normal,
      fontSize: 16.0);

  static const activeTab = const TextStyle(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w700,
      fontFamily: "PublicSans",
      fontStyle: FontStyle.normal,
      fontSize: 14.0);

  static const headingStyleB = const TextStyle(
      color: const Color(0xff000000),
      fontWeight: FontWeight.w700,
      fontFamily: "PublicSans",
      fontStyle: FontStyle.normal,
      fontSize: 14.0);

  static const articleListTitle = const TextStyle(
      color: const Color(0xff000000),
      fontWeight: FontWeight.w400,
      fontFamily: "PublicSans",
      fontStyle: FontStyle.normal,
      fontSize: 14.0);

  static const inactiveTab = const TextStyle(
      color: AppColors.brownGrey,
      fontWeight: FontWeight.w400,
      fontFamily: "PublicSans",
      fontStyle: FontStyle.normal,
      fontSize: 14.0);

  static const textLink = const TextStyle(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w700,
      fontFamily: "PublicSans",
      fontStyle: FontStyle.normal,
      fontSize: 12.0);

  static const bodyCopyTypeA = const TextStyle(
      color: const Color(0xff000000),
      fontWeight: FontWeight.w300,
      fontFamily: "PublicSans",
      fontStyle: FontStyle.normal,
      fontSize: 12.0);

  static const factcheckerTitle = const TextStyle(
      color: const Color(0xff000000),
      fontWeight: FontWeight.w400,
      fontFamily: "PublicSans",
      fontStyle: FontStyle.normal,
      fontSize: 10.0);

  static const arterialInfo = const TextStyle(
      color: AppColors.brownGrey,
      fontWeight: FontWeight.w400,
      fontFamily: "PublicSans",
      fontStyle: FontStyle.normal,
      fontSize: 10.0);

  static const disabled = const TextStyle(
      color: const Color(0xff99bac6),
      fontWeight: FontWeight.w500,
      fontFamily: "PublicSans",
      fontStyle: FontStyle.normal,
      fontSize: 9.0);

  static const timestamp = const TextStyle(
      color: AppColors.brownGrey,
      fontWeight: FontWeight.w400,
      fontFamily: "PublicSans",
      fontStyle: FontStyle.normal,
      fontSize: 8.0);
}
