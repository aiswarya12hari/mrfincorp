import 'package:flutter/material.dart';

/// FinCorp App Color Palette
/// Primary  : #006A61
/// Neutral  : Gray-400  →  #A0AEC0
class AppColors {
  AppColors._();

  // ── Primary ─────────────────────────────────────────────
  static const Color primary       = Color(0xFF006A61); // Brand Teal
  static const Color primaryDark   = Color(0xFF004D46); // Darker teal (pressed states)
  static const Color primaryLight  = Color(0xFFE0F0EE); // Light teal tint (active pill bg)

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

  // ── Chip / Tag backgrounds ──────────────────────────────
  static const Color chipBg        = Color(0xFFEDF2F7); // Frequency / Area chip bg
  static const Color chipActiveBg  = Color(0xFFE0F0EE); // "MONTHLY"/"WEEKLY" chip bg (teal tint)
}