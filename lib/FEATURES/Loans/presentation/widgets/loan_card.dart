// import 'package:flutter/material.dart';

// import '../pages/group_loan_detailpage.dart';
// import '../pages/loan_detail_page.dart';

// class LoanCard extends StatelessWidget {
//   final String loanId;
//   final String customer;
//   final String amount;
//   final String date;
//   final String type;
//   final String status;
//   final String loanMethod;

//   const LoanCard({
//     super.key,
//     required this.loanId,
//     required this.customer,
//     required this.amount,
//     required this.date,
//     required this.type,
//     required this.status,
//     required this.loanMethod,
//   });

//   // ── Display helper: "VERIFICATION_PENDING" -> "VERIFICATION PENDING" ──
//   String get _displayStatus => status.replaceAll('_', ' ');

//   // ── Status color helpers ─────────────────────────────────
//   Color get _statusBg {
//     switch (status.toUpperCase()) {
//       case 'FIELDSTAFF_VERIFIED':
//         return const Color(0xFFDEF7EC); // green-100
//       case 'ADMIN_APPROVED':
//         return const Color(0xFFDBEAFE); // blue-100
//       case 'VERIFICATION_PENDING':
//         return const Color(0xFFFEF3C7); // amber-100
//       case 'REJECTED':
//         return const Color(0xFFFEE2E2); // red-100
//       case 'ADMIN_APPROVAL_PENDING':
//         return const Color(0xFFF3E8FF); // purple-100
//       default:
//         return const Color(0xFFF3F4F6); // gray-100
//     }
//   }

//   Color get _statusFg {
//     switch (status.toUpperCase()) {
//       case 'FIELDSTAFF_VERIFIED':
//         return const Color(0xFF065F46); // green-800
//       case 'ADMIN_APPROVED':
//         return const Color(0xFF1E40AF); // blue-800
//       case 'VERIFICATION_PENDING':
//         return const Color(0xFF92400E); // amber-800
//       case 'REJECTED':
//         return const Color(0xFF991B1B); // red-800
//       case 'ADMIN_APPROVAL_PENDING':
//         return const Color(0xFF6B21A8); // purple-800
//       default:
//         return const Color(0xFF374151); // gray-700
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isGroupLoan = loanMethod.toUpperCase().contains('GROUP');

//     return InkWell(
//       borderRadius: BorderRadius.circular(14),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => isGroupLoan
//                 ? GroupLoanDetailPage(loanId: loanId)
//                 : LoanDetailPage(loanId: loanId),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Row 1: Customer name (left) · Loan ID (right) ──
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Text(
//                     customer,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                       color: Color(0xFF2D3748),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   loanId,
//                   style: const TextStyle(
//                     fontFamily: 'Inter',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                     color: Color(0xFF1A202C),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 8),

//             // ── Row 2: Type badge (left) · Amount (right) ──────
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 3,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF0FDF9),
//                     borderRadius: BorderRadius.circular(6),
//                     border: Border.all(
//                       color: const Color(0xFF4FD1C5).withOpacity(0.4),
//                     ),
//                   ),
//                   child: Text(
//                     type.toUpperCase(),
//                     style: const TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF2A9D8F),
//                       letterSpacing: 0.6,
//                     ),
//                   ),
//                 ),

//                 const Spacer(),

//                 Text(
//                   amount,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15,
//                     color: Color(0xFF1A202C),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 10),

//             // ── Divider ─────────────────────────────────────────
//             Divider(color: const Color(0xFFE2E8F0), height: 1, thickness: 1),

//             const SizedBox(height: 10),

//             // ── Row 3: Status chip (left) · Date (right) ────────
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: _statusBg,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     _displayStatus,
//                     style: TextStyle(
//                       color: _statusFg,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w500,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                 ),

//                 const Spacer(),

//                 Text(
//                   date,
//                   style: const TextStyle(
//                     color: Color(0xFF718096),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../pages/group_loan_detailpage.dart';
import '../pages/loan_detail_page.dart';

class LoanCard extends StatelessWidget {
  final String loanId;
  final String customer;
  final String amount;
  final String date;
  final String type;
  final String status;
  final String loanMethod;

  const LoanCard({
    super.key,
    required this.loanId,
    required this.customer,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
    required this.loanMethod,
  });

  String get _displayStatus => status.replaceAll('_', ' ');

  // ── Status color helpers (kept dynamic — status is semantic) ──
  Color get _statusBg {
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

  Color get _statusFg {
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
    final bool isGroupLoan = loanMethod.toUpperCase().contains('GROUP');

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => isGroupLoan
                ? GroupLoanDetailPage(loanId: loanId)
                : LoanDetailPage(loanId: loanId),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
            Text(customer, style: AppTextStyles.cardCustomerName(context)),
            const SizedBox(height: 2),

            // ── Loan ID (gray, regular) ──
            Text(loanId, style: AppTextStyles.cardLoanId(context)),
            const SizedBox(height: 10),

            // ── Type chip + Status chip ──
            Row(
              children: [
                _typeChip(context),
                const SizedBox(width: 8),
                _statusChip(context),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.borderColor),
            const SizedBox(height: 14),

            // ── Amount / Date fields ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(context, label: 'Amount', value: amount),
                _field(context, label: 'Date', value: date, alignEnd: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.chipActiveBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(type.toUpperCase(), style: AppTextStyles.chipText(context)),
    );
  }

  Widget _statusChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _statusBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _displayStatus,
        style: AppTextStyles.chipText(context).copyWith(color: _statusFg),
      ),
    );
  }

  Widget _field(
    BuildContext context, {
    required String label,
    required String value,
    bool alignEnd = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.fieldLabel(context)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.fieldValue(context)),
        ],
      ),
    );
  }
}