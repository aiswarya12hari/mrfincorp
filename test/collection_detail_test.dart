import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_detail_model.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/widgets collection detail page/header_card.dart';

void main() {
  final sampleJson = {
    "id": 1,
    "loan_id": "IND01-LAT-00085",
    "customer_name": "John Doe",
    "customer_phone": "9876543210",
    "customer_address": "123 Main Street, Near City Square, Kerala 682011",
    "customer_location": "https://maps.google.com/?q=9.931233,76.267303",
    "area": "Downtown",
    "branch_name": "Main Branch",
    "loan_type": "WEEKLY",
    "loan_status": "OPEN",
    "loan_amount": "50000.00",
    "due_pending": 2,
    "principal_pending": "5000.00",
    "fine_pending": "150.00",
    "principal_paid": "45000.00",
    "fine_paid": "50.00",
    "balance_pending": "5150.00",
    "due_date": "2026-09-15",
    "installment_amount": "1000.00"
  };

  group('CollectionDetailModel tests', () {
    test('fromJson parses all fields properly from new API response', () {
      final model = CollectionDetailModel.fromJson(sampleJson);

      expect(model.id, 1);
      expect(model.loanId, "IND01-LAT-00085");
      expect(model.customerName, "John Doe");
      expect(model.customerPhone, "9876543210");
      expect(model.customerAddress,
          "123 Main Street, Near City Square, Kerala 682011");
      expect(model.customerLocation,
          "https://maps.google.com/?q=9.931233,76.267303");
      expect(model.area, "Downtown");
      expect(model.branchName, "Main Branch");
      expect(model.loanType, "WEEKLY");
      expect(model.loanStatus, "OPEN");
      expect(model.loanAmount, 50000.00);
      expect(model.duePending, 2);
      expect(model.principalPending, 5000.00);
      expect(model.finePending, 150.00);
      expect(model.principalPaid, 45000.00);
      expect(model.finePaid, 50.00);
      expect(model.balancePending, 5150.00);
      expect(model.dueDate, "2026-09-15");
      expect(model.installmentAmount, 1000.00);
      expect(model.formattedDueDate, "15 Sep 2026");

      // Backward-compatibility getters
      expect(model.dueCount, 2);
      expect(model.principalPendingLive, 5000.00);
    });
  });

  group('CollectionDetailHeaderCard UI tests', () {
    testWidgets('renders all customer and loan summary fields correctly',
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

      // Customer Information Card checks
      expect(find.text('John Doe'), findsOneWidget);
      expect(
        find.byWidgetPredicate((w) =>
            w is RichText && w.text.toPlainText().contains('ID: 1')),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is RichText &&
            w.text.toPlainText().contains('Loan ID: IND01-LAT-00085')),
        findsOneWidget,
      );

      // Phone action
      expect(find.byIcon(Icons.phone_rounded), findsOneWidget);
      expect(find.text('9876543210'), findsOneWidget);

      // Address
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.text('Customer Address'), findsOneWidget);
      expect(
        find.text('123 Main Street, Near City Square, Kerala 682011'),
        findsOneWidget,
      );

      // Customer Location (Google Maps full-width card)
      expect(find.byIcon(Icons.location_on_rounded), findsOneWidget);
      expect(find.text('Tap to Open Google Maps'), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new_rounded), findsOneWidget);

      // Area
      expect(
        find.byWidgetPredicate((w) =>
            w is RichText && w.text.toPlainText().contains('Area: Downtown')),
        findsOneWidget,
      );

      // Chips
      expect(find.text('WEEKLY'), findsOneWidget);
      expect(find.text('Main Branch'), findsOneWidget);
      expect(find.text('OPEN'), findsOneWidget);

      // Row 1: LOAN AMOUNT & COLLECTION DATE
      expect(find.text('LOAN AMOUNT'), findsOneWidget);
      expect(find.text('₹50,000'), findsOneWidget);
      expect(find.text('COLLECTION DATE'), findsOneWidget);
      expect(find.text('15 Sep 2026'), findsOneWidget);

      // Row 2: PRINCIPAL BALANCE & FINE BALANCE
      expect(find.text('PRINCIPAL BALANCE'), findsOneWidget);
      expect(find.text('₹5,000'), findsOneWidget);
      expect(find.text('FINE BALANCE'), findsOneWidget);
      expect(find.text('₹150'), findsOneWidget);

      // Row 3: PRINCIPAL PAID & FINE PAID
      expect(find.text('PRINCIPAL PAID'), findsOneWidget);
      expect(find.text('₹45,000'), findsOneWidget);
      expect(find.text('FINE PAID'), findsOneWidget);
      expect(find.text('₹50'), findsOneWidget);

      // Row 4: DUE PENDING & INSTALLMENT AMOUNT
      expect(find.text('DUE PENDING'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('INSTALLMENT AMOUNT'), findsOneWidget);
      expect(find.text('₹1,000'), findsOneWidget);

      // BALANCE PENDING should no longer appear
      expect(find.text('BALANCE PENDING'), findsNothing);
    });

    testWidgets(
        'hides customer location row when customer_location is empty or missing',
        (WidgetTester tester) async {
      final jsonWithoutLocation = Map<String, dynamic>.from(sampleJson);
      jsonWithoutLocation['customer_location'] = '';

      final model = CollectionDetailModel.fromJson(jsonWithoutLocation);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CollectionDetailHeaderCard(data: model),
            ),
          ),
        ),
      );

      expect(find.text('Tap to Open Google Maps'), findsNothing);
      expect(find.byIcon(Icons.location_on_rounded), findsNothing);
    });

    testWidgets(
        'phone number card and location card satisfy minimum 48px touch target',
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

      // Verify phone number call icon size is 24px
      final phoneIconFinder = find.byWidgetPredicate(
        (w) => w is Icon && w.icon == Icons.phone_rounded && w.size == 24,
      );
      expect(phoneIconFinder, findsOneWidget);

      // Verify phone card has height >= 48px
      final phoneCardFinder = find.ancestor(
        of: find.text('9876543210'),
        matching: find.byType(InkWell),
      );
      expect(phoneCardFinder, findsOneWidget);
      final phoneCardSize = tester.getSize(phoneCardFinder);
      expect(phoneCardSize.height, greaterThanOrEqualTo(48.0));

      // Verify location card has height >= 48px
      final locationCardFinder = find.ancestor(
        of: find.text('Tap to Open Google Maps'),
        matching: find.byType(InkWell),
      );
      expect(locationCardFinder, findsOneWidget);
      final locationCardSize = tester.getSize(locationCardFinder);
      expect(locationCardSize.height, greaterThanOrEqualTo(48.0));
    });
  });
}
