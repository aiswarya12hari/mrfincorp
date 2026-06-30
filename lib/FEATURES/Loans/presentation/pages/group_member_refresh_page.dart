import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/group_member_page.dart';
import 'package:provider/provider.dart';

import '../../provider/loan_detail_provider.dart';
class GroupMembersRefreshPage extends StatefulWidget {
  final String loanId;

  const GroupMembersRefreshPage({super.key, required this.loanId});

  @override
  State<GroupMembersRefreshPage> createState() =>
      _GroupMembersRefreshPageState();
}

class _GroupMembersRefreshPageState extends State<GroupMembersRefreshPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoanDetailProvider>().fetchLoanDetail(widget.loanId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      body: Consumer<LoanDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final detail = provider.loanDetail;

          if (detail == null) {
            return const Center(child: Text('No Data'));
          }

          return GroupMembersPage(detail: detail);
        },
      ),
    );
  }
}