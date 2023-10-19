import 'package:bottom/main.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light();

ThemeData darkTheme = ThemeData.dark();

ThemeData dark = ThemeData().copyWith(
    colorScheme: kColorScheme,
    brightness: Brightness.dark,
    useMaterial3: true,
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: Colors.black,
      foregroundColor: kColorScheme.primaryContainer,
    ),
    drawerTheme:
        ThemeData().drawerTheme.copyWith(backgroundColor: Colors.black),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kColorScheme.primaryContainer,
      ),
    ),
    timePickerTheme: ThemeData().timePickerTheme.copyWith(
          dialBackgroundColor: kColorScheme.primaryContainer,
          hourMinuteTextStyle: TextStyle(fontSize: 50),
          backgroundColor: Colors.white,
        ),
    iconTheme: ThemeData().iconTheme.copyWith(
          color: Colors.white,
          size: 35,
        ),
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    primaryColor: Colors.grey[200],
    scaffoldBackgroundColor: Colors.black);

ThemeData light = ThemeData().copyWith(
    primaryColor: Colors.grey[400],
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: kColorScheme,
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    dialogTheme:
        ThemeData().dialogTheme.copyWith(backgroundColor: Colors.white),
    timePickerTheme: ThemeData().timePickerTheme.copyWith(
          dialBackgroundColor: kColorScheme.primaryContainer,
          hourMinuteTextStyle: TextStyle(fontSize: 50),
          backgroundColor: Colors.white,
        ),
    drawerTheme:
        ThemeData().drawerTheme.copyWith(backgroundColor: Colors.white),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kColorScheme.primaryContainer,
      ),
    ),
    iconTheme: ThemeData().iconTheme.copyWith(
          color: const Color.fromRGBO(0, 0, 0, 1),
          size: 35,
        ),
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    scaffoldBackgroundColor: Colors.white);

final List<Color> colorsk = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.orange,
  Colors.pink,
  Colors.purple,
  Colors.black,
  Colors.white,
  Colors.grey,
  Color(0xFF3366FF), // Custom blue
  Color(0xFFFF6633), // Custom orange
  Color(0xFF99CC00), // Custom green
  Color(0xFFCC6699), // Custom pink
  Color(0xFFFF33CC), // Custom magenta
  Color(0xFF0099CC), // Custom cyan
  Color(0xFF663399), // Custom violet
];
