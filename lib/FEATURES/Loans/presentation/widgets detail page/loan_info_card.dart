import 'package:flutter/material.dart';
import '../../data/models/loan_detail_model.dart';

class LoanInfoCard extends StatelessWidget {
  final LoanDetailModel loan;

  const LoanInfoCard({super.key, required this.loan});

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7EE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                loan.status,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            loan.loanId,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 20),

          buildRow('Loan Type', loan.loanType),

          buildRow('Loan Amount', '₹ ${loan.loanAmount}'),

          buildRow('Loan Duration', loan.loanDuration),

          buildRow('Date of Application', loan.dateOfApplication),

          buildRow('Date of Expiry', loan.dateOfExpiry),

          const SizedBox(height: 10),

          const Text('Feedback', style: TextStyle(color: Colors.grey)),

          const SizedBox(height: 8),

          Text(loan.feedback.isEmpty ? '-' : loan.feedback),
        ],
      ),
    );
  }
}
