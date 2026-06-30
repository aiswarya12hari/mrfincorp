import 'env.dart';

class ApiConfig {
  static String get login => '${Env.baseUrl}/api/fieldstaff/login/';

  static String get profile => '${Env.baseUrl}/api/fieldstaff/profile/';

  static String get logout => '${Env.baseUrl}/api/fieldstaff/logout/';

  static String get loans => '${Env.baseUrl}/api/fieldstaff/loans/';

  static String loanDetail(String loanId) =>
      '${Env.baseUrl}/api/fieldstaff/loans/$loanId/';

  static String verifyIndividualLoan(String loanId) =>
      '${Env.baseUrl}/api/fieldstaff/loans/$loanId/verify/';

  static String verifyGroupLoan(String loanId) =>
      '${Env.baseUrl}/api/fieldstaff/loans/$loanId/verify/group/';
}
