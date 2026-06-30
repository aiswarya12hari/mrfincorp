import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/presentation/widgets/recent_loan_section.dart';
import 'package:provider/provider.dart';

import 'package:mr_fincorp/FEATURES/Dashboard/provider/dashboard_provider.dart';

import '../widgets/dashboard_header.dart';
// import '../widgets/profile_card.dart';
import '../widgets/overview_section.dart';



class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState
    extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<DashboardProvider>()
          .fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await context
              .read<DashboardProvider>()
              .fetchDashboard();
        },
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),

              const SizedBox(height: 4),

              // const ProfileCard(),

              // const SizedBox(height: 24),

              const OverviewSection(),

              const SizedBox(height: 16),

              const RecentLoansSection(),
            ],
          ),
        ),
      ),
    );
  }
}