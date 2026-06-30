import 'package:flutter/material.dart';

/// FinCorp App Color Palette
/// Primary  : Teal-300  →  #4FD1C5
/// Neutral  : Gray-400  →  #A0AEC0
class AppColors {
  AppColors._();

  // ── Primary ─────────────────────────────────────────────
  static const Color primary       = Color(0xFF4FD1C5); // Teal-300
  static const Color primaryDark   = Color(0xFF38B2AC); // Teal-400
  static const Color primaryLight  = Color(0xFF81E6D9); // Teal-200

  // ── Neutral / Gray ──────────────────────────────────────
  static const Color gray400       = Color(0xFFA0AEC0); // Gray-400 (hint / placeholder)
  static const Color gray200       = Color(0xFFEDF2F7); // Gray-200 (bg surface)
  static const Color gray100       = Color(0xFFF7FAFC); // Gray-100 (scaffold bg)
  static const Color gray600       = Color(0xFF718096); // Gray-600 (secondary text)
  static const Color gray800       = Color(0xFF2D3748); // Gray-800 (primary text)

  // ── Semantic ────────────────────────────────────────────
  static const Color error         = Color(0xFFE53E3E);
  static const Color white         = Color(0xFFFFFFFF);
  static const Color borderColor   = Color(0xFFE2E8F0); // Gray-200 variant
}