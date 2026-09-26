import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
import 'package:mr_fincorp/FEATURES/Navigation/navigation_provider.dart';
import 'package:provider/provider.dart';
import '../../provider/dashboard_provider.dart';
import '../../../Loans/presentation/pages/loan_detail_page.dart';
import '../../../Loans/presentation/pages/group_loan_detailpage.dart';
import 'dashboard_animations.dart';

class RecentLoansSection extends StatelessWidget {
  const RecentLoansSection({super.key});

  Color _statusBg(String status) {
    switch (status.toUpperCase()) {
      case 'FIELDSTAFF_VERIFIED':
      case 'VERIFIED':
        return const Color(0xFFDEF7EC);
      case 'ADMIN_APPROVED':
      case 'APPROVED':
        return const Color(0xFFDBEAFE);
      case 'VERIFICATION_PENDING':
      case 'PENDING':
        return const Color(0xFFFEF3C7);
      case 'REJECTED':
        return const Color(0xFFFEE2E2);
      case 'ADMIN_APPROVAL_PENDING':
        return const Color(0xFFF3E8FF);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _statusFg(String status) {
    switch (status.toUpperCase()) {
      case 'FIELDSTAFF_VERIFIED':
      case 'VERIFIED':
        return const Color(0xFF065F46);
      case 'ADMIN_APPROVED':
      case 'APPROVED':
        return const Color(0xFF1E40AF);
      case 'VERIFICATION_PENDING':
      case 'PENDING':
        return const Color(0xFF92400E);
      case 'REJECTED':
        return const Color(0xFF991B1B);
      case 'ADMIN_APPROVAL_PENDING':
        return const Color(0xFF6B21A8);
      default:
        return const Color(0xFF374151);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final loans = provider.recentLoans;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // ── Section Header ───────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Recent Loans',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: AppColors.gray800,
              ),
            ),

            // ── Rounded "View All" Button with Arrow ──
            BouncyTap(
              onTap: () {
                context.read<NavigationProvider>().changeTab(1);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.18),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // ── Empty State ──────────────────────────
        if (loans.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.borderColor.withOpacity(0.8),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E293B).withOpacity(0.04),
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
                  'No recent loans available',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'New loan applications will appear here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 12.5,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          )
        else
          // ── Loan Cards List (Earlier Card Style) ──
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              final bool isGroupLoan =
                  loan.loanMethod.toUpperCase().contains('GROUP');
              final String displayName = loan.customerName;
              final String formattedAmount =
                  '₹ ${double.tryParse(loan.loanAmount)?.toStringAsFixed(0) ?? loan.loanAmount}';
              final String typeLabel = loan.loanType.isNotEmpty
                  ? loan.loanType.toUpperCase()
                  : loan.loanMethod.toUpperCase();

              return FadeSlideTransition(
                delay: Duration(milliseconds: 150 + (index * 50)),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BouncyTap(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => isGroupLoan
                              ? GroupLoanDetailPage(loanId: loan.loanId)
                              : LoanDetailPage(loanId: loan.loanId),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.borderColor.withOpacity(0.8),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E293B).withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Customer Name (Teal, Bold) ────
                          Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(height: 2),

                          // ── Loan ID (Subtle, Clean Text) ─
                          Text(
                            loan.loanId,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray600,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ── Type Chip & Status Chip ──────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Type Chip (Left)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.chipActiveBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  typeLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),

                              // Status Chip (Right)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusBg(loan.status),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  loan.status
                                      .replaceAll('_', ' ')
                                      .toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: _statusFg(loan.status),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // ── Divider ──────────────────────
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.borderColor.withOpacity(0.7),
                          ),

                          const SizedBox(height: 10),

                          // ── Amount & Date ────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Amount Column
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount',
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.gray600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    formattedAmount,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.2,
                                      color: AppColors.gray800,
                                    ),
                                  ),
                                ],
                              ),

                              // Date Column
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Date',
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.gray600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    loan.dateOfApplication.isEmpty
                                        ? '—'
                                        : loan.dateOfApplication,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.gray800,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}