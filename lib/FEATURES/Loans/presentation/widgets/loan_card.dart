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

//   @override
//   Widget build(BuildContext context) {
//     final bool verified =
//         status == 'FIELDSTAFF_VERIFIED';

//     final bool isGroupLoan =
//         loanMethod.toUpperCase().contains('GROUP');

//     return InkWell(
//       borderRadius: BorderRadius.circular(12),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => isGroupLoan
//                 ? GroupLoanDetailPage(
//                     loanId: loanId,
//                   )
//                 : LoanDetailPage(
//                     loanId: loanId,
//                   ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(
//           bottom: 12,
//         ),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius:
//               BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color:
//                   Colors.black.withOpacity(.04),
//               blurRadius: 8,
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment:
//               CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     loanId,
//                     style: const TextStyle(
//                       fontWeight:
//                           FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 4),

//                   Text(customer),

//                   const SizedBox(height: 4),

//                   Text(
//                     type,
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                     ),
//                   ),

//                   const SizedBox(height: 6),

//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 3,
//                     ),
//                     decoration: BoxDecoration(
//                       color: verified
//                           ? Colors.green
//                               .withOpacity(.15)
//                           : Colors.orange
//                               .withOpacity(.15),
//                       borderRadius:
//                           BorderRadius.circular(4),
//                     ),
//                     child: Text(
//                       status,
//                       style: TextStyle(
//                         color: verified
//                             ? Colors.green
//                             : Colors.orange,
//                         fontSize: 11,
//                         fontWeight:
//                             FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   amount,
//                   style: const TextStyle(
//                     fontWeight:
//                         FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   date,
//                   style: TextStyle(
//                     color: Colors.grey[600],
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
//     final bool isGroupLoan =
//         loanMethod.toUpperCase().contains('GROUP');

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
//             // ── Row 1: Loan ID (left) · Customer name (right) ──
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Text(
//                     loanId,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 14,
//                       color: Color(0xFF1A202C),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   customer,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                     color: Color(0xFF2D3748),
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
//                       horizontal: 8, vertical: 3),
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
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF2A9D8F),
//                       letterSpacing: 0.6,
//                     ),
//                   ),
//                 ),

//                 const Spacer(),

//                 Text(
//                   amount,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 15,
//                     color: Color(0xFF1A202C),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 10),

//             // ── Divider ─────────────────────────────────────────
//             Divider(
//               color: const Color(0xFFE2E8F0),
//               height: 1,
//               thickness: 1,
//             ),

//             const SizedBox(height: 10),

//             // ── Row 3: Status chip (left) · Date (right) ────────
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: _statusBg,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     status,
//                     style: TextStyle(
//                       color: _statusFg,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700,
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

  // ── Display helper: "VERIFICATION_PENDING" -> "VERIFICATION PENDING" ──
  String get _displayStatus => status.replaceAll('_', ' ');

  // ── Status color helpers ─────────────────────────────────
  Color get _statusBg {
    switch (status.toUpperCase()) {
      case 'FIELDSTAFF_VERIFIED':
        return const Color(0xFFDEF7EC); // green-100
      case 'ADMIN_APPROVED':
        return const Color(0xFFDBEAFE); // blue-100
      case 'VERIFICATION_PENDING':
        return const Color(0xFFFEF3C7); // amber-100
      case 'REJECTED':
        return const Color(0xFFFEE2E2); // red-100
      case 'ADMIN_APPROVAL_PENDING':
        return const Color(0xFFF3E8FF); // purple-100
      default:
        return const Color(0xFFF3F4F6); // gray-100
    }
  }

  Color get _statusFg {
    switch (status.toUpperCase()) {
      case 'FIELDSTAFF_VERIFIED':
        return const Color(0xFF065F46); // green-800
      case 'ADMIN_APPROVED':
        return const Color(0xFF1E40AF); // blue-800
      case 'VERIFICATION_PENDING':
        return const Color(0xFF92400E); // amber-800
      case 'REJECTED':
        return const Color(0xFF991B1B); // red-800
      case 'ADMIN_APPROVAL_PENDING':
        return const Color(0xFF6B21A8); // purple-800
      default:
        return const Color(0xFF374151); // gray-700
    }
  }



  @override
  Widget build(BuildContext context) {
    final bool isGroupLoan =
        loanMethod.toUpperCase().contains('GROUP');

    return InkWell(
      borderRadius: BorderRadius.circular(14),
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: Loan ID (left) · Customer name (right) ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    loanId,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF1A202C),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  customer,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Row 2: Type badge (left) · Amount (right) ──────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFF4FD1C5).withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    type.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A9D8F),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  amount,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1A202C),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Divider ─────────────────────────────────────────
            Divider(
              color: const Color(0xFFE2E8F0),
              height: 1,
              thickness: 1,
            ),

            const SizedBox(height: 10),

            // ── Row 3: Status chip (left) · Date (right) ────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _displayStatus,
                    style: TextStyle(
                      color: _statusFg,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}