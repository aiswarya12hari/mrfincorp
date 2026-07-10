import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mr_fincorp/FEATURES/Account/provider/account_switch_provider.dart';
import 'package:mr_fincorp/FEATURES/Collections/provider/collected_list_provider.dart';
import 'package:mr_fincorp/FEATURES/Collections/provider/collection_list_provider.dart';
import 'package:mr_fincorp/FEATURES/Collections/provider/collection_submit_provider.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/provider/dashboard_provider.dart';
import 'package:mr_fincorp/FEATURES/Loans/provider/group_loan_verification_provider.dart';
import 'package:mr_fincorp/FEATURES/Loans/provider/individual_loan_verification.dart';
import 'package:mr_fincorp/FEATURES/Loans/provider/loan_detail_provider.dart';
import 'package:mr_fincorp/FEATURES/Profile/provider/logout_provider.dart';
import 'package:mr_fincorp/FEATURES/Profile/provider/profile_provider.dart';
// import 'package:mr_fincorp/FEATURES/Dashboard/presentation/pages/dashboard_page.dart';
import 'package:provider/provider.dart';
import 'CORE/Theme/app_theme.dart';
import 'FEATURES/Login/provider/login_provider.dart';
import 'FEATURES/Splash/presentation/pages/splash_page.dart';
import 'CORE/Storage/shared_preference.dart';
// import 'package:mr_fincorp/FEATURES/Navigation/presentation/pages/bottom_nav_page.dart';
import 'package:mr_fincorp/FEATURES/Loans/provider/loan_provider.dart';


final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await AppPreferences.init();

  // await AppPreferences.clearAll();
  runApp(const FincorpApp());
}

class FincorpApp extends StatelessWidget {
  const FincorpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => LogoutProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => LoanDetailProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => IndividualLoanVerificationProvider(),),
        ChangeNotifierProvider(create: (_) => GroupLoanVerificationProvider()),
        ChangeNotifierProvider(create: (_) => CollectionListProvider()),
        ChangeNotifierProvider(create: (_) => CollectionSubmitProvider()),
        ChangeNotifierProvider(create: (_) => CollectedListProvider()),
        ChangeNotifierProvider(create: (_) => AccountSwitcherProvider()),
      ],
      child: MaterialApp(
      navigatorKey: navigatorKey,
        title: 'FinCorp',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashPage(),
        // home: const BottomNavPage(),
      ),
    );
  }
}
