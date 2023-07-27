import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'colors.dart';

ThemeData lightTheme =ThemeData(
  fontFamily: 'Inter',
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  focusColor: lightFocusColor,
  scaffoldBackgroundColor: whiteColor,
  iconTheme: IconThemeData(
    color: silverColor
  ),
  appBarTheme: AppBarTheme(
      elevation: 0,
      titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold
      ),
      backgroundColor: whiteColor,
      iconTheme: const IconThemeData(
        color: Colors.black,
        size: 25,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: whiteColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      )
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: whiteColor,
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(
        fontSize: 10.sp,
        fontWeight:FontWeight.w300,
        color: silverColor
    ),
    bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight:FontWeight.w300,
        color: silverColor
    ),
    bodyLarge: TextStyle(
        fontSize: 20.sp,
        fontWeight:FontWeight.w300,
        color: silverColor
    ),
    titleLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight:FontWeight.w300,
        color: silverColor
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  fontFamily: 'Inter',
  primaryColor: containerColor,
  focusColor: darkFocusColor,
  scaffoldBackgroundColor: HexColor('#0F1828'),
  iconTheme: IconThemeData(
      color: whiteColor
  ),
  appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: HexColor('#0F1828'),
      titleTextStyle: TextStyle(
          color: whiteColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold
      ),
      iconTheme:  IconThemeData(
        color: whiteColor,
        size: 25,
      ),
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
  textTheme: TextTheme(
    bodySmall: TextStyle(
        fontSize: 10.sp,
        fontWeight:FontWeight.w300,
        color: whiteColor
    ),
    bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight:FontWeight.w300,
        color: whiteColor
    ),
    bodyLarge: TextStyle(
        fontSize: 20.sp,
        fontWeight:FontWeight.w300,
        color: whiteColor
    ),
    titleLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight:FontWeight.w300,
        color: whiteColor
    ),
  ),
);

