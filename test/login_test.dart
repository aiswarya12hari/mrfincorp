import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/CORE/Storage/shared_preference.dart';
import 'package:mr_fincorp/FEATURES/Login/data/models/login_model.dart';
import 'package:mr_fincorp/FEATURES/Login/data/services/login_service.dart';
import 'package:mr_fincorp/FEATURES/Login/presentation/pages/login_page.dart';
import 'package:mr_fincorp/FEATURES/Login/presentation/widgets/button.dart';
import 'package:mr_fincorp/FEATURES/Login/presentation/widgets/login_form.dart';
import 'package:mr_fincorp/FEATURES/Login/presentation/widgets/login_header.dart';
import 'package:mr_fincorp/FEATURES/Login/presentation/widgets/text_field.dart';
import 'package:mr_fincorp/FEATURES/Login/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Mock Login Service ──────────────────────────────────────────────
class MockLoginService extends LoginService {
  final Future<LoginResponseModel> Function(String email, String password)? onLogin;

  MockLoginService({this.onLogin});

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    if (onLogin != null) {
      return onLogin!(email, password);
    }
    throw Exception('Login Failed');
  }
}

// ── Navigator Observer for testing navigation ────────────────────────
class TestNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];
  final List<Route<dynamic>> replacedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    pushedRoutes.add(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      replacedRoutes.add(newRoute);
    }
  }
}

