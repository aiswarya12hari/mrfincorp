import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_detail_model.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/widgets collection detail page/header_card.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/widgets collection detail page/submit_collection_button.dart';
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

  final sampleJson = {
    "id": 101,
    "loan_id": "IND01-LAT-00099",
    "customer_name": "Aarav Sharma",
    "customer_phone": "9876543210",
    "customer_address": "Flat 4B, Emerald Heights, MG Road, Ernakulam",
    "customer_location": "https://maps.google.com/?q=9.9816,76.2999",
    "area": "Kakkanad",
    "branch_name": "Kochi Main",
    "loan_type": "WEEKLY",
    "loan_status": "OPEN",
    "loan_amount": "75000.00",
    "due_pending": 4,
    "principal_pending": "8000.00",
    "fine_pending": "350.00",
    "principal_paid": "67000.00",
    "fine_paid": "150.00",
    "balance_pending": "8350.00",
    "due_date": "2026-10-01",
    "installment_amount": "1500.00"
  };

  group('Customer Details Premium Fintech Redesign Tests', () {
    testWidgets('1. Hero Customer Card renders avatar, name, badges and status chip',
        (WidgetTester tester) async {
      final model = CollectionDetailModel.fromJson(sampleJson);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CollectionDetailHeaderCard(data: model),
            ),
          ),
        ),
      );

      // Customer name and avatar initials 'AS'
      expect(find.text('Aarav Sharma'), findsOneWidget);
      expect(find.text('AS'), findsOneWidget);

      // Badges below customer name
      expect(
        find.byWidgetPredicate((w) =>
            w is RichText && w.text.toPlainText().contains('ID: 101')),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is RichText &&
            w.text.toPlainText().contains('Loan ID: IND01-LAT-00099')),
        findsOneWidget,
      );

      // Status chip (Open / Active)
      expect(find.text('ACTIVE'), findsOneWidget);
    });

    testWidgets('Status chip renders EXPIRED when loan status is expired',
        (WidgetTester tester) async {
      final expiredJson = Map<String, dynamic>.from(sampleJson);
      expiredJson['loan_status'] = 'EXPIRED';
      final model = CollectionDetailModel.fromJson(expiredJson);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CollectionDetailHeaderCard(data: model),
            ),
          ),
        ),
      );

      final chipFinder = find.byKey(const Key('status_chip'));
      expect(chipFinder, findsOneWidget);
      expect(
        find.descendant(of: chipFinder, matching: find.text('EXPIRED')),
        findsOneWidget,
      );
    });

    testWidgets('Status chip renders DAILY when loan type is daily',
        (WidgetTester tester) async {
      final dailyJson = Map<String, dynamic>.from(sampleJson);
      dailyJson['loan_type'] = 'DAILY';
      final model = CollectionDetailModel.fromJson(dailyJson);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CollectionDetailHeaderCard(data: model),
            ),
          ),
        ),
      );

      final chipFinder = find.byKey(const Key('status_chip'));
      expect(chipFinder, findsOneWidget);
      expect(
        find.descendant(of: chipFinder, matching: find.text('DAILY')),
        findsOneWidget,
      );
    });

    testWidgets('2. Quick Action Row renders equal Call and WhatsApp action buttons',
        (WidgetTester tester) async {
      final model = CollectionDetailModel.fromJson(sampleJson);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CollectionDetailHeaderCard(data: model),
            ),
          ),
        ),
      );

      expect(find.text('Call'), findsOneWidget);
      expect(find.byKey(const Key('whatsapp_button')), findsOneWidget);

      // Tap Call button launches tel URL
      await tester.tap(find.text('Call'));
      await tester.pumpAndSettle();
      expect(mockUrlLauncher.launchedUrl, 'tel:9876543210');

      // Tap WhatsApp button launches WhatsApp deep link
      await tester.tap(find.byKey(const Key('whatsapp_button')));
      await tester.pumpAndSettle();
      expect(mockUrlLauncher.launchedUrl, contains('https://wa.me/919876543210'));
    });

    testWidgets('3. Contact Information Cards render Phone, Address and Google Maps cards',
        (WidgetTester tester) async {
      final model = CollectionDetailModel.fromJson(sampleJson);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CollectionDetailHeaderCard(data: model),
            ),
          ),
        ),
      );

      // Phone Row with single Call button and no duplicate Tap to Call
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('9876543210'), findsOneWidget);
      expect(find.text('Tap to Call'), findsNothing);
      expect(find.text('Call'), findsOneWidget);

      // Address Card
      expect(find.text('Customer Address'), findsOneWidget);
      expect(
        find.text('Flat 4B, Emerald Heights, MG Road, Ernakulam'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);

      // Google Maps Card
      expect(find.text('Customer Location'), findsOneWidget);
      expect(find.text('Tap to Open Google Maps'), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new_rounded), findsOneWidget);

      // Tap Google Maps card opens URL
      await tester.tap(find.text('Tap to Open Google Maps'));
      await tester.pumpAndSettle();
      expect(
        mockUrlLauncher.launchedUrl,
        'https://maps.google.com/?q=9.9816,76.2999',
      );
    });

    testWidgets('4. Information Grid renders 2x2 cards for Area, Branch, Loan Type, and Loan Status',
        (WidgetTester tester) async {
      final model = CollectionDetailModel.fromJson(sampleJson);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CollectionDetailHeaderCard(data: model),
            ),
          ),
        ),
      );

      expect(find.text('AREA'), findsOneWidget);
      expect(find.text('KAKKANAD'), findsOneWidget);

      expect(find.text('BRANCH'), findsOneWidget);
      expect(find.text('Kochi Main'), findsOneWidget);

      expect(find.text('LOAN TYPE'), findsOneWidget);
      expect(find.text('WEEKLY'), findsOneWidget);

      expect(find.text('LOAN STATUS'), findsOneWidget);
      expect(find.text('OPEN'), findsOneWidget);
    });

    testWidgets('5. Financial Summary renders Loan Amount and Collection Date prominently',
        (WidgetTester tester) async {
      final model = CollectionDetailModel.fromJson(sampleJson);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CollectionDetailHeaderCard(data: model),
            ),
          ),
        ),
      );

      expect(find.text('LOAN AMOUNT'), findsOneWidget);
      expect(find.text('₹75,000'), findsOneWidget);

      expect(find.text('COLLECTION DATE'), findsOneWidget);
      expect(find.text('1 Oct 2026'), findsOneWidget);

      expect(find.text('PRINCIPAL BALANCE'), findsOneWidget);
      expect(find.text('₹8,000'), findsOneWidget);

      expect(find.text('FINE BALANCE'), findsOneWidget);
      expect(find.text('₹350'), findsOneWidget);

      expect(find.text('PRINCIPAL PAID'), findsOneWidget);
      expect(find.text('₹67,000'), findsOneWidget);

      expect(find.text('FINE PAID'), findsOneWidget);
      expect(find.text('₹150'), findsOneWidget);

      expect(find.text('DUE PENDING'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('7. SubmitCollectionButton renders 58px floating pill button and triggers onPressed',
        (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SubmitCollectionButton(
                onPressed: () => pressed = true,
                isLoading: false,
              ),
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(SubmitCollectionButton);
      expect(buttonFinder, findsOneWidget);

      // Verify 58px height
      final buttonSize = tester.getSize(buttonFinder);
      expect(buttonSize.height, 58.0);

      // Check icon and text
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(find.text('Submit Collection'), findsOneWidget);

      // Tap triggers callback
      await tester.tap(find.text('Submit Collection'));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('SubmitCollectionButton shows loading indicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SubmitCollectionButton(
                onPressed: null,
                isLoading: true,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit Collection'), findsNothing);
    });
  });
}
