import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';

/// Friends Fincorp Web-Styled Text Definitions
/// Font Family : Inter
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Inter';

  // ── Web Typography System ────────────────────────────────
  /// Heading: 28 Bold, Color: AppColors.textPrimary
  static TextStyle heading(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 28),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  /// Section Title: 22 SemiBold, Color: AppColors.textPrimary
  static TextStyle sectionTitle(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 22),
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.3,
      );

  /// Card Title: 18 SemiBold, Color: AppColors.textPrimary
  static TextStyle cardTitle(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 18),
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      );

  /// Body: 16 Medium, Color: AppColors.textSecondary
  static TextStyle body(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 16),
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  /// Caption: 14 Regular, Color: AppColors.textLight
  static TextStyle caption(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w400,
        color: AppColors.textLight,
      );

  /// Small Label: 12 Medium, Color: AppColors.textLight
  static TextStyle smallLabel(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 12),
        fontWeight: FontWeight.w500,
        color: AppColors.textLight,
      );

  // ── Compatibility & Specific Element Styles ──────────────
  static TextStyle headline(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 24),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle subheading(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w400,
        color: AppColors.textLight,
        height: 1.5,
      );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.w400,
        color: AppColors.textLight,
      );

  static TextStyle inputText(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 15),
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle hint(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  static TextStyle label(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w500,
        color: AppColors.textLight,
        letterSpacing: 0.1,
      );

  static TextStyle button(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 16),
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        letterSpacing: 0.3,
      );

  static TextStyle link(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.w600,
        color: AppColors.secondary,
        decoration: TextDecoration.none,
      );

  static TextStyle version(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 11),
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        letterSpacing: 0.5,
      );

  static TextStyle pageTitle(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 20),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

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
        color: AppColors.textLight,
      );

  static TextStyle cardCustomerName(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 16),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle cardLoanId(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 12.5),
        fontWeight: FontWeight.w400,
        color: AppColors.textLight,
      );

  static TextStyle chipText(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 11),
        fontWeight: FontWeight.w600,
        color: AppColors.secondary,
        letterSpacing: 0.2,
      );

  static TextStyle areaChipText(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 11),
        fontWeight: FontWeight.w500,
        color: AppColors.textLight,
      );

  static TextStyle fieldLabel(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 12),
        fontWeight: FontWeight.w400,
        color: AppColors.textLight,
      );

  static TextStyle fieldValue(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 14.5),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle fieldValueDanger(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sp(context, 14.5),
        fontWeight: FontWeight.w700,
        color: AppColors.error,
      );

  // ── Helper ──────────────────────────────────────────────
  static double _sp(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return size * (width / 375);
  }
}