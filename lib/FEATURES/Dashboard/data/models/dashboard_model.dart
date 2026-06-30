class DashboardModel {
  final int totalLoans;
  final int verificationPending;
  final int verifiedLoans;
  final int todayActivity;

  DashboardModel({
    required this.totalLoans,
    required this.verificationPending,
    required this.verifiedLoans,
    required this.todayActivity,
  });

  factory DashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DashboardModel(
      totalLoans: json['total_loans'] ?? 0,
      verificationPending:
          json['verification_pending'] ?? 0,
      verifiedLoans:
          json['verified_loans'] ?? 0,
      todayActivity:
          json['today_activity'] ?? 0,
    );
  }
}