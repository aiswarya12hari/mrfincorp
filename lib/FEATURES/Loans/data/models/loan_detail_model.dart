// import 'customer_model.dart';

// class LoanDetailModel {
//   final int id;
//   final String loanId;
//   final String loanType;
//   final String loanAmount;
//   final String loanDuration;
//   final String dateOfApplication;
//   final String dateOfExpiry;
//   final String status;
//   final String feedback;
//   final CustomerModel customer;

//   LoanDetailModel({
//     required this.id,
//     required this.loanId,
//     required this.loanType,
//     required this.loanAmount,
//     required this.loanDuration,
//     required this.dateOfApplication,
//     required this.dateOfExpiry,
//     required this.status,
//     required this.feedback,
//     required this.customer,
//   });

//   factory LoanDetailModel.fromJson(
//       Map<String, dynamic> json) {
//     return LoanDetailModel(
//       id: json['id'] ?? 0,
//       loanId: json['loan_id'] ?? '',
//       loanType: json['loan_type'] ?? '',
//       loanAmount:
//           json['loan_amount'].toString(),
//       loanDuration:
//           json['loan_duration'] ?? '',
//       dateOfApplication:
//           json['date_of_application'] ?? '',
//       dateOfExpiry:
//           json['date_of_expiry'] ?? '',
//       status: json['status'] ?? '',
//       feedback: json['feedback'] ?? '',
//       customer: CustomerModel.fromJson(
//         json['customer'] ?? {},
//       ),
//     );
//   }
// }


import 'customer_model.dart';
import 'group_member_model.dart';

class LoanDetailModel {
  final int id;
  final String loanId;
  final String loanType;
  final String loanAmount;
  final String loanDuration;
  final String dateOfApplication;
  final String dateOfExpiry;
  final String status;
  final String feedback;
  final String loanMethod;
  final CustomerModel customer;

  // ── Group loan only fields ──────────────────────────────
  final String groupName;
  final int numberOfMembers;
  final String branchName;
  final List<GroupMemberModel> members;

  LoanDetailModel({
    required this.id,
    required this.loanId,
    required this.loanType,
    required this.loanAmount,
    required this.loanDuration,
    required this.dateOfApplication,
    required this.dateOfExpiry,
    required this.status,
    required this.feedback,
    required this.loanMethod,
    required this.customer,
    required this.groupName,
    required this.numberOfMembers,
    required this.branchName,
    required this.members,
  });

  bool get isGroupLoan => loanMethod == 'group';

  int get verifiedCount => members.where((m) => m.isVerified).length;

  int get unverifiedCount => members.length - verifiedCount;

  factory LoanDetailModel.fromJson(Map<String, dynamic> json) {
    return LoanDetailModel(
      id: json['id'] ?? 0,
      loanId: json['loan_id'] ?? '',
      loanType: json['loan_type'] ?? '',
      loanAmount: json['loan_amount'].toString(),
      loanDuration: json['loan_duration'] ?? '',
      dateOfApplication: json['date_of_application'] ?? '',
      dateOfExpiry: json['date_of_expiry'] ?? '',
      status: json['status'] ?? '',
      feedback: json['feedback'] ?? '',
      loanMethod: json['loan_method'] ?? '',
      // individual loans have a 'customer' object; group loans don't, so default it
      customer: json['customer'] != null
          ? CustomerModel.fromJson(json['customer'])
          : CustomerModel.fromJson({}),
      groupName: json['group_name'] ?? '',
      numberOfMembers: json['number_of_members'] ?? 0,
      branchName: json['branch_name'] ?? '',
      members: json['members'] != null
          ? (json['members'] as List)
              .map((m) => GroupMemberModel.fromJson(m))
              .toList()
          : [],
    );
  }
}