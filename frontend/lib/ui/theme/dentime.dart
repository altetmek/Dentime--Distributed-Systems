import 'package:flutter/material.dart';

class DentimeApplicationTheme {
  DentimeApplicationTheme._();

  // Colours
  static const Color primaryColor = Colors.blue;
  static const Color nearlyBlack = Color(0xff333333);
  static const Color nearlyWhite = Color(0xFFFDFDFD);
  static const Color bottomBar = purple;
  static const Color appBar = purple;
  static const Color onBoarding = Color(0xff7C05A6);

  static const Color primaryTextColor = Colors.white;

  static const Color gold = Color(0xffbc9e6c);
  static const Color purple = Colors.deepPurple;

  // Dimensions
  static const int navBarMaxWidth = 1200;

  //TextStyles:

  static const String fontName = 'Robotto';

  static const TextTheme textTheme = TextTheme(
    headline4: headline4,
    headline5: headline5,
    headline6: headline6,
    subtitle2: subtitle2,
    bodyText2: bodyText2,
    bodyText1: bodyText1,
    caption: caption,
  );

  static const TextStyle headline4 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    decoration: TextDecoration.none,
  );

  static const TextStyle headline5 = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    decoration: TextDecoration.none,
  );

  static const TextStyle headline6 = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    decoration: TextDecoration.none,
  );

  static const TextStyle subtitle2 = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    decoration: TextDecoration.none,
  );

  static const TextStyle bodyText2 = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: primaryTextColor,
    decoration: TextDecoration.none,
  );

  static const TextStyle bodyText1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w800,
    fontSize: 20,
    letterSpacing: -0.05,
    decoration: TextDecoration.none,
    color: nearlyBlack,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    decoration: TextDecoration.none,
  );
}
