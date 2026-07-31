class GroupMemberVerifyRequestModel {
  final int customerId;
  final String latitude;
  final String longitude;
  final String fullAddress;
  final String landmark;
  final String state;
  final String district;
  final String pinCode;
  final String googleMapLink;
  // final String maxPayAmount;

  GroupMemberVerifyRequestModel({
    required this.customerId,
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
    required this.landmark,
    required this.state,
    required this.district,
    required this.pinCode,
    required this.googleMapLink,
    // required this.maxPayAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'latitude': latitude,
      'longitude': longitude,
      'full_address': fullAddress,
      'landmark': landmark,
      'state': state,
      'district': district,
      'pin_code': pinCode,
      'google_map_link': googleMapLink,
      // 'max_pay_amount': maxPayAmount,
    };
  }
}

class GroupVerifyRequestModel {
  final String feedback;
  final List<GroupMemberVerifyRequestModel> members;

  GroupVerifyRequestModel({
    required this.feedback,
    required this.members,
  });

  Map<String, dynamic> toJson() {
    return {
      'feedback': feedback,
      'members': members.map((m) => m.toJson()).toList(),
    };
  }
}