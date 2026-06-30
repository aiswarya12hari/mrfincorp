import 'package:flutter/material.dart';

class VerifyLoanButton extends StatelessWidget {
  final String status;
  final VoidCallback onTap;

  const VerifyLoanButton({
    super.key,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (status ==
            'FIELDSTAFF_VERIFIED' ||
        status ==
            'ADMIN_APPROVED') {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFF2A9D8F),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),
        ),
        onPressed: onTap,
        child: const Text(
          'Verify Loan',
        ),
      ),
    );
  }
}