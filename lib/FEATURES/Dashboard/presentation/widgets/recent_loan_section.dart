// import 'package:flutter/material.dart';
// import 'package:mr_fincorp/CORE/Theme/app_color.dart';
// import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
// import 'package:mr_fincorp/CORE/Utils/responsive.dart';
// import 'package:provider/provider.dart';
// import '../../provider/dashboard_provider.dart';
// import '../../../Navigation/presentation/pages/bottom_nav_page.dart';
// import '../../../Loans/presentation/pages/loan_detail_page.dart';
// import '../../../Loans/presentation/pages/group_loan_detailpage.dart';

// class RecentLoansSection extends StatelessWidget {
//   const RecentLoansSection({super.key});

//   Color _statusBg(String status) {
//     switch (status.toUpperCase()) {
//       case 'FIELDSTAFF_VERIFIED':
//         return const Color(0xFFDEF7EC);
//       case 'ADMIN_APPROVED':
//         return const Color(0xFFDBEAFE);
//       case 'VERIFICATION_PENDING':
//         return const Color(0xFFFEF3C7);
//       case 'REJECTED':
//         return const Color(0xFFFEE2E2);
//       case 'ADMIN_APPROVAL_PENDING':
//         return const Color(0xFFF3E8FF);
//       default:
//         return const Color(0xFFF3F4F6);
//     }
//   }

//   Color _statusFg(String status) {
//     switch (status.toUpperCase()) {
//       case 'FIELDSTAFF_VERIFIED':
//         return const Color(0xFF065F46);
//       case 'ADMIN_APPROVED':
//         return const Color(0xFF1E40AF);
//       case 'VERIFICATION_PENDING':
//         return const Color(0xFF92400E);
//       case 'REJECTED':
//         return const Color(0xFF991B1B);
//       case 'ADMIN_APPROVAL_PENDING':
//         return const Color(0xFF6B21A8);
//       default:
//         return const Color(0xFF374151);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dim = Dimensions(context);
//     final provider = context.watch<DashboardProvider>();
//     final loans = provider.recentLoans;

//     if (loans.isEmpty) return const SizedBox();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Recent Loans',
//               style: TextStyle(
//                 fontFamily: AppTextStyles.fontFamily,
//                 fontSize: dim.sp(22),
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.gray800,
//               ),
//             ),

//             TextButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const BottomNavPage(initialIndex: 1),
//                   ),
//                 );
//               },
//               child: Text(
//                 'View All',
//                 style: TextStyle(fontSize: dim.sp(14), color: Colors.black),
//               ),
//             ),
//           ],
//         ),

//         SizedBox(height: dim.gap(0.014)),

//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: loans.length,
//           itemBuilder: (context, index) {
//             final loan = loans[index];
//             final bool isGroupLoan = loan.loanMethod.toUpperCase().contains(
//               'GROUP',
//             );
//             final String displayName = loan.customerName;
//             final String formattedAmount =
//                 '₹ ${double.tryParse(loan.loanAmount)?.toStringAsFixed(0) ?? loan.loanAmount}';

//             return InkWell(
//               borderRadius: BorderRadius.circular(14),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => isGroupLoan
//                         ? GroupLoanDetailPage(loanId: loan.loanId)
//                         : LoanDetailPage(loanId: loan.loanId),
//                   ),
//                 );
//               },
//               child: Container(
//                 margin: EdgeInsets.only(bottom: dim.gap(0.014)),
//                 padding: EdgeInsets.fromLTRB(
//                   dim.width(0.04),
//                   dim.gap(0.016),
//                   dim.width(0.04),
//                   dim.gap(0.016),
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Text(
//                             displayName,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontFamily: 'Inter',
//                               fontWeight: FontWeight.w600,
//                               fontSize: dim.sp(14),
//                               color: const Color(0xFF2D3748),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: dim.width(0.02)),
//                         Expanded(
//                           flex: 1,
//                           child: Text(
//                             loan.loanId,
//                             textAlign: TextAlign.right,
//                             style: TextStyle(
//                               fontFamily: 'Inter',
//                               fontWeight: FontWeight.w400,
//                               fontSize: dim.sp(14),
//                               color: const Color(0xFF1A202C),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: dim.gap(0.01)),

//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: dim.width(0.02),
//                             vertical: dim.gap(0.004),
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFF0FDF9),
//                             borderRadius: BorderRadius.circular(6),
//                             border: Border.all(
//                               color: const Color(0xFF4FD1C5).withOpacity(0.4),
//                             ),
//                           ),
//                           child: Text(
//                             loan.loanType.isNotEmpty
//                                 ? loan.loanType.toUpperCase()
//                                 : loan.loanMethod.toUpperCase(),
//                             style: TextStyle(
//                               fontSize: dim.sp(10),
//                               fontWeight: FontWeight.w500,
//                               color: const Color(0xFF2A9D8F),
//                               letterSpacing: 0.6,
//                             ),
//                           ),
//                         ),
//                         const Spacer(),
//                         Text(
//                           formattedAmount,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: dim.sp(15),
//                             color: const Color(0xFF1A202C),
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: dim.gap(0.012)),

