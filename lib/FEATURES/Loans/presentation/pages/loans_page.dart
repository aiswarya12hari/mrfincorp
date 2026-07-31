import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Navigation/navigation_provider.dart';
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

class _LoansPageState extends State<LoansPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoanProvider>().fetchLoans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          /// Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  /// Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        // Loans reached as a bottom-nav tab, not pushed — nothing to
                        // pop to, so fall back to switching to the Home tab.
                        context.read<NavigationProvider>().changeTab(0);
                      }
                    },
                  ),

                  /// Title
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Loans',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  /// Filter Button
                  IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoanFilterPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          /// Status Tabs
          const LoanStatusTabs(),

          const SizedBox(height: 12),

          /// Search Bar
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: LoanSearchBar(),
          ),

          const SizedBox(height: 12),

          /// Loan List
          /// RefreshIndicator + Scrollbar + Pagination
          const Expanded(child: LoansList()),
        ],
      ),
    );
  }
}
