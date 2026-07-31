// import 'package:flutter/material.dart';

// import '../../../../CORE/Theme/app_color.dart';
// import '../../../../CORE/Theme/app_text_style.dart';
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

//   String get _displayStatus => status.replaceAll('_', ' ');

//   // ── Status color helpers (kept dynamic — status is semantic) ──
//   Color get _statusBg {
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

//   Color get _statusFg {
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
//     final bool isGroupLoan = loanMethod.toUpperCase().contains('GROUP');

//     return InkWell(
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
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.gray800.withOpacity(0.05),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Customer name (teal, bold) ──
//             Text(customer, style: AppTextStyles.cardCustomerName(context)),
//             const SizedBox(height: 2),

//             // ── Loan ID (gray, regular) ──
//             Text(loanId, style: AppTextStyles.cardLoanId(context)),
//             const SizedBox(height: 10),

//             // ── Type chip + Status chip ──
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [_typeChip(context), _statusChip(context)],
//             ),

//             const SizedBox(height: 14),
//             const Divider(height: 1, color: AppColors.borderColor),
//             const SizedBox(height: 14),

//             // ── Amount / Date fields ──
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _field(context, label: 'Amount', value: amount),
//                 _field(context, label: 'Date', value: date, alignEnd: true),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _typeChip(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: AppColors.chipActiveBg,
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(type.toUpperCase(), style: AppTextStyles.chipText(context)),
//     );
//   }

//   Widget _statusChip(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: _statusBg,
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         _displayStatus,
//         style: AppTextStyles.chipText(context).copyWith(color: _statusFg),
//       ),
//     );
//   }

//   Widget _field(
//     BuildContext context, {
//     required String label,
//     required String value,
//     bool alignEnd = false,
//   }) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: alignEnd
//             ? CrossAxisAlignment.end
//             : CrossAxisAlignment.start,
//         children: [
//           Text(label, style: AppTextStyles.fieldLabel(context)),
//           const SizedBox(height: 4),
//           Text(value, style: AppTextStyles.fieldValue(context)),
//         ],
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

  // ── Status color helpers ──
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
    final bool isGroupLoan =
        loanMethod.toUpperCase().contains('GROUP');

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => isGroupLoan
                ? GroupLoanDetailPage(
                    loanId: loanId,
                  )
                : LoanDetailPage(
                    loanId: loanId,
                  ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.gray800.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Customer Name
            Text(
              customer,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.cardCustomerName(
                context,
              ),
            ),

            const SizedBox(
              height: 1,
            ),

            /// Loan ID
            Text(
              loanId,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.cardLoanId(
                context,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            /// Type + Status
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: _typeChip(context),
                ),

                const SizedBox(
                  width: 8,
                ),

                Flexible(
                  child: Align(
                    alignment:
                        Alignment.centerRight,
                    child: _statusChip(context),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            const Divider(
              height: 1,
              color: AppColors.borderColor,
            ),

            const SizedBox(
              height: 10,
            ),

            /// Amount / Date
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _field(
                  context,
                  label: 'Amount',
                  value: amount,
                ),

                _field(
                  context,
                  label: 'Date',
                  value: date,
                  alignEnd: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.chipActiveBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.chipText(
          context,
        ),
      ),
    );
  }

  Widget _statusChip(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _statusBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _displayStatus,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.chipText(
          context,
        ).copyWith(
          color: _statusFg,
        ),
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
        crossAxisAlignment: alignEnd
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.fieldLabel(
              context,
            ),
          ),

          const SizedBox(
            height: 3,
          ),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.fieldValue(
              context,
            ),
          ),
        ],
      ),
    );
  }
}