//                     const Divider(
//                       color: Color(0xFFE2E8F0),
//                       height: 1,
//                       thickness: 1,
//                     ),

//                     SizedBox(height: dim.gap(0.012)),

//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: dim.width(0.025),
//                             vertical: dim.gap(0.005),
//                           ),
//                           decoration: BoxDecoration(
//                             color: _statusBg(loan.status),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             loan.status.replaceAll('_', ' '),
//                             style: TextStyle(
//                               color: _statusFg(loan.status),
//                               fontSize: dim.sp(11),
//                               fontWeight: FontWeight.w500,
//                               letterSpacing: 0.2,
//                             ),
//                           ),
//                         ),
//                         const Spacer(),
//                         Text(
//                           loan.dateOfApplication,
//                           style: TextStyle(
//                             color: const Color(0xFF718096),
//                             fontSize: dim.sp(12),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
import 'package:mr_fincorp/CORE/Utils/responsive.dart';
import 'package:provider/provider.dart';
import '../../provider/dashboard_provider.dart';
import '../../../Navigation/presentation/pages/bottom_nav_page.dart';
import '../../../Loans/presentation/pages/loan_detail_page.dart';
import '../../../Loans/presentation/pages/group_loan_detailpage.dart';

class RecentLoansSection extends StatelessWidget {
  const RecentLoansSection({super.key});

  Color _statusBg(String status) {
    switch (status.toUpperCase()) {
      case 'FIELDSTAFF_VERIFIED':
        return const Color(0xFFDEF7EC);
      case 'ADMIN_APPROVED':
        return const Color(0xFFDBEAFE);
      case 'VERIFICATION_PENDING':
        return const Color(0xFFFEF3C7);
      case 'REJECTED':
        return const Color(0xFFFEE2E2);
      case 'ADMIN_APPROVAL_PENDING':
        return const Color(0xFFF3E8FF);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _statusFg(String status) {
    switch (status.toUpperCase()) {
      case 'FIELDSTAFF_VERIFIED':
        return const Color(0xFF065F46);
      case 'ADMIN_APPROVED':
        return const Color(0xFF1E40AF);
      case 'VERIFICATION_PENDING':
        return const Color(0xFF92400E);
      case 'REJECTED':
        return const Color(0xFF991B1B);
      case 'ADMIN_APPROVAL_PENDING':
        return const Color(0xFF6B21A8);
      default:
        return const Color(0xFF374151);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dim = Dimensions(context);
    final provider = context.watch<DashboardProvider>();
    final loans = provider.recentLoans;

    if (loans.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Loans',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: dim.sp(22),
                fontWeight: FontWeight.w600,
                color: AppColors.gray800,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BottomNavPage(initialIndex: 1),
                  ),
                );
              },
              child: Text(
                'View All',
                style: TextStyle(fontSize: dim.sp(14), color: Colors.black),
              ),
            ),
          ],
        ),

        SizedBox(height: dim.gap(0.014)),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: loans.length,
          itemBuilder: (context, index) {
            final loan = loans[index];
            final bool isGroupLoan = loan.loanMethod.toUpperCase().contains(
              'GROUP',
            );
            final String displayName = loan.customerName;
            final String formattedAmount =
                '₹ ${double.tryParse(loan.loanAmount)?.toStringAsFixed(0) ?? loan.loanAmount}';
            final String typeLabel = loan.loanType.isNotEmpty
                ? loan.loanType.toUpperCase()
                : loan.loanMethod.toUpperCase();

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => isGroupLoan
                        ? GroupLoanDetailPage(loanId: loan.loanId)
                        : LoanDetailPage(loanId: loan.loanId),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                margin: EdgeInsets.only(bottom: dim.gap(0.02)),
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
                    // ── Customer name (teal, bold) ──
                    Text(
                      displayName,
                      style: AppTextStyles.cardCustomerName(context),
                    ),
                    const SizedBox(height: 2),

                    // ── Loan ID (gray, regular) ──
                    Text(
                      loan.loanId,
                      style: AppTextStyles.cardLoanId(context),
                    ),
                    const SizedBox(height: 10),

                    // ── Type chip + Status chip ──
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.chipActiveBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            typeLabel,
                            style: AppTextStyles.chipText(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _statusBg(loan.status),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            loan.status.replaceAll('_', ' '),
                            style: AppTextStyles.chipText(context).copyWith(
                              color: _statusFg(loan.status),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    const Divider(height: 1, color: AppColors.borderColor),
                    const SizedBox(height: 14),

                    // ── Amount / Date fields ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Amount',
                                style: AppTextStyles.fieldLabel(context),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedAmount,
                                style: AppTextStyles.fieldValue(context),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Date',
                                style: AppTextStyles.fieldLabel(context),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                loan.dateOfApplication,
                                style: AppTextStyles.fieldValue(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}