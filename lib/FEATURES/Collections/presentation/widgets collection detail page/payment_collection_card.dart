import 'package:flutter/material.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

class PaymentCollectionCard extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController notesController;
  final String selectedPaymentMethod;
  final ValueChanged<String> onPaymentMethodChanged;

  const PaymentCollectionCard({
    super.key,
    required this.amountController,
    required this.notesController,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });

  static const List<String> paymentMethods = ['CASH', 'GPAY'];

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
          Text('Payment Collection', style: AppTextStyles.cardCustomerName(context).copyWith(fontSize: 17)),
          const SizedBox(height: 16),
          Text('AMOUNT COLLECTED', style: AppTextStyles.fieldLabel(context).copyWith(letterSpacing: 0.3)),
          const SizedBox(height: 8),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text('₹', style: AppTextStyles.inputText(context).copyWith(color: AppColors.gray600)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: AppTextStyles.inputText(context),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Enter amount',
                      hintStyle: AppTextStyles.hint(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('PAYMENT METHOD', style: AppTextStyles.fieldLabel(context).copyWith(letterSpacing: 0.3)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: paymentMethods.map((method) {
              final bool isSelected = method == selectedPaymentMethod;
              return GestureDetector(
                onTap: () => onPaymentMethodChanged(method),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.gray200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    method == 'GPAY' ? 'Google Pay' : 'Cash',
                    style: AppTextStyles.chipText(context).copyWith(
                      color: isSelected ? AppColors.white : AppColors.gray800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          Text('FEEDBACK & NOTES', style: AppTextStyles.fieldLabel(context).copyWith(letterSpacing: 0.3)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: notesController,
              maxLines: 4,
              style: AppTextStyles.inputText(context),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Enter any specific details about this collection session or customer requests...',
                hintStyle: AppTextStyles.hint(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}