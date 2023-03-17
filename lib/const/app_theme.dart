import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riverpod/riverpod.dart';

final lightThemeProvider = Provider<AppTheme>((_) => AppTheme.light());
final darkThemeProvider = Provider<AppTheme>((_) => AppTheme.dark());

class AppTheme {
  late ThemeData theme;

  AppTheme.light() : this._internal(Brightness.light);
  AppTheme.dark() : this._internal(Brightness.dark);

  AppTheme._internal(Brightness brightness) {
    theme = _createTheme(brightness);
  }

  ThemeData _createTheme(Brightness brightness) => ThemeData(
        brightness: brightness,
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
        textTheme: GoogleFonts.mPlusRounded1cTextTheme(),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      );
}
