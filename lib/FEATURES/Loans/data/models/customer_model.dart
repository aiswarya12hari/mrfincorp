class CustomerModel {
  final String customerId;
  final String name;
  final String phone;
  final String occupation;
  final String fullAddress;
  final String landmark;
  final String district;
  final String state;
  final String pinCode;
  final String googleMapLink;
  final String profileImage;

  CustomerModel({
    required this.customerId,
    required this.name,
    required this.phone,
    required this.occupation,
    required this.fullAddress,
    required this.landmark,
    required this.district,
    required this.state,
    required this.pinCode,
    required this.googleMapLink,
    required this.profileImage,
  });

  factory CustomerModel.fromJson(
      Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json['customer_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      occupation: json['occupation'] ?? '',
      fullAddress: json['full_address'] ?? '',
      landmark: json['landmark'] ?? '',
      district: json['district'] ?? '',
      state: json['state'] ?? '',
      pinCode: json['pin_code'] ?? '',
      googleMapLink:
          json['google_map_link'] ?? '',
      profileImage:
          json['profile_image'] ?? '',
    );
  }
}