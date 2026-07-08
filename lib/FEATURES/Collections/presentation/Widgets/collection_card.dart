import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_model.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

class CollectionCard extends StatelessWidget {
  final CollectionModel data;
  final VoidCallback? onTap;

  const CollectionCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.gray800.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.customerName, style: AppTextStyles.cardCustomerName(context)),
            const SizedBox(height: 2),
            Text(data.loanId, style: AppTextStyles.cardLoanId(context)),
            const SizedBox(height: 10),
            Row(
              children: [
                _chip(context, data.frequencyLabel),
                const SizedBox(width: 8),
                _areaChip(context, data.area),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.borderColor),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(context, label: 'Principal', value: '₹${_format(data.principal)}'),
                _field(
                  context,
                  label: 'Due',
                  value: '₹${_format(data.due)}',
                  alignEnd: true,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(
                  context,
                  label: 'Outstanding',
                  value: '₹${_format(data.outstanding)}',
                  danger: data.isOverdue,
                ),
                _field(
                  context,
                  label: 'Due Date',
                  value: data.dueDate,
                  alignEnd: true,
                ),
              ],
            ),
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

  Widget _areaChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: AppTextStyles.areaChipText(context)),
    );
  }

  Widget _field(
    BuildContext context, {
    required String label,
    required String value,
    bool alignEnd = false,
    bool danger = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.fieldLabel(context)),
          const SizedBox(height: 4),
          Text(
            value,
            style: danger
                ? AppTextStyles.fieldValueDanger(context)
                : AppTextStyles.fieldValue(context),
          ),
        ],
      ),
    );
  }

  String _format(double value) {
    // Simple thousands separator, e.g. 20000 -> 20,000
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