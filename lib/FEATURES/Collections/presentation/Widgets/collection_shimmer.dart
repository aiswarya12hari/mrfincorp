import 'package:flutter/material.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../Dashboard/presentation/widgets/dashboard_shimmer.dart';

/// Skeleton placeholder matching the exact card design of [CollectionCard].
class CollectionCardSkeleton extends StatelessWidget {
  const CollectionCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F2A38).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Name + Status Badge ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              ShimmerBox(width: 135, height: 16, borderRadius: 5),
              ShimmerBox(width: 65, height: 22, borderRadius: 6),
            ],
          ),
          const SizedBox(height: 6),

          // ── Loan ID ──
          const ShimmerBox(width: 100, height: 12, borderRadius: 4),
          const SizedBox(height: 10),

          // ── Chips Row (Frequency & Area) ──
          Row(
            children: const [
              ShimmerBox(width: 60, height: 22, borderRadius: 6),
              SizedBox(width: 8),
              ShimmerBox(width: 80, height: 22, borderRadius: 6),
            ],
          ),
          const SizedBox(height: 14),

          // ── Divider ──
          Container(
            height: 1,
            color: const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 14),

          // ── Row 1: Principal Balance & Fine Balance ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(width: 85, height: 11, borderRadius: 3),
                  SizedBox(height: 5),
                  ShimmerBox(width: 75, height: 15, borderRadius: 4),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  ShimmerBox(width: 70, height: 11, borderRadius: 3),
                  SizedBox(height: 5),
                  ShimmerBox(width: 60, height: 15, borderRadius: 4),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Row 2: Pending Dues & Collection Date ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(width: 75, height: 11, borderRadius: 3),
                  SizedBox(height: 5),
                  ShimmerBox(width: 35, height: 15, borderRadius: 4),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  ShimmerBox(width: 85, height: 11, borderRadius: 3),
                  SizedBox(height: 5),
                  ShimmerBox(width: 80, height: 15, borderRadius: 4),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton placeholder matching the design of [CollectedCard].
class CollectedCardSkeleton extends StatelessWidget {
  const CollectedCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F2A38).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 140, height: 16, borderRadius: 5),
          const SizedBox(height: 6),
          const ShimmerBox(width: 100, height: 12, borderRadius: 4),
          const SizedBox(height: 10),
          Row(
            children: const [
              ShimmerBox(width: 60, height: 22, borderRadius: 6),
              SizedBox(width: 8),
              ShimmerBox(width: 70, height: 22, borderRadius: 6),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            color: const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(width: 90, height: 11, borderRadius: 3),
                  SizedBox(height: 5),
                  ShimmerBox(width: 75, height: 15, borderRadius: 4),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  ShimmerBox(width: 80, height: 11, borderRadius: 3),
                  SizedBox(height: 5),
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

/// Shimmer skeleton list displayed while collections are loading.
class CollectionListShimmer extends StatelessWidget {
  final int itemCount;
  final bool isCollected;

  const CollectionListShimmer({
    super.key,
    this.itemCount = 4,
    this.isCollected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 2,
          bottom: 24,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) =>
            isCollected ? const CollectedCardSkeleton() : const CollectionCardSkeleton(),
      ),
    );
  }
}

/// Comprehensive shimmer skeleton for [CollectionDetailsPage] while details load.
class CollectionDetailShimmer extends StatelessWidget {
  const CollectionDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        children: [
          // ── Header Card Skeleton ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Status Chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        ShimmerBox(width: 28, height: 28, borderRadius: 8),
                        SizedBox(width: 8),
                        ShimmerBox(width: 120, height: 15, borderRadius: 5),
                      ],
                    ),
                    const ShimmerBox(width: 65, height: 22, borderRadius: 16),
                  ],
                ),
                const SizedBox(height: 16),

                // Avatar + Name + ID
                Row(
                  children: [
                    const ShimmerBox.circle(size: 44),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerBox(width: 130, height: 15, borderRadius: 4),
                        SizedBox(height: 5),
                        ShimmerBox(width: 160, height: 18, borderRadius: 6),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(height: 1, color: const Color(0xFFF1F5F9)),
                const SizedBox(height: 12),

                // Phone Row
                Row(
                  children: [
                    const ShimmerBox(width: 36, height: 36, borderRadius: 10),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerBox(width: 80, height: 10, borderRadius: 3),
                        SizedBox(height: 4),
                        ShimmerBox(width: 100, height: 14, borderRadius: 4),
                      ],
                    ),
                    const Spacer(),
                    const ShimmerBox(width: 58, height: 32, borderRadius: 18),
                    const SizedBox(width: 8),
                    const ShimmerBox.circle(size: 36),
                  ],
                ),
                const SizedBox(height: 12),
                Container(height: 1, color: const Color(0xFFF1F5F9)),
                const SizedBox(height: 12),

                // Address Row
                Row(
                  children: [
                    const ShimmerBox(width: 36, height: 36, borderRadius: 10),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerBox(width: 95, height: 10, borderRadius: 3),
                        SizedBox(height: 4),
                        ShimmerBox(width: 160, height: 13, borderRadius: 4),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Maps Card
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: const [
                      ShimmerBox(width: 34, height: 34, borderRadius: 8),
                      SizedBox(width: 10),
                      ShimmerBox(width: 140, height: 13, borderRadius: 4),
                      Spacer(),
                      ShimmerBox(width: 26, height: 26, borderRadius: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(height: 1, color: const Color(0xFFF1F5F9)),
                const SizedBox(height: 16),

                // 2x2 Info Grid
                Row(
                  children: const [
                    Expanded(
                      child: ShimmerBox(height: 80, borderRadius: 12),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ShimmerBox(height: 80, borderRadius: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Expanded(
                      child: ShimmerBox(height: 80, borderRadius: 12),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ShimmerBox(height: 80, borderRadius: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Financial Summary
                const ShimmerBox(height: 54, borderRadius: 14),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Expanded(child: ShimmerBox(height: 42, borderRadius: 8)),
                    SizedBox(width: 12),
                    Expanded(child: ShimmerBox(height: 42, borderRadius: 8)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Payment Collection Skeleton ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    ShimmerBox(width: 28, height: 28, borderRadius: 8),
                    SizedBox(width: 8),
                    ShimmerBox(width: 130, height: 14, borderRadius: 4),
                  ],
                ),
                const SizedBox(height: 16),
                const ShimmerBox(width: 110, height: 10, borderRadius: 3),
                const SizedBox(height: 6),
                const ShimmerBox(height: 48, borderRadius: 12),
                const SizedBox(height: 16),
                const ShimmerBox(width: 100, height: 10, borderRadius: 3),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Expanded(child: ShimmerBox(height: 42, borderRadius: 12)),
                    SizedBox(width: 12),
                    Expanded(child: ShimmerBox(height: 42, borderRadius: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                const ShimmerBox(width: 110, height: 10, borderRadius: 3),
                const SizedBox(height: 6),
                const ShimmerBox(height: 70, borderRadius: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
