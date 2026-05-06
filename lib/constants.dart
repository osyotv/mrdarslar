import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF09090B); // Zinc-950
  static const Color surface = Color(0xFF18181B); // Zinc-900
  static const Color surfaceLight = Color(0xFF27272A); // Zinc-800
  
  static const Color primary = Color(0xFF3B82F6); // Premium Blue
  static const Color secondary = Color(0xFF6366F1); // Indigo
  static const Color accent = Color(0xFF26D0CE); // Teal accent
  
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFA1A1AA); // Zinc-400
  static const Color textMuted = Color(0xFF71717A); // Zinc-500

  static const Color success = Color(0xFF10B981); // Emerald-500
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color warning = Color(0xFFF59E0B); // Amber-500
}

class AppStyles {
  static TextStyle get heading1 => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get heading2 => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get title => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: AppColors.textMuted,
      );
      
  static TextStyle get codeStyle => GoogleFonts.firaCode(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.accent,
      );
}

class AppConfig {
  
  static const List<String> levelTopics = [
    "Print, Input, O'zgaruvchilar",
    "List, Tuple, Set",
    "Dictionary, Shartlar (If/Else)",
    "For va While Sikllari",
    "Funksiyalar va Lambda",
    "Modullar va Kutubxonalar",
    "OOP Asoslari",
    "Vorislik va Polimorfizm",
    "Xatoliklar va Fayllar",
    "Dekoratorlar, Generatorlar"
  ];
}
