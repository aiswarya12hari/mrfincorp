import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collected_collection_model.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

class CollectedCard extends StatelessWidget {
  final CollectedCollectionModel data;
  final VoidCallback? onTap;

  const CollectedCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
            Text(
              data.customerName,
              style: AppTextStyles.cardCustomerName(context),
            ),
            const SizedBox(height: 2),
            Text(data.loanId, style: AppTextStyles.cardLoanId(context)),
            const SizedBox(height: 10),
            Row(
              children: [
                _chip(context, data.frequencyLabel),
                const SizedBox(width: 8),
                _chip(context, data.paymentMethod),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.borderColor),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(
                  context,
                  label: 'Collected Amount',
                  value: '₹${_format(data.collectedAmount)}',
                ),
                _field(
                  context,
                  label: 'Collected Date',
                  value: data.formattedCollectedDate,
                  alignEnd: true,
                ),
              ],
            ),
            if (data.feedback.isNotEmpty) ...[
              const SizedBox(height: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Feedback', style: AppTextStyles.fieldLabel(context)),
                  const SizedBox(height: 4),
                  Text(data.feedback, style: AppTextStyles.fieldValue(context)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.chipActiveBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: AppTextStyles.chipText(context)),
    );
  }

  Widget _field(
    BuildContext context, {
    required String label,
    required String value,
    bool alignEnd = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: alignEnd
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.fieldLabel(context)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.fieldValue(context)),
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
