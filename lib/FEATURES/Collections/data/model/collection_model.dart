enum CollectionStatus { outstanding, collected }

class CollectionModel {
  final int slNo;
  final int assignmentId;
  final String loanId;
  final String loanMethod;
  final String customerName;
  final String loanType;
  final String branchName;
  final double principalPending;
  final double duesPending;
  final bool isCollected;
  final double collectedAmount;
  final String? collectionDate;
  final String paymentMethod;
  final String feedback;
  final String createdAt;

  const CollectionModel({
    required this.slNo,
    required this.assignmentId,
    required this.loanId,
    required this.loanMethod,
    required this.customerName,
    required this.loanType,
    required this.branchName,
    required this.principalPending,
    required this.duesPending,
    required this.isCollected,
    required this.collectedAmount,
    required this.collectionDate,
    required this.paymentMethod,
    required this.feedback,
    required this.createdAt,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      slNo: json['sl_no'] ?? 0,
      assignmentId: json['assignment_id'] ?? 0,
      loanId: json['loan_id'] ?? '',
      loanMethod: json['loan_method'] ?? '',
      customerName: json['customer_name'] ?? '',
      loanType: json['loan_type'] ?? '',
      branchName: json['branch_name'] ?? '',
      principalPending:
          double.tryParse(json['principal_pending'].toString()) ?? 0,
      duesPending: double.tryParse(json['dues_pending'].toString()) ?? 0,
      isCollected: json['is_collected'] ?? false,
      collectedAmount:
          double.tryParse(json['collected_amount'].toString()) ?? 0,
      collectionDate: json['collection_date'],
      paymentMethod: json['payment_method'] ?? '',
      feedback: json['feedback'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  // ── UI-friendly getters (keeps existing widgets working) ──

  CollectionStatus get status =>
      isCollected ? CollectionStatus.collected : CollectionStatus.outstanding;

  String get frequencyLabel => loanType; // e.g. WEEKLY / DAILY / MONTHLY

  String get area => branchName;

  double get principal => principalPending;

  double get due => duesPending;

  double get outstanding => duesPending;

  String get dueDate {
    final source = collectionDate ?? createdAt;
    if (source.isEmpty) return '-';
    try {
      final date = DateTime.parse(source);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return '-';
    }
  }

  // API doesn't currently return an overdue flag; defaulting to false.
  bool get isOverdue => false;

  // API doesn't send a separate short display ID — using assignment_id.
  String get id => assignmentId.toString();

  // API doesn't currently return a fixed installment amount.
  double? get installment => null;
}

class CollectionListResponseModel {
  final int count;
  final List<CollectionModel> results;

  const CollectionListResponseModel({
    required this.count,
    required this.results,
  });

  factory CollectionListResponseModel.fromJson(Map<String, dynamic> json) {
    return CollectionListResponseModel(
      count: json['count'] ?? 0,
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => CollectionModel.fromJson(e))
          .toList(),
    );
  }
}
