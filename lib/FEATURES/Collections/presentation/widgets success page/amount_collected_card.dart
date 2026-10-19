import 'package:flutter/material.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

class AmountCollectedCard extends StatelessWidget {
  final double amount;

  const AmountCollectedCard({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray800.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'AMOUNT COLLECTED',
            style: AppTextStyles.fieldLabel(context).copyWith(letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${_format(amount)}',
            style: AppTextStyles.headline(context).copyWith(
              color: AppColors.primary,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }

  String _format(double value) {
    final str = value.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final posFromEnd = str.length - i;
      buffer.write(str[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }
}