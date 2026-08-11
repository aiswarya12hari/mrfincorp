class IndividualLoanVerificationModel {
  final String feedback;
  final String latitude;
  final String longitude;
  final String fullAddress;
  final String landmark;
  final String state;
  final String district;
  // final String pinCode;
  final String googleMapLink;
  final String maxPayAmount; 

  IndividualLoanVerificationModel({
    required this.feedback,
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
    required this.landmark,
    required this.state,
    required this.district,
    // required this.pinCode,
    required this.googleMapLink,
    required this.maxPayAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      "feedback": feedback,
      "latitude": latitude,
      "longitude": longitude,
      "full_address": fullAddress,
      "landmark": landmark,
      "state": state,
      "district": district,
      // "pin_code": pinCode,
      "google_map_link": googleMapLink,
      "maximum_payable_amount": maxPayAmount,
    };
  }
}