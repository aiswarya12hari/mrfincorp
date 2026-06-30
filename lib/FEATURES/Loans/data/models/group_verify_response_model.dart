class UnverifiedMemberModel {
  final int customerId;
  final String name;

  UnverifiedMemberModel({
    required this.customerId,
    required this.name,
  });

  factory UnverifiedMemberModel.fromJson(Map<String, dynamic> json) {
    return UnverifiedMemberModel(
      customerId: json['customer_id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class UpdatedCustomerModel {
  final String customerId;
  final String name;
  final String fullAddress;
  final String landmark;
  final String state;
  final String district;
  final String pinCode;
  final String googleMapLink;
  final String latitude;
  final String longitude;

  UpdatedCustomerModel({
    required this.customerId,
    required this.name,
    required this.fullAddress,
    required this.landmark,
    required this.state,
    required this.district,
    required this.pinCode,
    required this.googleMapLink,
    required this.latitude,
    required this.longitude,
  });

  factory UpdatedCustomerModel.fromJson(Map<String, dynamic> json) {
    return UpdatedCustomerModel(
      customerId: json['customer_id'] ?? '',
      name: json['name'] ?? '',
      fullAddress: json['full_address'] ?? '',
      landmark: json['landmark'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      pinCode: json['pin_code'] ?? '',
      googleMapLink: json['google_map_link'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
    );
  }
}

class GroupVerifyResponseModel {
  final String message;
  final String loanId;
  final String status;
  final String feedback;
  final String verifiedBy;
  final int totalMembers;
  final int verifiedCount;
  final int unverifiedCount;
  final List<UnverifiedMemberModel> unverifiedMembers;
  final List<UpdatedCustomerModel> updatedCustomers;

  GroupVerifyResponseModel({
    required this.message,
    required this.loanId,
    required this.status,
    required this.feedback,
    required this.verifiedBy,
    required this.totalMembers,
    required this.verifiedCount,
    required this.unverifiedCount,
    required this.unverifiedMembers,
    required this.updatedCustomers,
  });

  bool get isFullyVerified => unverifiedCount == 0;

  factory GroupVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return GroupVerifyResponseModel(
      message: json['message'] ?? '',
      loanId: json['loan_id'] ?? '',
      status: json['status'] ?? '',
      feedback: json['feedback'] ?? '',
      verifiedBy: json['verified_by'] ?? '',
      totalMembers: json['total_members'] ?? 0,
      verifiedCount: json['verified_count'] ?? 0,
      unverifiedCount: json['unverified_count'] ?? 0,
      unverifiedMembers: json['unverified_members'] != null
          ? (json['unverified_members'] as List)
              .map((m) => UnverifiedMemberModel.fromJson(m))
              .toList()
          : [],
      updatedCustomers: json['updated_customers'] != null
          ? (json['updated_customers'] as List)
              .map((c) => UpdatedCustomerModel.fromJson(c))
              .toList()
          : [],
    );
  }
}