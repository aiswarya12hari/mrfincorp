import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';

/// FinCorp Text Style Definitions
/// All sizes are relative to screen width via MediaQuery for responsiveness.
class AppTextStyles {
  AppTextStyles._();

  // ── Headings ────────────────────────────────────────────
  static TextStyle headline(BuildContext context) => TextStyle(
        fontSize: _sp(context, 24),
        fontWeight: FontWeight.w700,
        color: AppColors.gray800,
        letterSpacing: -0.5,
      );

  static TextStyle subheading(BuildContext context) => TextStyle(
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w400,
        color: AppColors.gray600,
        height: 1.5,
      );

  // ── Body ────────────────────────────────────────────────
  static TextStyle body(BuildContext context) => TextStyle(
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w400,
        color: AppColors.gray800,
      );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.w400,
        color: AppColors.gray600,
      );

  // ── Input ───────────────────────────────────────────────
  static TextStyle inputText(BuildContext context) => TextStyle(
        fontSize: _sp(context, 15),
        fontWeight: FontWeight.w400,
        color: AppColors.gray800,
      );

  static TextStyle hint(BuildContext context) => TextStyle(
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w400,
        color: AppColors.gray400,
      );

  static TextStyle label(BuildContext context) => TextStyle(
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.w600,
        color: AppColors.gray800,
        letterSpacing: 0.1,
      );

  // ── Button ──────────────────────────────────────────────
  static TextStyle button(BuildContext context) => TextStyle(
        fontSize: _sp(context, 16),
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        letterSpacing: 0.3,
      );

  // ── Links ───────────────────────────────────────────────
  static TextStyle link(BuildContext context) => TextStyle(
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        decoration: TextDecoration.none,
      );

  static TextStyle version(BuildContext context) => TextStyle(
        fontSize: _sp(context, 11),
        fontWeight: FontWeight.w400,
        color: AppColors.gray400,
        letterSpacing: 0.5,
      );

  // ── Helper ──────────────────────────────────────────────
  /// Responsive font size: 1 unit ≈ 1/375 of screen width (base: 375 logical px)
  static double _sp(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return size * (width / 375);
  }
}