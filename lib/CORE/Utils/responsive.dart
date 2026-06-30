import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────
/// FinCorp Responsive Dimensions Helper
/// ─────────────────────────────────────────────────────────────
/// Wraps MediaQuery so every screen/widget can get responsive
/// sizes with ONE line instead of repeating MediaQuery.of(context)
/// everywhere.
///
/// USAGE:
///   final dim = Dimensions(context);
///
///   dim.width(0.06)      -> 6% of screen width
///   dim.height(0.03)     -> 3% of screen height
///   dim.sp(14)            -> responsive font size (scales with width)
///   dim.isSmallScreen     -> true if narrow phone (<360 logical px)
///   dim.isTablet          -> true if width >= 600 logical px
///   dim.screenWidth       -> raw screen width
///   dim.screenHeight      -> raw screen height
///
/// Place this file at:
///   lib/CORE/Config/dimensions.dart
/// ─────────────────────────────────────────────────────────────
class Dimensions {
  final BuildContext context;
  late final MediaQueryData _mq;

  Dimensions(this.context) {
    _mq = MediaQuery.of(context);
  }

  // ── Raw screen info ───────────────────────────────────────
  double get screenWidth => _mq.size.width;
  double get screenHeight => _mq.size.height;
  EdgeInsets get padding => _mq.padding;
  double get statusBarHeight => _mq.padding.top;
  double get bottomInset => _mq.viewInsets.bottom; // keyboard height

  // ── Breakpoints ────────────────────────────────────────────
  bool get isSmallScreen => screenWidth < 360;
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  // ── Proportional sizing ────────────────────────────────────
  /// Returns [factor] * screen width. e.g. width(0.06) => 6% of width
  double width(double factor) => screenWidth * factor;

  /// Returns [factor] * screen height. e.g. height(0.03) => 3% of height
  double height(double factor) => screenHeight * factor;

  /// Responsive font size, scaled against a 375px base width (iPhone X / common base).
  /// Clamped so text never becomes unreadably small or comically large.
  double sp(double size) {
    final scale = screenWidth / 375;
    final scaled = size * scale;
    return scaled.clamp(size * 0.85, size * 1.25);
  }

  /// Responsive horizontal padding for page edges.
  /// Tighter on small phones, a bit roomier on tablets.
  double get pagePaddingH {
    if (isTablet || isDesktop) return width(0.12);
    if (isSmallScreen) return width(0.05);
    return width(0.07);
  }

  /// Vertical rhythm spacing — use for gaps between sections.
  double gap(double factor) => height(factor);
}