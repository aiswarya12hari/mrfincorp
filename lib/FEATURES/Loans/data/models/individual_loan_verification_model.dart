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
  final String? image;
  final List<String>? images;

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
    this.image,
    this.images,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
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
    if (images != null && images!.isNotEmpty) {
      data["images"] = images;
      data["image"] = images!.first;
    } else if (image != null && image!.isNotEmpty) {
      data["image"] = image;
      data["images"] = [image!];
    }
    return data;
  }
}