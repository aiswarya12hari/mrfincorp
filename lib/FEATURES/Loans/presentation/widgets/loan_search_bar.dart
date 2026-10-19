import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../../provider/loan_provider.dart';

class LoanSearchBar extends StatefulWidget {
  const LoanSearchBar({super.key});

  @override
  State<LoanSearchBar> createState() => _LoanSearchBarState();
}

class _LoanSearchBarState extends State<LoanSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final text = _controller.text.trim();
    final provider = context.read<LoanProvider>();
    final isLoanId = text.toUpperCase().contains('PKD');

    provider.applyFilter(
      status: provider.selectedStatus,
      loanType: provider.selectedLoanType,
      loanMethod: provider.selectedLoanMethod,
      dateFrom: provider.selectedDateFrom,
      dateTo: provider.selectedDateTo,
      loanId: isLoanId ? text : null,
      customerName: isLoanId ? null : text,
    );
  }

  void _clear() {
    _controller.clear();
    final provider = context.read<LoanProvider>();
    provider.applyFilter(
      status: provider.selectedStatus,
      loanType: provider.selectedLoanType,
      loanMethod: provider.selectedLoanMethod,
      dateFrom: provider.selectedDateFrom,
      dateTo: provider.selectedDateTo,
      loanId: null,
      customerName: null,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.85),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onSubmitted: (_) => _search(),
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.gray800,
        ),
        decoration: InputDecoration(
          hintText: 'Search by Loan ID or Customer name...',
          hintStyle: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            color: AppColors.gray400,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: IconButton(
              icon: const Icon(
                Icons.search_rounded,
                size: 22,
                color: Color(0xFF64748B),
              ),
              onPressed: _search,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 44,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColors.gray600,
                  ),
                  onPressed: _clear,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: (_) {
          setState(() {});
        },
      ),
    );
  }
}
