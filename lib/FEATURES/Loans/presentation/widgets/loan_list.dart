import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../../../../CORE/Widgets/app_pagination.dart';

import '../../provider/loan_provider.dart';
import 'loan_card.dart';
import 'loan_shimmer.dart';

class LoansList extends StatefulWidget {
  const LoansList({super.key});

  @override
  State<LoansList> createState() => _LoansListState();
}

class _LoansListState extends State<LoansList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshLoans(BuildContext context) async {
    await context.read<LoanProvider>().fetchLoans();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => _refreshLoans(context),
          child: provider.isLoading && provider.loans.isEmpty
              ? const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: LoanListShimmer(),
                )
              : Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            thickness: 5,
            radius: const Radius.circular(10),
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 2,
                bottom: 24,
              ),
              children: [
                /// ── Empty State ──
                if (provider.loans.isEmpty)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 24),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.borderColor.withOpacity(0.8),
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
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: AppColors.gray100,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.receipt_long_outlined,
                            size: 28,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No loans found',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try adjusting your search or filters',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12.5,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),

                /// ── Loan Cards (Kept exactly as they are) ──
                if (provider.loans.isNotEmpty)
                  ...provider.loans.map(
                    (loan) {
                      return LoanCard(
                        loanId: loan.loanId,
                        customer: loan.customerName,
                        amount: '₹ ${loan.loanAmount}',
                        date: loan.dateOfApplication,
                        type: loan.loanType,
                        status: loan.status,
                        loanMethod: loan.loanMethod,
                      );
                    },
                  ),

                /// ── Pagination ──
                if (provider.totalPages > 1)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 8,
                    ),
                    child: AppPagination(
                      currentPage: provider.currentPage,
                      totalPages: provider.totalPages,
                      isLoading: provider.isLoading,
                      onPageChanged: (page) {
                        provider.goToPage(page);

                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}