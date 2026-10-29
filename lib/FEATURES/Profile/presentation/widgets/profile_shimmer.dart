import 'package:flutter/material.dart';
import '../../../../CORE/Theme/app_color.dart';
import '../../../Dashboard/presentation/widgets/dashboard_shimmer.dart';

/// Shimmer skeleton matching the exact layout of [ProfilePage].
class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),

            // ── Centered Circular Avatar Skeleton ──
            const ShimmerBox.circle(size: 84),

            const SizedBox(height: 10),

            // ── User Name Skeleton ──
            const ShimmerBox(width: 140, height: 18, borderRadius: 5),

            const SizedBox(height: 16),

            // ── Details Card Skeleton (White, Rounded Corners) ──
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  for (int i = 0; i < 7; i++) ...[
                    if (i > 0)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(
                          height: 1,
                          thickness: 0.8,
                          color: AppColors.border,
                        ),
                      ),
                    Row(
                      children: [
                        const ShimmerBox(
                          width: 38,
                          height: 38,
                          borderRadius: 10,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              ShimmerBox(
                                width: 70,
                                height: 11,
                                borderRadius: 3,
                              ),
                              SizedBox(height: 4),
                              ShimmerBox(
                                width: 140,
                                height: 14,
                                borderRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Account Actions Card Skeleton (Switch Account & Logout) ──
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Switch Account Option Skeleton
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const ShimmerBox(
                          width: 38,
                          height: 38,
                          borderRadius: 10,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              ShimmerBox(
                                width: 100,
                                height: 13,
                                borderRadius: 3,
                              ),
                              SizedBox(height: 4),
                              ShimmerBox(
                                width: 180,
                                height: 10,
                                borderRadius: 3,
                              ),
                            ],
                          ),
                        ),
                        const ShimmerBox(
                          width: 14,
                          height: 14,
                          borderRadius: 3,
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.border,
                  ),

                  // Logout Option Skeleton
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const ShimmerBox(
                          width: 38,
                          height: 38,
                          borderRadius: 10,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              ShimmerBox(
                                width: 60,
                                height: 13,
                                borderRadius: 3,
                              ),
                              SizedBox(height: 4),
                              ShimmerBox(
                                width: 130,
                                height: 10,
                                borderRadius: 3,
                              ),
                            ],
                          ),
                        ),
                        const ShimmerBox(
                          width: 14,
                          height: 14,
                          borderRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
