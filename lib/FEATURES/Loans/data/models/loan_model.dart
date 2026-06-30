class LoanModel {
  final int id;
  final String loanId;
  final String customerName;
  final String loanAmount;
  final String loanType;
  final String dateOfApplication;
  final String status;
  final String loanMethod;

  LoanModel({
    required this.id,
    required this.loanId,
    required this.customerName,
    required this.loanAmount,
    required this.loanType,
    required this.dateOfApplication,
    required this.status,
    required this.loanMethod,
  });

  factory LoanModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoanModel(
      id: json['id'] ?? 0,
      loanId: json['loan_id'] ?? '',

      customerName:
          json['customer_name'] ??
          json['group_name'] ??
          'N/A',

      loanAmount:
          json['loan_amount'].toString(),

      loanType:
          json['loan_type'] ?? '',

      dateOfApplication:
          json['date_of_application'] ?? '',

      status:
          json['status'] ?? '',

      loanMethod:
          json['loan_method'] ?? '',
    );
  }
}