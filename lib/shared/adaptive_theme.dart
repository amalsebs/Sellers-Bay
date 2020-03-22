import 'package:flutter/material.dart';

final ThemeData _androidTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.deepPurple,
  accentColor: Colors.indigoAccent,
  buttonColor: Colors.indigo,
);

final ThemeData _iOSTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  accentColor: Colors.blue,
  buttonColor: Colors.blue,
);

ThemeData getAdaptiveTheme(context) {
  return Theme.of(context).platform == TargetPlatform.iOS
      ? _iOSTheme
      : _androidTheme;
}
