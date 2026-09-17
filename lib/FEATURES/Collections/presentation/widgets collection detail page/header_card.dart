import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_detail_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

class CollectionDetailHeaderCard extends StatelessWidget {
  final CollectionDetailModel data;

  const CollectionDetailHeaderCard({super.key, required this.data});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final trimmed = phoneNumber.trim();
    if (trimmed.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: trimmed);
    try {
      await launchUrl(uri);
    } catch (e) {
      debugPrint('CALL ERROR => $e');
    }
  }

  Future<void> _openMap(String url) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return;
    try {
      final uri = Uri.parse(trimmed);
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('MAP OPEN ERROR => $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray800.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Customer Name (Larger & Bolder) ───────────────────
          Text(
            data.customerName,
            style: AppTextStyles.cardCustomerName(context).copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),

          // ── ID & Loan ID Row ─────────────────────────────────
          Wrap(
            spacing: 12,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'ID: ',
                      style: AppTextStyles.cardLoanId(context).copyWith(
                        color: AppColors.gray600,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '${data.id}',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray800,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 12,
                color: AppColors.borderColor,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Loan ID: ',
                      style: AppTextStyles.cardLoanId(context).copyWith(
                        color: AppColors.gray600,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: data.loanId,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ── Large Clickable Phone Number Card ────────────────
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: data.customerPhone.trim().isNotEmpty
                  ? () => _makePhoneCall(data.customerPhone)
                  : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 56),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.phone_rounded,
                          size: 24,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'PHONE NUMBER',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: AppColors.gray600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            data.customerPhone.trim().isNotEmpty
                                ? data.customerPhone
                                : 'No phone number',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gray800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (data.customerPhone.trim().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.call_rounded, size: 14, color: AppColors.white),
                            SizedBox(width: 5),
                            Text(
                              'Call',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: AppColors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Address Section with House Icon, Spacing & Darker Text ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.borderColor,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.borderColor,
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.home_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Address',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.customerAddress.trim().isNotEmpty
                            ? data.customerAddress
                            : '-',
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A202C),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Full-Width Customer Location Card ("Tap to Open Google Maps") ──
          if (data.customerLocation.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _openMap(data.customerLocation),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 52),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.location_on_rounded,
                            size: 22,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'CUSTOMER LOCATION',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: AppColors.gray600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Tap to Open Google Maps',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.open_in_new_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),

          // ── Area and Branch as Info Chips (+ Loan Chips) ─────
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoChip(
                context,
                icon: Icons.place_outlined,
                backgroundColor: AppColors.chipBg,
                borderColor: AppColors.borderColor,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Area: ',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray600,
                        ),
                      ),
                      TextSpan(
                        text: data.area.trim().isNotEmpty ? data.area : '-',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _infoChip(
                context,
                icon: Icons.account_balance_outlined,
                backgroundColor: AppColors.chipBg,
                borderColor: AppColors.borderColor,
                child: Text(
                  data.branchName.trim().isNotEmpty ? data.branchName : '-',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray800,
                  ),
                ),
              ),
              _chip(context, data.loanType),
              _chip(context, data.loanStatus),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, color: AppColors.borderColor),
          const SizedBox(height: 18),

          // ── Loan Financial Metrics ───────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(
                context,
                label: 'LOAN AMOUNT',
                value: '₹${_format(data.loanAmount)}',
              ),
              _field(
                context,
                label: 'COLLECTION DATE',
                value: data.formattedDueDate,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(
                context,
                label: 'PRINCIPAL BALANCE',
                value: '₹${_format(data.principalPending)}',
              ),
              _field(
                context,
                label: 'FINE BALANCE',
                value: '₹${_format(data.finePending)}',
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(
                context,
                label: 'PRINCIPAL PAID',
                value: '₹${_format(data.principalPaid)}',
              ),
              _field(
                context,
                label: 'FINE PAID',
                value: '₹${_format(data.finePaid)}',
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(
                context,
                label: 'DUE PENDING',
                value: data.duePending.toString(),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(
    BuildContext context, {
    required IconData icon,
    required Widget child,
    Color? backgroundColor,
    Color? iconColor,
    Color? borderColor,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 34),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.chipBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor ?? AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: iconColor ?? AppColors.primary),
          const SizedBox(width: 6),
          child,
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label) {
    return Container(
      constraints: const BoxConstraints(minHeight: 34),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.chipActiveBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.chipText(context).copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    BuildContext context, {
    required String label,
    required String value,
    bool alignEnd = false,
    TextAlign? align,
  }) {
    final effectiveAlign =
        align ?? (alignEnd ? TextAlign.end : TextAlign.start);
    final crossAlign = effectiveAlign == TextAlign.end
        ? CrossAxisAlignment.end
        : (effectiveAlign == TextAlign.center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start);

    return Expanded(
      child: Column(
        crossAxisAlignment: crossAlign,
        children: [
          Text(
            label,
            textAlign: effectiveAlign,
            style: AppTextStyles.fieldLabel(context).copyWith(letterSpacing: 0.3),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: effectiveAlign,
            style: AppTextStyles.fieldValue(context).copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Whole numbers show no decimals (₹20,000); fractional values show 2dp (₹12,173.98).
  String _format(double value) {
    final isWhole = value == value.roundToDouble();
    final intPart = value.truncate().abs().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      final posFromEnd = intPart.length - i;
      buffer.write(intPart[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write(',');
    }
    if (isWhole) return buffer.toString();
    final decimalPart = (value.abs() - value.abs().truncate())
        .toStringAsFixed(2)
        .substring(1); // ".98"
    return '${buffer.toString()}$decimalPart';
  }
}