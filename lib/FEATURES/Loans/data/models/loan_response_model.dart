// import 'package:mr_fincorp/FEATURES/Dashboard/data/models/dashboard_model.dart';
// import 'loan_model.dart';

// class LoanResponseModel {
//   final DashboardModel? dashboard;

//   final List<LoanModel> recentLoans;

//   final int count;
//   final String? next;
//   final String? previous;
//   final List<LoanModel> results;

//   LoanResponseModel({
//     this.dashboard,
//     required this.recentLoans,
//     required this.count,
//     required this.next,
//     required this.previous,
//     required this.results,
//   });

//   factory LoanResponseModel.fromJson(
//     Map<String, dynamic> json,
//   ) {
//     return LoanResponseModel(
//       dashboard:
//           json['dashboard'] != null
//               ? DashboardModel.fromJson(
//                   json['dashboard'],
//                 )
//               : null,

//       recentLoans:
//           (json['recent_loans'] as List?)
//                   ?.map(
//                     (e) =>
//                         LoanModel.fromJson(e),
//                   )
//                   .toList() ??
//               [],

//       count: json['count'] ?? 0,

//       next: json['next'],

//       previous: json['previous'],

//       results:
//           (json['results'] as List?)
//                   ?.map(
//                     (e) =>
//                         LoanModel.fromJson(e),
//                   )
//                   .toList() ??
//               [],
//     );
//   }
// }

import 'package:mr_fincorp/FEATURES/Dashboard/data/models/dashboard_model.dart';
import 'loan_model.dart';

class LoanResponseModel {
  final DashboardModel? dashboard;

  final List<LoanModel> recentLoans;

  final int count;
  final String? next;
  final String? previous;
  final List<LoanModel> results;

  LoanResponseModel({
    this.dashboard,
    required this.recentLoans,
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory LoanResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoanResponseModel(
      dashboard:
          json['dashboard'] != null
              ? DashboardModel.fromJson(
                  json['dashboard'],
                )
              : null,

      recentLoans:
          (json['recent_loans'] as List?)
                  ?.map(
                    (e) => LoanModel.fromJson(e),
                  )
                  .toList() ??
              [],

      count: json['count'] ?? 0,

      next: json['next'],

      previous: json['previous'],

      results:
          (json['results'] as List?)
                  ?.map(
                    (e) => LoanModel.fromJson(e),
                  )
                  .toList() ??
              [],
    );
  }
}