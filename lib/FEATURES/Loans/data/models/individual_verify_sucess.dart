class IndividualVerifyResponseModel {
  final String message;
  final String loanId;
  final String status;
  final String feedback;
  final String verifiedBy;
  final bool customerLocationUpdated;

  IndividualVerifyResponseModel({
    required this.message,
    required this.loanId,
    required this.status,
    required this.feedback,
    required this.verifiedBy,
    required this.customerLocationUpdated,
  });

  factory IndividualVerifyResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return IndividualVerifyResponseModel(
      message: json['message'] ?? '',
      loanId: json['loan_id'] ?? '',
      status: json['status'] ?? '',
      feedback: json['feedback'] ?? '',
      verifiedBy: json['verified_by'] ?? '',
      customerLocationUpdated:
          json['customer_location_updated'] ?? false,
    );
  }
}