import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_model.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

class CollectionDetailHeaderCard extends StatelessWidget {
  final CollectionModel data;

  const CollectionDetailHeaderCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          Text(data.customerName, style: AppTextStyles.cardCustomerName(context).copyWith(fontSize: 20)),
          const SizedBox(height: 4),
          Text('ID: ${data.id}', style: AppTextStyles.cardLoanId(context)),
          const SizedBox(height: 12),
          Row(
            children: [
              _chip(context, data.frequencyLabel),
              const SizedBox(width: 8),
              _areaChip(context, data.area),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.borderColor),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(context, label: 'PRINCIPAL PENDING', value: '₹${_format(data.principal)}'),
              _field(context, label: 'DUE AMOUNT', value: '₹${_format(data.due)}', alignEnd: true),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(context, label: 'DUE DATE', value: data.dueDate),
              _field(
                context,
                label: 'INSTALLMENT',
                value: data.installment != null ? '₹${_format(data.installment!)}' : '-',
                alignEnd: true,
              ),
            ],
          ),
        ],
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
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.fieldLabel(context).copyWith(letterSpacing: 0.3)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.fieldValue(context).copyWith(fontSize: 16)),
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