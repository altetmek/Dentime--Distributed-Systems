import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum Flavor {
  DEV,
  BETA,
  PRODUCTION,
  TEST,
}

class FlavorValues {
  final String baseUrl;
  const FlavorValues({@required this.baseUrl});
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color color;
  static FlavorConfig _instance;

  final String brokerUrl;
  final String baseTopic;

  factory FlavorConfig({
    @required Flavor flavor,
    @required String name,
    @required Color color,
    @required String brokerUrl,
    @required String baseTopic,
  }) =>
      _instance =
          FlavorConfig._internal(flavor, name, color, brokerUrl, baseTopic);

  FlavorConfig._internal(
      this.flavor, this.name, this.color, this.brokerUrl, this.baseTopic);

  static FlavorConfig get instance => _instance;

  bool isProduction() => _instance.flavor == Flavor.PRODUCTION;

  bool isDev() => _instance.flavor == Flavor.DEV;

  bool isBeta() => _instance.flavor == Flavor.BETA;

  bool isInTest() => _instance.flavor == Flavor.TEST;

  static bool get isInDebugMode {
    bool inDebugMode = !_instance.isProduction();

    return inDebugMode;
  }
}
