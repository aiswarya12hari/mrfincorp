import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/customer_model.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets detail page/customer_details_card.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncherPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  String? launchedUrl;
  LaunchOptions? launchOptions;
  bool shouldSucceed = true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrl = url;
    launchOptions = options;
    return shouldSucceed;
  }
}

void main() {
  late MockUrlLauncherPlatform mockUrlLauncher;

  setUp(() {
    mockUrlLauncher = MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = mockUrlLauncher;
  });

  final sampleCustomer = CustomerModel(
    customerId: 'CUST-001',
    name: 'Suresh Kumar',
    phone: '9845012345',
    occupation: 'Shopkeeper',
    fullAddress: '12 Temple Street, Aluva',
    landmark: 'Near Temple',
    district: 'Ernakulam',
    state: 'Kerala',
    pinCode: '683101',
    googleMapLink: 'https://maps.google.com/?q=10.1076,76.3516',
    profileImage: '',
  );

  group('CustomerDetailsCard in Loan Detail Page', () {
    testWidgets('renders Call button and tapping it launches tel link', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerDetailsCard(customer: sampleCustomer),
          ),
        ),
      );

      // Verify phone number is displayed
      expect(find.text('9845012345'), findsOneWidget);

      // Verify Call button is displayed
      expect(find.text('Call'), findsOneWidget);
      expect(find.byIcon(Icons.call), findsOneWidget);

      // Tap Call button
      await tester.tap(find.text('Call'));
      await tester.pumpAndSettle();

      expect(mockUrlLauncher.launchedUrl, 'tel:9845012345');
    });

    testWidgets('hides Call button when customer phone is empty', (tester) async {
      final customerNoPhone = CustomerModel(
        customerId: 'CUST-002',
        name: 'Anita Roy',
        phone: '',
        occupation: 'Teacher',
        fullAddress: '45 Lake View, Palakkad',
        landmark: '',
        district: 'Palakkad',
        state: 'Kerala',
        pinCode: '678001',
        googleMapLink: '',
        profileImage: '',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerDetailsCard(customer: customerNoPhone),
          ),
        ),
      );

      expect(find.text('Call'), findsNothing);
      expect(find.byIcon(Icons.call), findsNothing);
    });
  });
}
