import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff1c863b);
const kSecondaryColor = Color(0xff212121);
const kHighLightColor = Color(0xffeef4ef);
const kSecondaryAccent = Color(0xff757784);

const kTextFieldStyle = TextStyle(
  fontFamily: 'SF-Pro',
  fontSize: 14.5,
  fontWeight: FontWeight.w500,
  height: 1.4,
);

const kLabelStyle = TextStyle(
  color: Color(0xff757784),
  fontFamily: 'SF-Pro',
  fontSize: 13.0,
  fontWeight: FontWeight.bold,
);

const kSectionHeaderStyle = TextStyle(
  fontFamily: 'SF-Pro',
  fontSize: 17.0,
  fontWeight: FontWeight.bold,
);

const kSubTitleStyle = TextStyle(
  color: Color(0xff757575),
  fontFamily: 'SF-Pro',
  fontSize: 13.0,
  fontWeight: FontWeight.w500,
);

// Light theme definition
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(primary: kPrimaryColor),
  iconTheme: const IconThemeData(color: kSecondaryColor),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 10.0,
    height: 70.0,
    iconTheme: const WidgetStatePropertyAll(
      IconThemeData(color: kSecondaryColor),
    ),
    indicatorColor: const Color(0xff66bb6a),
    backgroundColor: Colors.grey.shade100,
    surfaceTintColor: Colors.white,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: kPrimaryColor,
    indicatorColor: kPrimaryColor,
    dividerColor: kHighLightColor,
    labelStyle: TextStyle(fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    prefixIconColor: Colors.grey,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
  ),
);

// Dark theme definition
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(primary: kPrimaryColor),
  iconTheme: const IconThemeData(color: Colors.white),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 10.0,
    height: 70.0,
    iconTheme: const WidgetStatePropertyAll(
      IconThemeData(color: Colors.white),
    ),
    indicatorColor: const Color(0xff66bb6a),
    backgroundColor: Colors.grey.shade900,
    surfaceTintColor: Colors.black,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: kPrimaryColor,
    indicatorColor: kPrimaryColor,
    dividerColor: kHighLightColor,
    labelStyle: TextStyle(fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    prefixIconColor: Colors.grey,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
);
