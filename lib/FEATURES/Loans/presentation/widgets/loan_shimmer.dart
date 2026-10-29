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
            color: AppColors.borderColor.withValues(alpha: 0.6),
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

/// Shimmer skeleton matching the exact layout of [LoanDetailPage].
class LoanDetailShimmer extends StatelessWidget {
  const LoanDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        child: Column(
          children: [
            // ── Loan Info Card Skeleton ──
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF18B7B0).withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    color: const Color(0xFFEFFAFA),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              ShimmerBox(
                                width: 140,
                                height: 20,
                                borderRadius: 5,
                              ),
                              SizedBox(height: 8),
                              ShimmerBox(
                                width: 95,
                                height: 24,
                                borderRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            ShimmerBox(
                              width: 24,
                              height: 24,
                              borderRadius: 6,
                            ),
                            SizedBox(height: 6),
                            ShimmerBox(
                              width: 55,
                              height: 13,
                              borderRadius: 4,
                            ),
                            SizedBox(height: 3),
                            ShimmerBox(
                              width: 45,
                              height: 10,
                              borderRadius: 3,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Information Grid Skeleton
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildGridItemSkeletonRow(),
                        const SizedBox(height: 16),
                        _buildGridItemSkeletonRow(),
                        const SizedBox(height: 16),
                        _buildGridItemSkeletonRow(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Customer Details Card Skeleton ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: const [
                      ShimmerBox(width: 20, height: 20, borderRadius: 5),
                      SizedBox(width: 8),
                      ShimmerBox(width: 130, height: 16, borderRadius: 4),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const ShimmerBox(width: 72, height: 2.5, borderRadius: 2),
                  const SizedBox(height: 16),

                  // Profile Row
                  Row(
                    children: [
                      const ShimmerBox.circle(size: 46),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            ShimmerBox(
                              width: 140,
                              height: 15,
                              borderRadius: 4,
                            ),
                            SizedBox(height: 5),
                            ShimmerBox(
                              width: 95,
                              height: 12,
                              borderRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      const ShimmerBox(
                        width: 75,
                        height: 26,
                        borderRadius: 12,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, thickness: 0.8, color: AppColors.border),
                  const SizedBox(height: 14),

                  // Address Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerBox(width: 34, height: 34, borderRadius: 8),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            ShimmerBox(width: 180, height: 12, borderRadius: 3),
                            SizedBox(height: 5),
                            ShimmerBox(width: 120, height: 12, borderRadius: 3),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Maps Row
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: const [
                        ShimmerBox(width: 28, height: 28, borderRadius: 6),
                        SizedBox(width: 10),
                        ShimmerBox(width: 130, height: 13, borderRadius: 4),
                        Spacer(),
                        ShimmerBox(width: 20, height: 20, borderRadius: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildGridItemSkeletonRow() {
    return Row(
      children: [
        Expanded(child: _buildGridItemSkeleton()),
        const SizedBox(width: 12),
        Expanded(child: _buildGridItemSkeleton()),
      ],
    );
  }

  static Widget _buildGridItemSkeleton() {
    return Row(
      children: [
        const ShimmerBox.circle(size: 36),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ShimmerBox(width: 65, height: 10, borderRadius: 3),
              SizedBox(height: 4),
              ShimmerBox(width: 80, height: 13, borderRadius: 4),
            ],
          ),
        ),
      ],
    );
  }
}

/// Shimmer skeleton matching the exact layout of [GroupLoanDetailPage].
class GroupLoanDetailShimmer extends StatelessWidget {
  const GroupLoanDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          children: [
            // Group Header Skeleton
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const ShimmerBox.circle(size: 44),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            ShimmerBox(width: 140, height: 16, borderRadius: 4),
                            SizedBox(height: 6),
                            ShimmerBox(width: 100, height: 12, borderRadius: 3),
                          ],
                        ),
                      ),
                      const ShimmerBox(width: 75, height: 24, borderRadius: 12),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stats Row Skeleton
            Row(
              children: const [
                Expanded(child: ShimmerBox(height: 80, borderRadius: 14)),
                SizedBox(width: 10),
                Expanded(child: ShimmerBox(height: 80, borderRadius: 14)),
                SizedBox(width: 10),
                Expanded(child: ShimmerBox(height: 80, borderRadius: 14)),
              ],
            ),
            const SizedBox(height: 16),

            // Group Summary Card Skeleton
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
