import 'package:flutter/material.dart';
import 'package:dentime/util/env/flavour_config.dart';

class Log {
  static Function(Object obj) printToConsole = print;

  Log._();

  static d(String message) {
    if (FlavorConfig.isInDebugMode) {
      printToConsole('🐛 - ${DateTime.now()} - $message');
    }
  }

  static warning(String message) {
    if (FlavorConfig.isInDebugMode) {
      printToConsole('⚠️ $message');
    }
  }

  static e({@required String message, @required error}) {
    if (FlavorConfig.isInDebugMode) {
      final sb = StringBuffer()..writeln('---⛔ ERROR ⛔---')..writeln(message);
      if (error is Error && error.stackTrace != null) {
        sb..writeln(error.toString())..writeln(error.stackTrace);
      } else if (error != null) {
        sb.writeln(error);
      }
      sb.writeln('-----------------');
      printToConsole(sb.toString());
    }
  }

  static i(String message) {
    if (FlavorConfig.isInDebugMode) {
      printToConsole('💡️ $message');
    }
  }

  static verbose(String message) {
    if (FlavorConfig.isInDebugMode) {
      printToConsole('$message');
    }
  }
}
