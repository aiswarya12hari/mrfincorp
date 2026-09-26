import 'package:flutter/material.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../Dashboard/presentation/widgets/dashboard_shimmer.dart';

/// Shimmer placeholder skeleton matching the exact layout and height of [LoanCard].
class LoanCardSkeleton extends StatelessWidget {
  const LoanCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Customer Name & Status Chip Row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              ShimmerBox(width: 130, height: 17, borderRadius: 4),
              ShimmerBox(width: 80, height: 22, borderRadius: 12),
            ],
          ),

          const SizedBox(height: 6),

          // ── Loan ID ──
          const ShimmerBox(width: 105, height: 12, borderRadius: 4),

          const SizedBox(height: 12),

          // ── Chips Row (Type & Method) ──
          Row(
            children: const [
              ShimmerBox(width: 65, height: 20, borderRadius: 6),
              SizedBox(width: 8),
              ShimmerBox(width: 75, height: 20, borderRadius: 6),
            ],
          ),

          const SizedBox(height: 14),

          // ── Subtle Divider ──
          Container(
            height: 1,
            color: AppColors.borderColor.withOpacity(0.6),
          ),

          const SizedBox(height: 12),

          // ── Amount & Application Date Row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(width: 55, height: 11, borderRadius: 3),
                  SizedBox(height: 5),
                  ShimmerBox(width: 85, height: 16, borderRadius: 4),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  ShimmerBox(width: 65, height: 11, borderRadius: 3),
                  SizedBox(height: 5),
                  ShimmerBox(width: 75, height: 14, borderRadius: 4),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shimmer skeleton list displayed while loans are loading.
class LoanListShimmer extends StatelessWidget {
  final int itemCount;

  const LoanListShimmer({
    super.key,
    this.itemCount = 4,
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
        itemBuilder: (context, index) => const LoanCardSkeleton(),
      ),
    );
  }
}
