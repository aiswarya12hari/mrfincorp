import 'package:flutter/material.dart';
import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../../data/models/loan_detail_model.dart';

class LoanInfoCard extends StatelessWidget {
  final LoanDetailModel loan;

  const LoanInfoCard({super.key, required this.loan});

  Widget _buildStatusBadge(String status) {
    Color fg;
    IconData icon;

    switch (status.toUpperCase()) {
      case 'FIELDSTAFF_VERIFIED':
        fg = const Color(0xFF047857);
        icon = Icons.check_circle_rounded;
        break;
      case 'ADMIN_APPROVED':
        fg = const Color(0xFF1D4ED8);
        icon = Icons.verified_rounded;
        break;
      case 'VERIFICATION_PENDING':
        fg = const Color(0xFFB45309);
        icon = Icons.hourglass_top_rounded;
        break;
      case 'REJECTED':
        fg = const Color(0xFFB91C1C);
        icon = Icons.cancel_rounded;
        break;
      case 'ADMIN_APPROVAL_PENDING':
        fg = const Color(0xFF7E22CE);
        icon = Icons.pending_rounded;
        break;
      default:
        fg = const Color(0xFF374151);
        icon = Icons.info_outline_rounded;
    }

    final displayText = status.isEmpty ? '-' : status.toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.5, color: fg),
          const SizedBox(width: 5),
          Text(
            displayText,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.secondaryDark),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 11,
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value.isEmpty ? '-' : value,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF18B7B0).withValues(alpha: 0.10),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Light White Header with Teal Accent ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            decoration: const BoxDecoration(
              color: Color(0xFFEFFAFA),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loan.loanId.isEmpty ? '-' : loan.loanId,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Color(0xFF0D6E6A),
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildStatusBadge(loan.status),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.savings_outlined,
                      color: Color(0xFF18B7B0),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loan.loanType.isEmpty
                          ? 'DAILY'
                          : loan.loanType.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Color(0xFF0D6E6A),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      'Loan Type',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: const Color(0xFF18B7B0).withValues(alpha: 0.85),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Information Grid & Feedback ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildGridItem(
                        icon: Icons.payments_outlined,
                        label: 'Loan Amount',
                        value:
                            '₹ ${loan.loanAmount.isEmpty ? '-' : loan.loanAmount}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGridItem(
                        icon: Icons.access_time_rounded,
                        label: 'Loan Duration',
                        value: loan.loanDuration,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildGridItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Date of Application',
                        value: loan.dateOfApplication,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGridItem(
                        icon: Icons.hourglass_empty_rounded,
                        label: 'Date of Expiry',
                        value: loan.dateOfExpiry,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(
                  height: 1,
                  thickness: 0.8,
                  color: AppColors.border,
                ),
                const SizedBox(height: 14),

                // Feedback row
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 17,
                        color: AppColors.secondaryDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Feedback',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 11,
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            loan.feedback.trim().isEmpty
                                ? '-'
                                : loan.feedback.trim(),
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
