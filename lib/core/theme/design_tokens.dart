import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AhmedBabaTokens {
  // --- ALIBABA OFFICIAL COLOR PALETTE ---
  static const Color primary = Color(0xFFFF6600); // The "Trade Orange"
  static const Color secondary = Color(0xFF0066CC); // The "Link Blue"
  static const Color accent = Color(0xFFFF9900); // Highlight Orange
  
  static const Color background = Color(0xFFF2F2F2); // Page Body Grey
  static const Color surface = Colors.white; 
  
  static const Color textPrimary = Color(0xFF222222); // Deep Black
  static const Color textSecondary = Color(0xFF666666); // Subtitle Grey
  static const Color textHint = Color(0xFF999999); // Placeholder Grey
  
  static const Color border = Color(0xFFE5E5E5); // Divider Grey
  static const Color success = Color(0xFF00B04F); // Success Green
  static const Color error = Color(0xFFD93025); // Error Red
  static const Color warning = Color(0xFFFF9500); // Warning Amber

  // --- TYPOGRAPHY (Pixel Perfect Inter/Roboto Blend) ---
  // Alibaba uses a custom sans-serif, Inter is the closest open-source match.
  
  static TextStyle get displayLarge => GoogleFonts.inter(
    fontSize: 24, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: -0.8);

  static TextStyle get headlineMedium => GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary, letterSpacing: -0.2);

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400, color: textPrimary, height: 1.4);

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400, color: textSecondary, height: 1.3);

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 10, fontWeight: FontWeight.w600, color: textHint, letterSpacing: 0.2);

  static TextStyle get priceStyle => GoogleFonts.inter(
    fontSize: 20, fontWeight: FontWeight.w900, color: primary, letterSpacing: -0.5);

  static TextStyle get priceSubStyle => GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w800, color: primary);

  // --- DECORATIONS (Ali Style) ---
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    )
  ];

  static BorderRadius get cardRadius => BorderRadius.circular(12);
  static BorderRadius get pillRadius => BorderRadius.circular(20);
}
