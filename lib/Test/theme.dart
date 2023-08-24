import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData customTheme() {
  return ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
  );
}
