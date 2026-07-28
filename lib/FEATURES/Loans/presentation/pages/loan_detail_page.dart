import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/individual_loan_verification.dart';
import 'package:provider/provider.dart';

import '../../provider/loan_detail_provider.dart';

import '../widgets detail page/loan_info_card.dart';
import '../widgets detail page/customer_details_card.dart';
import '../widgets detail page/verify_loan_button.dart';

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
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Loan Details'),
      ),

      body: Consumer<LoanDetailProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final loan = provider.loanDetail;

          if (loan == null) {
            return const Center(child: Text('Failed to load loan'));
          }

          // Scrollable content — button is NOT part of this anymore.
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              children: [
                LoanInfoCard(loan: loan),
                const SizedBox(height: 16),
                CustomerDetailsCard(customer: loan.customer),
              ],
            ),
          );
        },
      ),

      // ── Fixed bottom button, stays put while content scrolls ──
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
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.06),
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
