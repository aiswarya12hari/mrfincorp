import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/provider/dashboard_provider.dart';
import 'package:mr_fincorp/FEATURES/Navigation/navigation_provider.dart';
import 'package:mr_fincorp/main.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_shimmer.dart';
import '../widgets/overview_section.dart';
import '../widgets/recent_loan_section.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with RouteAware {
  int _lastNavIndex = 0;
  int _lastTapCounter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DashboardProvider>().fetchDashboard();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }

    final nav = Provider.of<NavigationProvider>(context, listen: true);
    if (nav.currentIndex == 0 &&
        (_lastNavIndex != 0 || _lastTapCounter != nav.tabTapCounter)) {
      _lastNavIndex = 0;
      _lastTapCounter = nav.tabTapCounter;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<DashboardProvider>().fetchDashboard(isRefresh: true);
      });
    } else if (nav.currentIndex != 0) {
      _lastNavIndex = nav.currentIndex;
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    final nav = context.read<NavigationProvider>();
    if (nav.currentIndex == 0) {
      context.read<DashboardProvider>().fetchDashboard(isRefresh: true);
    }
  }

  Widget _buildErrorView(BuildContext context, DashboardProvider provider) {
    return Center(
      key: const ValueKey('error_dashboard'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No internet connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<DashboardProvider>().fetchDashboard();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          Widget content;

          if (provider.isLoading) {
            content = const DashboardSkeleton(
              key: ValueKey('shimmer_skeleton'),
            );
          } else if (provider.errorMessage != null && provider.dashboard == null) {
            content = _buildErrorView(context, provider);
          } else if (provider.dashboard == null) {
            content = const Center(
              key: ValueKey('empty_dashboard'),
              child: Text(
                'No dashboard data found',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: AppTextStyles.fontFamily),
              ),
            );
          } else {
            content = Column(
              key: const ValueKey('loaded_dashboard'),
              children: [
                // ── Real Fixed Header ──────────
                const DashboardHeader(),

                // ── Scrollable Content with Single Pull-To-Refresh ─
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      // Fetch with isRefresh: true so no duplicate spinner is displayed
                      await context
                          .read<DashboardProvider>()
                          .fetchDashboard(isRefresh: true);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 12, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(height: 8),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: OverviewSection(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: RecentLoansSection(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: content,
          );
        },
      ),
    );
  }
}
