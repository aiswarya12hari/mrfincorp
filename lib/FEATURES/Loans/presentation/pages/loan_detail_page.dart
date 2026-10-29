import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../../provider/loan_detail_provider.dart';
import 'individual_loan_verification.dart';
import '../widgets detail page/loan_info_card.dart';
import '../widgets detail page/customer_details_card.dart';
import '../widgets detail page/verify_loan_button.dart';
import '../widgets/loan_shimmer.dart';

class LoanDetailPage extends StatefulWidget {
  final String loanId;

  const LoanDetailPage({super.key, required this.loanId});

  @override
  State<LoanDetailPage> createState() => _LoanDetailPageState();
}

class _LoanDetailPageState extends State<LoanDetailPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoanDetailProvider>().fetchLoanDetail(widget.loanId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ── Clean Minimal White App Bar (no top background gradient) ──
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        leadingWidth: 52,
        titleSpacing: 8,
        title: const Text(
          'Loan Details',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),

      ),

      body: Consumer<LoanDetailProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoanDetailShimmer();
          }

          final loan = provider.loanDetail;

          if (loan == null) {
            return Center(
              child: Text(
                'Failed to load loan',
                style: AppTextStyles.body(context),
              ),
            );
          }

          // Responsive full-width layout with minimal comfortable margins
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            child: Column(
              children: [
                LoanInfoCard(loan: loan),
                const SizedBox(height: 14),
                CustomerDetailsCard(customer: loan.customer),
              ],
            ),
          );
        },
      ),

      // ── Fixed bottom verify button ──
      bottomNavigationBar: Consumer<LoanDetailProvider>(
        builder: (context, provider, child) {
          final loan = provider.loanDetail;

          if (provider.isLoading || loan == null) {
            return const SizedBox.shrink();
          }

          if (loan.status != 'VERIFICATION_PENDING') {
            return const SizedBox.shrink();
          }

          return SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: VerifyLoanButton(
                status: loan.status,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          IndividualLoanVerificationPage(loan: loan),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
