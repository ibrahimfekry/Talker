import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

ThemeData lightTheme =ThemeData(
  fontFamily: 'Inter',
  scaffoldBackgroundColor: scaffoldColorLight,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: scaffoldColorLight,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: scaffoldColorLight,
      systemNavigationBarIconBrightness: Brightness.dark,
    )
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: scaffoldColorLight,
  ),
);

ThemeData darkTheme = ThemeData(
  fontFamily: 'Inter',
  scaffoldBackgroundColor: scaffoldColorDark,
  appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: scaffoldColorDark,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: scaffoldColorDark,
        systemNavigationBarIconBrightness: Brightness.light,
      )
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: scaffoldColorDark,
  ),
);