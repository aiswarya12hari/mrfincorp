import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/presentation/widgets/dashboard_animations.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/provider/dashboard_provider.dart';
import 'package:mr_fincorp/FEATURES/Navigation/navigation_provider.dart';
import 'package:mr_fincorp/main.dart';
import 'package:provider/provider.dart';

import '../../provider/loan_provider.dart';
import '../widgets/loan_list.dart';
import '../widgets/loan_tabs.dart';
import '../widgets/loan_search_bar.dart';
import 'loan_filter_page.dart';

class LoansPage extends StatefulWidget {
  const LoansPage({super.key});

  @override
  State<LoansPage> createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> with RouteAware {
  int _lastNavIndex = -1;
  int _lastTapCounter = -1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LoanProvider>().fetchLoans();
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
    if (nav.currentIndex == 1 &&
        (_lastNavIndex != 1 || _lastTapCounter != nav.tabTapCounter)) {
      final shouldRefresh = _lastNavIndex != -1;
      _lastNavIndex = 1;
      _lastTapCounter = nav.tabTapCounter;
      if (shouldRefresh) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          context.read<LoanProvider>().fetchLoans();
        });
      }
    } else if (nav.currentIndex != 1) {
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
    if (nav.currentIndex == 1) {
      context.read<LoanProvider>().fetchLoans();
      context.read<DashboardProvider>().fetchDashboard(isRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          /// ── Header with Dashboard-style Title & Rounded Action Buttons ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              height: 44,
              child: Row(
                children: [
                  /// Back Button (Rounded card with subtle border & shadow)
                  BouncyTap(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        context.read<NavigationProvider>().changeTab(0);
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.border,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 17,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  /// Title (Matching Dashboard heading typography)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Loans',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  /// Filter Button (Rounded card with subtle border & shadow)
                  BouncyTap(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoanFilterPage(),
                        ),
                      );
                      if (context.mounted) {
                        context.read<LoanProvider>().fetchLoans();
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.border,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.tune_rounded,
                        size: 19,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),

          /// ── Status Tabs ──
          const LoanStatusTabs(),

          const SizedBox(height: 14),

          /// ── Search Bar ──
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: LoanSearchBar(),
          ),

          const SizedBox(height: 14),

          /// ── Loan List (Cards remain untouched) ──
          const Expanded(child: LoansList()),
        ],
      ),
    );
  }
}
