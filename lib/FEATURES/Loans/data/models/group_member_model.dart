// class GroupMemberModel {
//   final String customerId;
//   final String name;

//   GroupMemberModel({
//     required this.customerId,
//     required this.name,
//   });

//   factory GroupMemberModel.fromJson(
//     Map<String, dynamic> json,
//   ) {
//     return GroupMemberModel(
//       customerId: json['customer_id'] ?? '',
//       name: json['name'] ?? '',
//     );
//   }
// }

class GroupMemberModel {
  final int customerId;
  final String name;
  final String customerCode;
  // final String nomineeName;
  // final String nomineeImage;
  final String installmentAmount;
  final bool isVerified;
  final String? verifiedOn;
final String? verifiedBy;

  GroupMemberModel({
    required this.customerId,
    required this.name,
    required this.customerCode,
    // required this.nomineeName,
    // required this.nomineeImage,
    required this.installmentAmount,
    required this.isVerified,
    this.verifiedOn,
this.verifiedBy,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    return GroupMemberModel(
      customerId: json['customer_id'] ?? 0,
      name: json['name'] ?? '',
      customerCode: json['customer_code'] ?? '',
      // nomineeName: json['nominee_name'] ?? '',
      // nomineeImage: json['nominee_image'] ?? '',
      installmentAmount: json['installment_amount']?.toString() ?? '',
      // backend omits this key entirely when false, only sends it when true
      isVerified: json['is_verified'] ?? false,
      verifiedOn: json['verified_on'],
verifiedBy: json['verified_by'],
    );
  }
}