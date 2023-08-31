import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 255, 131, 131),
);

final kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 91, 0, 0),
);

class AppTheme {
  var cardTheme = const CardTheme().copyWith(
    color: kColorScheme.secondaryContainer,
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  );

  var elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kColorScheme.primaryContainer,
      foregroundColor: kColorScheme.onPrimaryContainer,
    ),
  );

  var textTheme = const TextTheme().copyWith(
    titleLarge: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      color: kColorScheme.onSecondaryContainer,
      fontSize: 20,
    ),
    bodyMedium: GoogleFonts.montserrat(
      fontWeight: FontWeight.normal,
      color: kColorScheme.onSecondaryContainer,
      fontSize: 15,
    ),
  );

  var darkCardTheme = const CardTheme().copyWith(
    color: kDarkColorScheme.secondaryContainer,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  var darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kDarkColorScheme.primaryContainer,
      foregroundColor: kDarkColorScheme.onPrimaryContainer,
    ),
  );

  var darkTextTheme = const TextTheme().copyWith(
    titleLarge: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      color: kDarkColorScheme.onSecondaryContainer,
      fontSize: 20,
    ),
    bodyMedium: GoogleFonts.montserrat(
      fontWeight: FontWeight.normal,
      color: kDarkColorScheme.onSecondaryContainer,
      fontSize: 15,
    ),
  );
}