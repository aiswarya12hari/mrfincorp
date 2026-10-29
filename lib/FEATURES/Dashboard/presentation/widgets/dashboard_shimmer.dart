import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';

/// Pure Flutter continuous shimmer effect driver using an animated ShaderMask.
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(1.0, 0.3),
              colors: const [
                Color(0xFFE2E8F0),
                Color(0xFFF8FAFC),
                Color(0xFFE2E8F0),
              ],
              stops: const [0.1, 0.5, 0.9],
              transform: _SlidingGradientTransform(_controller.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (slidePercent * 2 - 1), 0.0, 0.0);
  }
}

/// Helper placeholder box with rounded corners.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 6,
    this.shape = BoxShape.rectangle,
  });

  const ShimmerBox.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = 0,
        shape = BoxShape.circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Skeleton UI matching the complete Field Staff Dashboard layout.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        children: [
          // ── Header Card Placeholder ──────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar circle
                const ShimmerBox.circle(size: 44),

                const SizedBox(width: 12),

                // Greeting & Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      ShimmerBox(width: 85, height: 12, borderRadius: 4),
                      SizedBox(height: 6),
                      ShimmerBox(width: 125, height: 18, borderRadius: 4),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Switch button pill
                const ShimmerBox(width: 68, height: 30, borderRadius: 20),
              ],
            ),
          ),

          // ── Scrollable Body Placeholders ─────
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview title
                  const ShimmerBox(width: 95, height: 20, borderRadius: 4),

                  const SizedBox(height: 12),

                  // 4 Overview Cards Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.48,
                    children: List.generate(4, (_) => const _OverviewCardSkeleton()),
                  ),

                  const SizedBox(height: 20),

                  // Recent Loans Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      ShimmerBox(width: 120, height: 20, borderRadius: 4),
                      ShimmerBox(width: 76, height: 28, borderRadius: 20),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // 3 Recent Loan Card Placeholders
                  ...List.generate(
                    3,
                    (_) => const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: _RecentLoanCardSkeleton(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewCardSkeleton extends StatelessWidget {
  const _OverviewCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ShimmerBox(width: 80, height: 12, borderRadius: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              ShimmerBox.circle(size: 36),
              SizedBox(width: 10),
              ShimmerBox(width: 44, height: 26, borderRadius: 6),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentLoanCardSkeleton extends StatelessWidget {
  const _RecentLoanCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Name
          const ShimmerBox(width: 110, height: 16, borderRadius: 4),

          const SizedBox(height: 4),

          // Loan ID
          const ShimmerBox(width: 90, height: 12, borderRadius: 4),

          const SizedBox(height: 10),

          // Chips Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerBox(width: 78, height: 22, borderRadius: 6),
              ShimmerBox(width: 85, height: 22, borderRadius: 6),
            ],
          ),

          const SizedBox(height: 12),

          // Divider
          Container(
            height: 1,
            color: AppColors.borderColor.withValues(alpha: 0.7),
          ),

          const SizedBox(height: 10),

          // Amount & Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(width: 45, height: 11, borderRadius: 3),
                  SizedBox(height: 4),
                  ShimmerBox(width: 75, height: 16, borderRadius: 4),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  ShimmerBox(width: 35, height: 11, borderRadius: 3),
                  SizedBox(height: 4),
                  ShimmerBox(width: 75, height: 15, borderRadius: 4),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
