import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../../../Dashboard/presentation/widgets/dashboard_animations.dart';
import '../../provider/loan_provider.dart';

class LoanStatusTabs extends StatelessWidget {
  const LoanStatusTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (_, provider, __) {
        final isAll = provider.selectedStatus == null ||
            provider.selectedStatus!.isEmpty;
        final isPending = provider.selectedStatus == 'VERIFICATION_PENDING';
        final isVerified = provider.selectedStatus == 'FIELDSTAFF_VERIFIED';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _tab(
                title: 'All',
                selected: isAll,
                onTap: () => provider.changeStatusTab(null),
              ),
              const SizedBox(width: 10),
              _tab(
                title: 'Pending',
                selected: isPending,
                onTap: () => provider.changeStatusTab('VERIFICATION_PENDING'),
              ),
              const SizedBox(width: 10),
              _tab(
                title: 'Verified',
                selected: isVerified,
                onTap: () => provider.changeStatusTab('FIELDSTAFF_VERIFIED'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tab({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: BouncyTap(
        onTap: onTap,
        scaleDown: 0.96,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOutCubic,
          height: 42,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 13.5,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              letterSpacing: -0.1,
              color: selected ? Colors.white : const Color(0xFF64748B),
            ),
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
