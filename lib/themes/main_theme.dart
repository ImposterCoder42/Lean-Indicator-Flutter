import 'package:flutter/material.dart';

const Color darkRoyalPurple = Color(0xFF3D1A78); // Btn Color darkmode
const Color darkPurple = Color.fromARGB(255, 87, 80, 99); // Btn Color lightmode
const Color steelBlue = Color.fromARGB(189, 178, 246, 255); // btn fnt clr light

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Marty',
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 8,
    backgroundColor: Color.fromARGB(80, 111, 111, 111),
    titleTextStyle: TextStyle(
      fontFamily: 'Marty',
      fontSize: 44,
      color: Colors.white,
      fontWeight: FontWeight.normal,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkRoyalPurple.withValues(alpha: .8),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 26, fontFamily: "Marty"),
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.grey[850],
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(12),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 50, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontSize: 40),
    labelLarge: TextStyle(fontSize: 22),
  ),
  tooltipTheme: TooltipThemeData(
    textStyle: TextStyle(fontSize: 22, fontFamily: 'Marty'),
    decoration: BoxDecoration(
      color: darkPurple,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(textStyle: TextStyle(fontSize: 26)),
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Marty',
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 8,
    backgroundColor: Colors.grey[100],
    titleTextStyle: TextStyle(
      fontFamily: 'Marty',
      fontSize: 44,
      color: Colors.black,
      fontWeight: FontWeight.normal,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkPurple.withValues(alpha: .8),
      foregroundColor: steelBlue, // <-- TEXT COLOR
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 26, fontFamily: "Marty"),
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.grey[850],
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(12),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 50, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontSize: 40),
    labelLarge: TextStyle(fontSize: 22),
  ),
  tooltipTheme: TooltipThemeData(
    textStyle: TextStyle(
      fontSize: 22,
      fontFamily: 'Marty',
      color: Colors.black,
    ),
    decoration: BoxDecoration(
      color: steelBlue,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: TextStyle(color: Colors.black),
  ),
);
