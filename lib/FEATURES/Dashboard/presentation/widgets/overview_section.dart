import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../../../Loans/provider/loan_provider.dart';
import '../../../Navigation/navigation_provider.dart';
import '../../provider/dashboard_provider.dart';
import 'dashboard_animations.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  void _navigateToLoanTab(BuildContext context, String? status) {
    context.read<LoanProvider>().changeStatusTab(status);
    context.read<NavigationProvider>().changeTab(1);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final dashboard = provider.dashboard;

    if (provider.errorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.dashboardBorder),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E293B).withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              provider.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.gray800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pull down to try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13.5,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    if (dashboard == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.dashboardBorder),
        ),
        child: const Center(
          child: Text(
            'No dashboard data found',
            style: TextStyle(fontFamily: AppTextStyles.fontFamily),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Visual Hierarchy: Prominent 'Overview' Heading ──
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Overview',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                color: Color(0xFF0F2A38),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.34,
          ),
          children: [
            FadeSlideTransition(
              delay: const Duration(milliseconds: 40),
              child: OverviewCard(
                title: 'Total Loans',
                value: dashboard.totalLoans.toString(),
                icon: Icons.account_balance_wallet_rounded,
                iconColor: const Color(0xFF1D4ED8), // High-contrast Blue 700
                iconBg: const Color(0xFFDBEAFE),    // Rich Blue 100
                onTap: () => _navigateToLoanTab(context, null),
              ),
            ),
            FadeSlideTransition(
              delay: const Duration(milliseconds: 90),
              child: OverviewCard(
                title: 'Verification Pending',
                value: dashboard.verificationPending.toString(),
                icon: Icons.pending_actions_rounded,
                iconColor: const Color(0xFFC2410C), // High-contrast Orange 700
                iconBg: const Color(0xFFFFEDD5),    // Rich Orange 100
                onTap: () => _navigateToLoanTab(context, 'VERIFICATION_PENDING'),
              ),
            ),
            FadeSlideTransition(
              delay: const Duration(milliseconds: 140),
              child: OverviewCard(
                title: 'Verified Loans',
                value: dashboard.verifiedLoans.toString(),
                icon: Icons.verified_rounded,
                iconColor: const Color(0xFF047857), // High-contrast Emerald Green 700
                iconBg: const Color(0xFFD1FAE5),    // Rich Emerald 100
                onTap: () => _navigateToLoanTab(context, 'FIELDSTAFF_VERIFIED'),
              ),
            ),
            FadeSlideTransition(
              delay: const Duration(milliseconds: 190),
              child: OverviewCard(
                title: "Today's Loans",
                value: dashboard.todayActivity.toString(),
                icon: Icons.calendar_today_rounded,
                iconColor: const Color(0xFFB91C1C), // High-contrast Red 700
                iconBg: const Color(0xFFFEE2E2),    // Rich Red 100
                onTap: () => _navigateToLoanTab(context, null),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final VoidCallback onTap;

  const OverviewCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        gradient: LinearGradient(
          colors: [
            AppColors.white,
            iconBg.withValues(alpha: 0.38),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.16),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: iconColor.withValues(alpha: 0.12),
          highlightColor: iconColor.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ── Top: Title with increased visual weight ──
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Color(0xFF475569),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.1,
                  ),
                ),

                // ── Center: Bold prominent number | Right: High-contrast icon badge ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                            color: Color(0xFF0F172A),
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: iconBg,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: iconColor.withValues(alpha: 0.22),
                          width: 1.2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(icon, color: iconColor, size: 21),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
