class CollectedCollectionModel {
  final int id;
  final String loanId;
  final String customerName;
  final String area;
  final String loanType;
  final String loanStatus;
  final double principalPending;
  final double duesPending;
  final String? dueDate;
  final double installmentAmount;
  final bool isCollected;
  final double collectedAmount;
  final String paymentMethod;
  final String feedback;
  final String? collectionDate;
  final String? collectedDate;

  const CollectedCollectionModel({
    required this.id,
    required this.loanId,
    required this.customerName,
    required this.area,
    required this.loanType,
    required this.loanStatus,
    required this.principalPending,
    required this.duesPending,
    required this.dueDate,
    required this.installmentAmount,
    required this.isCollected,
    required this.collectedAmount,
    required this.paymentMethod,
    required this.feedback,
    required this.collectionDate,
    required this.collectedDate,
  });

  factory CollectedCollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectedCollectionModel(
      id: json['id'] ?? 0,
      loanId: json['loan_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      area: json['area'] ?? '',
      loanType: json['loan_type'] ?? '',
      loanStatus: json['loan_status'] ?? '',
      principalPending: double.tryParse(json['principal_pending'].toString()) ?? 0,
      duesPending: double.tryParse(json['dues_pending'].toString()) ?? 0,
      dueDate: json['due_date'],
      installmentAmount: double.tryParse(json['installment_amount'].toString()) ?? 0,
      isCollected: json['is_collected'] ?? false,
      collectedAmount: double.tryParse(json['collected_amount'].toString()) ?? 0,
      paymentMethod: json['payment_method'] ?? '',
      feedback: json['feedback'] ?? '',
      collectionDate: json['collection_date'],
      collectedDate: json['collected_date'],
    );
  }

  // ── UI-friendly getters ──

  String get frequencyLabel => loanType;

  String get formattedCollectedDate {
    final source = collectedDate;
    if (source == null || source.isEmpty) return '-';
    try {
      final date = DateTime.parse(source);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return '-';
    }
  }
}

class CollectedListResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<CollectedCollectionModel> results;

  const CollectedListResponseModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory CollectedListResponseModel.fromJson(Map<String, dynamic> json) {
    return CollectedListResponseModel(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => CollectedCollectionModel.fromJson(e))
          .toList(),
    );
  }
}