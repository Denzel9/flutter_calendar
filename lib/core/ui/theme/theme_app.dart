import 'package:calendar_flutter/core/ui/styles/colors_app.dart';
import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  fontFamily: "inter",
  scaffoldBackgroundColor: ColorsApp.bg,
  appBarTheme: AppBarTheme(backgroundColor: ColorsApp.bg),
  primaryColor: ColorsApp.primary,
  primaryColorDark: ColorsApp.dark,
  textSelectionTheme: TextSelectionThemeData(selectionColor: ColorsApp.primary),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorsApp.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: ColorsApp.bg,
    primary: ColorsApp.primary,
    secondary: ColorsApp.secondary,
    error: ColorsApp.error,
  ),
);
