class CollectionSubmitRequestModel {
  final double amountCollected;
  final String paymentMethod;
  final String feedback;

  const CollectionSubmitRequestModel({
    required this.amountCollected,
    required this.paymentMethod,
    required this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount_collected': amountCollected,
      'payment_method': paymentMethod,
      'feedback': feedback,
    };
  }
}

class CollectionSubmitResponseModel {
  final String message;
  final double amountCollected;
  final String collectedDate;

  const CollectionSubmitResponseModel({
    required this.message,
    required this.amountCollected,
    required this.collectedDate,
  });

  factory CollectionSubmitResponseModel.fromJson(Map<String, dynamic> json) {
    return CollectionSubmitResponseModel(
      message: json['message'] ?? '',
      amountCollected:
          double.tryParse(json['amount_collected'].toString()) ?? 0,
      collectedDate: json['collected_date'] ?? '',
    );
  }
}