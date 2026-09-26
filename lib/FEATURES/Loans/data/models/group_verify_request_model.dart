class GroupMemberVerifyRequestModel {
  final int customerId;
  final String latitude;
  final String longitude;
  final String fullAddress;
  final String landmark;
  final String state;
  final String district;
  final String? pinCode;
  final String googleMapLink;
  final String maxPayAmount;
  final String? image;
  final List<String>? images;

  GroupMemberVerifyRequestModel({
    required this.customerId,
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
    required this.landmark,
    required this.state,
    required this.district,
    this.pinCode,
    required this.googleMapLink,
    required this.maxPayAmount,
    this.image,
    this.images,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'customer_id': customerId,
      'latitude': latitude,
      'longitude': longitude,
      'full_address': fullAddress,
      'landmark': landmark,
      'state': state,
      'district': district,
      'google_map_link': googleMapLink,
      'maximum_payable_amount': maxPayAmount,
    };
    if (pinCode != null && pinCode!.isNotEmpty) {
      data['pin_code'] = pinCode;
    }
    if (images != null && images!.isNotEmpty) {
      data['images'] = images;
      data['image'] = images!.first;
    } else if (image != null && image!.isNotEmpty) {
      data['image'] = image;
      data['images'] = [image!];
    }
    return data;
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