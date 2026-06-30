// // import 'package:flutter/material.dart';
// // import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets%20group%20loan/group_header.dart';
// // import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets%20group%20loan/group_status_card.dart';
// // import 'package:mr_fincorp/FEATURES/Loans/provider/loan_detail_provider.dart';
// // import 'package:provider/provider.dart';
// // import '../widgets group loan/group_summary_card.dart';
// // import '../widgets group loan/view_members_button.dart';

// // class GroupLoanDetailPage extends StatefulWidget {
// //   final String loanId;

// //   const GroupLoanDetailPage({super.key, required this.loanId});

// //   @override
// //   State<GroupLoanDetailPage> createState() => _GroupLoanDetailPageState();
// // }

// // class _GroupLoanDetailPageState extends State<GroupLoanDetailPage> {
// //   @override
// //   void initState() {
// //     super.initState();

// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       context.read<LoanDetailProvider>().fetchLoanDetail(widget.loanId);
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xffF7F8FA),

// //       appBar: AppBar(title: const Text("Group Loan Details")),

// //       body: Consumer<LoanDetailProvider>(
// //         builder: (context, provider, _) {
// //           if (provider.isLoading) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           final detail = provider.loanDetail;

// //           if (detail == null) {
// //             return const Center(child: Text("No Data"));
// //           }

// //           return SingleChildScrollView(
// //             padding: const EdgeInsets.all(16),
// //             child: Column(
// //               children: [
// //                 GroupHeaderCard(loanId: detail.loanId, status: detail.status),

// //                 const SizedBox(height: 16),

// //                 Row(
// //                   children: [
// //                     GroupStatsCard(
// //                       title: "Loan Amount",
// //                       value: detail.loanAmount,
// //                     ),
// //                     const SizedBox(width: 10),
// //                     // GroupStatsCard(
// //                     //   title: "Verified",
// //                     //   value: detail.verifiedCount.toString(),
// //                     // ),
// //                     // const SizedBox(width: 10),
// //                     // GroupStatsCard(
// //                     //   title: "Unverified",
// //                     //   value: detail.unverifiedCount.toString(),
// //                     // ),
// //                   ],
// //                 ),

// //                 const SizedBox(height: 16),

// //                 GroupSummaryCard(detail: detail),

// //                 const SizedBox(height: 24),

// //                 ViewMembersButton(
// //                   onTap: () {
// //                     // NEXT PAGE
// //                   },
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets%20group%20loan/group_header.dart';
// import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets%20group%20loan/group_status_card.dart';
// import 'package:mr_fincorp/FEATURES/Loans/provider/loan_detail_provider.dart';
// import 'package:provider/provider.dart';
// import '../widgets group loan/group_summary_card.dart';
// import '../widgets group loan/view_members_button.dart';
// import 'group_member_page.dart';

// class GroupLoanDetailPage extends StatefulWidget {
//   final String loanId;

//   const GroupLoanDetailPage({super.key, required this.loanId});

//   @override
//   State<GroupLoanDetailPage> createState() => _GroupLoanDetailPageState();
// }

// class _GroupLoanDetailPageState extends State<GroupLoanDetailPage> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<LoanDetailProvider>().fetchLoanDetail(widget.loanId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF7F8FA),

//       appBar: AppBar(title: const Text("Group Loan Details")),

//       body: Consumer<LoanDetailProvider>(
//         builder: (context, provider, _) {
//           if (provider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final detail = provider.loanDetail;

//           if (detail == null) {
//             return const Center(child: Text("No Data"));
//           }

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 // GroupHeaderCard(loanId: detail.loanId, status: detail.status),

//                 // const SizedBox(height: 16),

//                 // Row(
//                 //   children: [
//                 //     GroupStatsCard(
//                 //       title: "Total Members",
//                 //       value: detail.members.length.toString(),
//                 //     ),
//                 //     const SizedBox(width: 10),
//                 //     GroupStatsCard(
//                 //       title: "Verified Members",
//                 //       value: detail.verifiedCount.toString(),
//                 //     ),
//                 //     const SizedBox(width: 10),
//                 //     GroupStatsCard(
//                 //       title: "Unverified Members",
//                 //       value: detail.unverifiedCount.toString(),
//                 //     ),
//                 //   ],
//                 // ),
//                 GroupHeaderCard(
//                   loanId: detail.loanId,
//                   status: detail.status,
//                   groupName: detail.groupName,
//                   createdDate: detail.dateOfApplication,
//                 ),

//                 const SizedBox(height: 16),

//                 Row(
//                   children: [
//                     GroupStatsCard(
//                       title: "Total Members",
//                       value: detail.members.length.toString(),
//                       type: StatCardType.total,
//                     ),
//                     const SizedBox(width: 10),
//                     GroupStatsCard(
//                       title: "Verified Members",
//                       value: detail.verifiedCount.toString(),
//                       type: StatCardType.verified,
//                     ),
//                     const SizedBox(width: 10),
//                     GroupStatsCard(
//                       title: "Unverified Members",
//                       value: detail.unverifiedCount.toString(),
//                       type: StatCardType.unverified,
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 16),

//                 GroupSummaryCard(detail: detail),

//                 const SizedBox(height: 24),

//                 ViewMembersButton(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => GroupMembersPage(detail: detail),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets%20group%20loan/group_header.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets%20group%20loan/group_status_card.dart';
import 'package:mr_fincorp/FEATURES/Loans/provider/loan_detail_provider.dart';
import 'package:provider/provider.dart';
import '../widgets group loan/group_summary_card.dart';
import '../widgets group loan/view_members_button.dart';
import 'group_member_page.dart';

class GroupLoanDetailPage extends StatefulWidget {
  final String loanId;

  const GroupLoanDetailPage({super.key, required this.loanId});

  @override
  State<GroupLoanDetailPage> createState() => _GroupLoanDetailPageState();
}

class _GroupLoanDetailPageState extends State<GroupLoanDetailPage> {
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

      appBar: AppBar(title: const Text("Group Loan Details")),

      body: Consumer<LoanDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final detail = provider.loanDetail;

          if (detail == null) {
            return const Center(child: Text("No Data"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              children: [
                GroupHeaderCard(
                  loanId: detail.loanId,
                  status: detail.status,
                  groupName: detail.groupName,
                  createdDate: detail.dateOfApplication,
                ),

                const SizedBox(height: 16),

                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GroupStatsCard(
                        title: "Total Members",
                        value: detail.members.length.toString(),
                        type: StatCardType.total,
                      ),
                      const SizedBox(width: 10),
                      GroupStatsCard(
                        title: "Verified Members",
                        value: detail.verifiedCount.toString(),
                        type: StatCardType.verified,
                      ),
                      const SizedBox(width: 10),
                      GroupStatsCard(
                        title: "Unverified Members",
                        value: detail.unverifiedCount.toString(),
                        type: StatCardType.unverified,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                GroupSummaryCard(detail: detail),

                // space so content isn't hidden behind the fixed bottom button
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: Consumer<LoanDetailProvider>(
        builder: (context, provider, _) {
          final detail = provider.loanDetail;

          if (detail == null) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(color: Color(0xffF7F8FA)),
            child: SafeArea(
              top: false,
              child: ViewMembersButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GroupMembersPage(detail: detail),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}