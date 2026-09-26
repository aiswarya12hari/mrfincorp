class CollectionDetailModel {
  final int id;
  final String loanId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerLocation;
  final String area;
  final String branchName;
  final String loanType;
  final String loanStatus;
  final double loanAmount;
  final int duePending;
  final double principalPending;
  final double finePending;
  final double principalPaid;
  final double finePaid;
  final double balancePending;
  final String dueDate;
  final double installmentAmount;
  final List<String> customerImages;

  const CollectionDetailModel({
    required this.id,
    required this.loanId,
    required this.customerName,
    required this.customerPhone,
    this.customerAddress = '',
    this.customerLocation = '',
    required this.area,
    required this.branchName,
    required this.loanType,
    required this.loanStatus,
    required this.loanAmount,
    required this.duePending,
    required this.principalPending,
    required this.finePending,
    this.principalPaid = 0.0,
    this.finePaid = 0.0,
    required this.balancePending,
    required this.dueDate,
    this.installmentAmount = 0.0,
    this.customerImages = const [],
  });

  // Backward compatibility getters
  int get dueCount => duePending;
  double get principalPendingLive => principalPending;

  factory CollectionDetailModel.fromJson(Map<String, dynamic> json) {
    return CollectionDetailModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      loanId: json['loan_id']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      customerPhone: json['customer_phone']?.toString() ?? '',
      customerAddress: json['customer_address']?.toString() ?? '',
      customerLocation: json['customer_location']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      branchName: json['branch_name']?.toString() ?? '',
      loanType: json['loan_type']?.toString() ?? '',
      loanStatus: json['loan_status']?.toString() ?? '',
      loanAmount:
          double.tryParse(json['loan_amount']?.toString() ?? '') ?? 0.0,
      duePending: int.tryParse(
            (json['due_pending'] ?? json['due_count'] ?? 0)
                .toString()
                .split('.')
                .first,
          ) ??
          0,
      principalPending: double.tryParse(
            (json['principal_pending'] ?? json['principal_pending_live'])
                    ?.toString() ??
                '',
          ) ??
          0.0,
      finePending:
          double.tryParse(json['fine_pending']?.toString() ?? '') ?? 0.0,
      principalPaid:
          double.tryParse(json['principal_paid']?.toString() ?? '') ?? 0.0,
      finePaid: double.tryParse(json['fine_paid']?.toString() ?? '') ?? 0.0,
      balancePending:
          double.tryParse(json['balance_pending']?.toString() ?? '') ?? 0.0,
      dueDate: json['due_date']?.toString() ?? '',
      installmentAmount:
          double.tryParse(json['installment_amount']?.toString() ?? '') ?? 0.0,
      customerImages: () {
        final dynamic list = json['customer_images'] ?? json['customerImages'];
        if (list is List) {
          return list
              .map((e) => e?.toString() ?? '')
              .where((url) => url.isNotEmpty)
              .toList();
        } else if (list is String && list.isNotEmpty) {
          return [list];
        }
        return const <String>[];
      }(),
    );
  }

  String get formattedDueDate {
    if (dueDate.isEmpty) return '-';
    try {
      final date = DateTime.parse(dueDate);
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
      return dueDate;
    }
  }
}