import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../provider/loan_provider.dart';

class LoanStatusTabs extends StatelessWidget {
  const LoanStatusTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (_, provider, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              _tab(
                context,
                title: 'All',
                selected:
                    provider.selectedStatus == null ||
                    provider.selectedStatus!.isEmpty,
                onTap: () {
                  provider.resetFilter();
                },
              ),

              _tab(
                context,
                title: 'Pending',
                selected: provider.selectedStatus == 'VERIFICATION_PENDING',
                onTap: () {
                  provider.changeStatusTab('VERIFICATION_PENDING');
                },
              ),

              _tab(
                context,
                title: 'Verified',
                selected: provider.selectedStatus == 'FIELDSTAFF_VERIFIED',
                onTap: () {
                  provider.changeStatusTab('FIELDSTAFF_VERIFIED');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tab(
    BuildContext context, {
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 44,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
