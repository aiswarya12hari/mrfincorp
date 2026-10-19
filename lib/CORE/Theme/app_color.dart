import 'package:flutter/material.dart';

/// Friends Fincorp Web-Styled App Color Palette
/// Primary: #111827 (Charcoal Black)
/// Secondary: #18B7B0 (Professional Teal-Blue)
/// SecondaryDark: #129C97 (Darker High-Contrast Teal)
/// Accent: #129C97 (Darker Accent)
/// Background: #F8FAFC
class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────
  static const Color primary = Color(0xFF111827); // Charcoal Black
  static const Color primaryDark = Color(0xFF0F172A); // Deep Charcoal
  static const Color secondary = Color(
    0xFF18B7B0,
  ); // Professional Teal-Blue (#18B7B0)
  static const Color secondaryDark = Color(
    0xFF129C97,
  ); // Darker High-Contrast Teal (#129C97)
  static const Color accent = Color(0xFF129C97); // Darker Accent (#129C97)
  static const Color primaryLight = Color(
    0xFFE0F7F6,
  ); // Soft Teal Tint (pill/chip active bg)

  // ── Surface & Background ────────────────────────────────
  static const Color background = Color(0xFFF8FAFC); // Clean Web Background
  static const Color surface = Color(0xFFFFFFFF); // White Card / Surface
  static const Color surfaceSecondary = Color(0xFFF1F5F9); // Light Gray Surface
  static const Color cardColor = Color(0xFFFFFFFF); // Card Fill
  static const Color white = Color(0xFFFFFFFF);

  // ── Borders & Dividers ──────────────────────────────────
  static const Color border = Color(0xFFE5E7EB); // Web Gray Border
  static const Color borderColor = Color(0xFFE5E7EB); // Alias for border
  static const Color dashboardBorder = Color(0xFFE5E7EB);

  // ── Typography ──────────────────────────────────────────
  static const Color heading = Color(0xFF111827); // Heading
  static const Color textPrimary = Color(
    0xFF111827,
  ); // Charcoal Heading / Main Text
  static const Color bodyText = Color(0xFF374151); // Body Text
  static const Color textSecondary = Color(0xFF374151); // Body Text
  static const Color subtitle = Color(0xFF6B7280); // Subtitle
  static const Color textLight = Color(0xFF6B7280); // Subtitle / Gray Text
  static const Color textMuted = Color(
    0xFF9CA3AF,
  ); // Placeholder / Disabled Text

  // Backward-compatibility aliases for existing code
  static const Color gray800 = Color(0xFF111827); // Heading
  static const Color gray600 = Color(0xFF6B7280); // Subtitle
  static const Color gray400 = Color(0xFF9CA3AF); // Placeholder
  static const Color gray200 = Color(0xFFF1F5F9); // Gray surface
  static const Color gray100 = Color(0xFFF8FAFC); // Scaffold bg

  // ── Semantic ────────────────────────────────────────────
  static const Color success = Color(0xFF16A34A); // Web Green
  static const Color successBg = Color(0xFFDEF7EC); // Web Green Pill Bg
  static const Color warning = Color(0xFFF59E0B); // Amber Warning
  static const Color warningBg = Color(0xFFFEF3C7); // Amber Pill Bg
  static const Color error = Color(0xFFEF4444); // Red Error
  static const Color errorBg = Color(0xFFFEE2E2); // Red Pill Bg

  // ── Chips & Dashboard ───────────────────────────────────
  static const Color chipBg = Color(0xFFF1F5F9); // Light gray chip
  static const Color chipActiveBg = Color(0xFFE0F7F6); // Teal tint chip
  static const Color dashboardBg = Color(0xFFF8FAFC); // Dashboard background
}