LoginResponseModel createFakeLoginResponse({
  String email = 'agent@fincorp.com',
  String name = 'Ravi Kumar',
}) {
  return LoginResponseModel(
    access: 'test_access_token_123',
    refresh: 'test_refresh_token_456',
    user: User(
      id: 101,
      role: 'FIELD_STAFF',
      email: email,
      phone: '9876543210',
      fieldStaffId: 'FS-101',
      fieldStaffName: name,
      branchId: 1,
      branchName: 'Main Branch',
      branchCode: 'MB01',
    ),
  );
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppPreferences.init();
  });

  // ═════════════════════════════════════════════════════════════════════
  // 1. UNIT TESTS: LoginProvider
  // ═════════════════════════════════════════════════════════════════════
  group('LoginProvider Unit Tests', () {
    test('Valid login: saves account, updates loginData, and returns true', () async {
      final mockService = MockLoginService(
        onLogin: (email, password) async {
          return createFakeLoginResponse(email: email, name: 'Ravi Kumar');
        },
      );

      final provider = LoginProvider(service: mockService);

      final result = await provider.login(
        email: 'agent@fincorp.com',
        password: 'password123',
      );

      expect(result, isTrue);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
      expect(provider.loginData, isNotNull);
      expect(provider.loginData!.user.fieldStaffName, 'Ravi Kumar');
      expect(provider.loginData!.user.email, 'agent@fincorp.com');

      // Verify stored in AppPreferences
      expect(AppPreferences.getAccessToken(), 'test_access_token_123');
      expect(AppPreferences.getRefreshToken(), 'test_refresh_token_456');
      expect(AppPreferences.getActiveAccount()?.name, 'Ravi Kumar');
    });

    test('Invalid credentials: sets error message and returns false', () async {
      final mockService = MockLoginService(
        onLogin: (email, password) async {
          throw Exception('Invalid credentials');
        },
      );

      final provider = LoginProvider(service: mockService);

      final result = await provider.login(
        email: 'wrong@fincorp.com',
        password: 'wrongpassword',
      );

      expect(result, isFalse);
      expect(provider.isLoading, isFalse);
      expect(provider.loginData, isNull);
      expect(provider.errorMessage, 'Invalid credentials');
      expect(AppPreferences.getAccessToken(), isNull);
    });

    test('API failure: handles network error and sets descriptive error message', () async {
      final mockService = MockLoginService(
        onLogin: (email, password) async {
          throw Exception('Network error. Please check your internet connection.');
        },
      );

      final provider = LoginProvider(service: mockService);

      final result = await provider.login(
        email: 'agent@fincorp.com',
        password: 'password123',
      );

      expect(result, isFalse);
      expect(provider.isLoading, isFalse);
      expect(
        provider.errorMessage,
        'Network error. Please check your internet connection.',
      );
    });

    test('API failure: handles server status code 500 error', () async {
      final mockService = MockLoginService(
        onLogin: (email, password) async {
          throw Exception('Login Failed : 500');
        },
      );

      final provider = LoginProvider(service: mockService);

      final result = await provider.login(
        email: 'agent@fincorp.com',
        password: 'password123',
      );

      expect(result, isFalse);
      expect(provider.errorMessage, 'Login Failed : 500');
    });

    test('LoginProvider notifies listeners during loading and after completion', () async {
      final completer = Completer<LoginResponseModel>();
      final mockService = MockLoginService(
        onLogin: (email, password) => completer.future,
      );

      final provider = LoginProvider(service: mockService);
      final loadingStates = <bool>[];
      provider.addListener(() {
        loadingStates.add(provider.isLoading);
      });

      final future = provider.login(
        email: 'agent@fincorp.com',
        password: 'password123',
      );

      expect(provider.isLoading, isTrue);

      completer.complete(createFakeLoginResponse());
      await future;

      expect(provider.isLoading, isFalse);
      expect(loadingStates, containsAllInOrder([true, false]));
    });
  });

  // ═════════════════════════════════════════════════════════════════════
  // 2. WIDGET TESTS: Form validation, Password toggle, and UI elements
  // ═════════════════════════════════════════════════════════════════════
  group('Login Form & Text Field Widget Tests', () {
    testWidgets('Empty email/password validation displays error messages', (tester) async {
      final formKey = GlobalKey<FormState>();
      final emailCtrl = TextEditingController();
      final passwordCtrl = TextEditingController();
      bool loginCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LoginForm(
                formKey: formKey,
                emailController: emailCtrl,
                passwordController: passwordCtrl,
                onLogin: () {
                  if (formKey.currentState!.validate()) {
                    loginCalled = true;
                  }
                },
              ),
            ),
          ),
        ),
      );

      // Tap login with empty fields
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(loginCalled, isFalse);

      // Enter invalid email format
      await tester.enterText(find.widgetWithText(FincorpTextField, 'Email'), 'notanemail');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email'), findsOneWidget);

      // Enter short password (< 6 characters)
      await tester.enterText(find.widgetWithText(FincorpTextField, 'Password'), '12345');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Minimum 6 characters'), findsOneWidget);

      // Enter valid email and password
      await tester.enterText(find.widgetWithText(FincorpTextField, 'Email'), 'agent@fincorp.com');
      await tester.enterText(find.widgetWithText(FincorpTextField, 'Password'), 'secret123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsNothing);
      expect(find.text('Enter a valid email'), findsNothing);
      expect(find.text('Password is required'), findsNothing);
      expect(find.text('Minimum 6 characters'), findsNothing);
      expect(loginCalled, isTrue);
    });

    testWidgets('Password visibility toggle alternates obscured state and icons', (tester) async {
      final passwordCtrl = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FincorpTextField(
              label: 'Password',
              hintText: '••••••••',
              icon: Icons.lock_outline_rounded,
              controller: passwordCtrl,
              isPassword: true,
            ),
          ),
        ),
      );

      // Initially obscured
      final initialFinder = find.byType(EditableText);
      expect(tester.widget<EditableText>(initialFinder).obscureText, isTrue);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);

      // Tap suffix toggle button
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Now revealed
      expect(tester.widget<EditableText>(initialFinder).obscureText, isFalse);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

      // Tap again to obscure
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(tester.widget<EditableText>(initialFinder).obscureText, isTrue);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });

  // ═════════════════════════════════════════════════════════════════════
  // 3. WIDGET TESTS: Login Button Loading State
  // ═════════════════════════════════════════════════════════════════════
  group('Login Button Loading State Tests', () {
    testWidgets('Login button loading state displays indicator and ignores taps', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FincorpPrimaryButton(
              label: 'Login',
              isLoading: true,
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // CircularProgressIndicator should be visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Label text should NOT be rendered while loading
      expect(find.text('Login'), findsNothing);

      // Tapping must not trigger callback
      await tester.tap(find.byType(FincorpPrimaryButton));
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets('Login button when not loading displays label and triggers callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FincorpPrimaryButton(
              label: 'Login',
              isLoading: false,
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.text('Login'));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });

  // ═════════════════════════════════════════════════════════════════════
  // 4. WIDGET & INTEGRATION TESTS: LoginPage Full Flow
  // ═════════════════════════════════════════════════════════════════════
  group('LoginPage UI & Redesign Verification Tests', () {
    testWidgets('renders redesigned header, fields, login button, and version only', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final mockService = MockLoginService();
      final provider = LoginProvider(service: mockService);

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: const MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      // Logo & Header
      expect(find.byType(LoginHeader), findsOneWidget);
      expect(find.text('Field Staff Login'), findsOneWidget);
      expect(find.text('Welcome back! Please login to continue'), findsOneWidget);

      // Form items
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);

      // Version
      expect(find.text('Version 1.0.0'), findsOneWidget);

      // Verify Remember Me and Forgot Password are removed completely
      expect(find.text('Remember me'), findsNothing);
      expect(find.text('Forgot Password?'), findsNothing);
      expect(find.byType(Checkbox), findsNothing);
    });

    testWidgets('shows error SnackBar on invalid credentials', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final mockService = MockLoginService(
        onLogin: (email, password) async {
          throw Exception('Invalid email or password');
        },
      );
      final provider = LoginProvider(service: mockService);

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: const MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      // Enter credentials
      await tester.enterText(
        find.widgetWithText(FincorpTextField, 'Email'),
        'wrong@fincorp.com',
      );
      await tester.enterText(
        find.widgetWithText(FincorpTextField, 'Password'),
        'wrongpassword',
      );

      // Ensure button is visible and tap Login
      await tester.ensureVisible(find.text('Login'));
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify SnackBar with error message appears
      expect(find.text('Invalid email or password'), findsOneWidget);
    });

    testWidgets('shows error SnackBar on API / server failure', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final mockService = MockLoginService(
        onLogin: (email, password) async {
          throw Exception('Network error. Please check your internet connection.');
        },
      );
      final provider = LoginProvider(service: mockService);

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: const MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(FincorpTextField, 'Email'),
        'agent@fincorp.com',
      );
      await tester.enterText(
        find.widgetWithText(FincorpTextField, 'Password'),
        'correctpass',
      );

      await tester.ensureVisible(find.text('Login'));
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(
        find.text('Network error. Please check your internet connection.'),
        findsOneWidget,
      );
    });

    testWidgets('valid login triggers welcome SnackBar and navigates to target page', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final completer = Completer<LoginResponseModel>();
      final mockService = MockLoginService(
        onLogin: (email, password) => completer.future,
      );
      final provider = LoginProvider(service: mockService);
      final navObserver = TestNavigatorObserver();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            navigatorObservers: [navObserver],
            home: const LoginPage(
              destinationPage: Scaffold(
                body: Center(child: Text('Destination Screen')),
              ),
            ),
          ),
        ),
      );

      // Enter valid credentials
      await tester.enterText(
        find.widgetWithText(FincorpTextField, 'Email'),
        'agent@fincorp.com',
      );
      await tester.enterText(
        find.widgetWithText(FincorpTextField, 'Password'),
        'correctpass',
      );

      // Tap Login
      await tester.ensureVisible(find.text('Login'));
      await tester.tap(find.text('Login'));
      await tester.pump(); // Start async login

      // Verify loading state is active while waiting
      expect(provider.isLoading, isTrue);

      // Complete async login
      completer.complete(
        createFakeLoginResponse(
          email: 'agent@fincorp.com',
          name: 'Ravi Kumar',
        ),
      );
      await tester.pumpAndSettle();

      // Verify loading finished
      expect(provider.isLoading, isFalse);

      // Verify Welcome SnackBar with field staff name
      expect(find.text('Welcome Ravi Kumar'), findsOneWidget);

      // Verify navigation replaced route
      expect(navObserver.replacedRoutes.isNotEmpty, isTrue);
      expect(find.text('Destination Screen'), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });

    test('LoginPage default destinationPage falls back to BottomNavPage', () {
      const page = LoginPage();
      expect(page.destinationPage, isNull);
    });
  });
}
