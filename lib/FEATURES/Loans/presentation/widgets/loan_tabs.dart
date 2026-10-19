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
      builder: (_, provider, child) {
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
          height: 38,
          decoration: BoxDecoration(
            color: selected ? AppColors.secondary : AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? Colors.transparent : AppColors.border,
              width: 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.28),
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
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: -0.1,
              color: selected ? Colors.white : AppColors.textLight,
            ),
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
