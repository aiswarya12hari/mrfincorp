import 'package:flutter/material.dart';
import '../../data/models/loan_detail_model.dart';
import '../../../../CORE/Theme/app_color.dart';

class GroupSummaryCard extends StatelessWidget {
  final LoanDetailModel detail;

  const GroupSummaryCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Loan Summary",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
              _row("Loan Type", detail.loanType),
              _row("Status", detail.status.replaceAll('_', ' ')),
              _row("Amount", "₹ ${detail.loanAmount}"),
              _row(
                "Duration",
                detail.loanDuration.isEmpty ? "-" : detail.loanDuration,
              ),
              _row(
                "Application Date",
                detail.dateOfApplication.isEmpty
                    ? "-"
                    : detail.dateOfApplication,
              ),
              _row(
                "Expiry Date",
                detail.dateOfExpiry.isEmpty ? "-" : detail.dateOfExpiry,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Feedback",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                detail.feedback.isEmpty
                    ? "No feedback available"
                    : detail.feedback,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value, textAlign: TextAlign.end, softWrap: true),
          ),
        ],
      ),
    );
  }
}
