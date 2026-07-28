import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/loan_provider.dart';

class LoanSearchBar extends StatefulWidget {
  const LoanSearchBar({super.key});

  @override
  State<LoanSearchBar> createState() => _LoanSearchBarState();
}

class _LoanSearchBarState extends State<LoanSearchBar> {
  final TextEditingController _controller = TextEditingController();

  // void _search() {
  //   final text = _controller.text.trim();

  //   final provider = context.read<LoanProvider>();

  //   if (text.isEmpty) {
  //     provider.resetFilter();
  //     return;
  //   }

  //   final isLoanId = text.toUpperCase().contains('PKD');

  //   provider.applyFilter(
  //     loanId: isLoanId ? text : null,
  //     customerName: isLoanId ? null : text,
  //   );
  // }

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

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,

      onSubmitted: (_) => _search(),

      decoration: InputDecoration(
        hintText: 'Search by Loan ID or Customer',

        prefixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: _search,
        ),

        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                // icon: const Icon(Icons.close),
                // onPressed: () {
                //   _controller.clear();

                //   context.read<LoanProvider>().resetFilter();

                //   setState(() {});
                // },
                icon: const Icon(Icons.close),
                onPressed: () {
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
                },
              )
            : null,

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      onChanged: (_) {
        setState(() {});
      },
    );
  }
}
