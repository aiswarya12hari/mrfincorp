import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';

/// FinCorp Text Style Definitions
/// Font Family : Inter
/// All sizes are relative to screen width via MediaQuery for responsiveness.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Inter';

  // ── Headings ────────────────────────────────────────────
  static TextStyle headline(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 24),
        fontWeight: FontWeight.w700,
        color: AppColors.gray800,
        letterSpacing: -0.5,
      );

  static TextStyle subheading(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w400,
        color: AppColors.gray600,
        height: 1.5,
      );

  // ── Body ────────────────────────────────────────────────
  static TextStyle body(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w400,
        color: AppColors.gray800,
      );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.w400,
        color: AppColors.gray600,
      );

  // ── Input ───────────────────────────────────────────────
  static TextStyle inputText(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 15),
        fontWeight: FontWeight.w400,
        color: AppColors.gray800,
      );

  static TextStyle hint(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w400,
        color: AppColors.gray400,
      );

  static TextStyle label(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.w600,
        color: AppColors.gray800,
        letterSpacing: 0.1,
      );

  // ── Button ──────────────────────────────────────────────
  static TextStyle button(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 16),
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        letterSpacing: 0.3,
      );

  // ── Links ───────────────────────────────────────────────
  static TextStyle link(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        decoration: TextDecoration.none,
      );

  static TextStyle version(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 11),
        fontWeight: FontWeight.w400,
        color: AppColors.gray400,
        letterSpacing: 0.5,
      );

  // ── Page / AppBar ───────────────────────────────────────
  static TextStyle pageTitle(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 20),
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      );

  // ── Tabs (Outstanding / Collected pill toggle) ─────────
  static TextStyle tabActive(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      );

  static TextStyle tabInactive(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w600,
        color: AppColors.gray600,
      );

  // ── Collection Card ─────────────────────────────────────
  static TextStyle cardCustomerName(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 16),
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      );

  static TextStyle cardLoanId(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 12.5),
        fontWeight: FontWeight.w400,
        color: AppColors.gray600,
      );

  static TextStyle chipText(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 11),
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        letterSpacing: 0.2,
      );

  static TextStyle areaChipText(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 11),
        fontWeight: FontWeight.w500,
        color: AppColors.gray600,
      );

  static TextStyle fieldLabel(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 12),
        fontWeight: FontWeight.w400,
        color: AppColors.gray600,
      );

  static TextStyle fieldValue(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 14.5),
        fontWeight: FontWeight.w700,
        color: AppColors.gray800,
      );

  static TextStyle fieldValueDanger(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 14.5),
        fontWeight: FontWeight.w700,
        color: AppColors.error,
      );

  // ── Helper ──────────────────────────────────────────────
  /// Responsive font size: 1 unit ≈ 1/375 of screen width (base: 375 logical px)
  static double _sp(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return size * (width / 375);
  }
}