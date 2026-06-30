import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<DashboardProvider>();

    if (provider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    final dashboard =
        provider.dashboard;

    if (dashboard == null) {
      return Container(
        padding:
            const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No dashboard data found',
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 16),

        GridView(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.55,
          ),
          children: [
            OverviewCard(
              title: 'Total Loans',
              value: dashboard
                  .totalLoans
                  .toString(),
              icon:
                  Icons.account_balance_wallet,
              color:
                  const Color(0xFF2563EB),
              bgColor:
                  const Color(0xFFF5F9FF),
            ),

            OverviewCard(
              title:
                  'Verification Pending',
              value: dashboard
                  .verificationPending
                  .toString(),
              icon:
                  Icons.pending_actions,
              color:
                  const Color(0xFFF59E0B),
              bgColor:
                  const Color(0xFFFFF8ED),
            ),

            OverviewCard(
              title:
                  'Verified Loans',
              value: dashboard
                  .verifiedLoans
                  .toString(),
              icon: Icons.verified,
              color:
                  const Color(0xFF16A34A),
              bgColor:
                  const Color(0xFFF0FDF4),
            ),

            OverviewCard(
              title:
                  "Today's Loans",
              value: dashboard
                  .todayActivity
                  .toString(),
              icon:
                  Icons.local_activity,
              color:
                  const Color(0xFFEF4444),
              bgColor:
                  const Color(0xFFFEF2F2),
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
  final Color color;
  final Color bgColor;

  const OverviewCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              color.withOpacity(.08),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow:
                TextOverflow.ellipsis,
            style: TextStyle(
              color:
                  Colors.grey.shade700,
              fontSize: 12,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration:
                    BoxDecoration(
                  color: color
                      .withOpacity(.12),
                  shape:
                      BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 18,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Text(
                value,
                style:
                    const TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}