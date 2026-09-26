import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_model.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/Widgets/collection_card.dart';

void main() {
  group('CollectionModel tests', () {
    test('fromJson parses all fields properly', () {
      final json = {
        "sl_no": 1,
        "assignment_id": 1,
        "loan_id": "IND01-LAT-00085",
        "loan_method": "INDIVIDUAL",
        "customer_name": "John Doe",
        "loan_type": "WEEKLY",
        "branch_name": "Main Branch",
        "due_pending": 2,
        "principal_pending": "5000.00",
        "loan_status": "OPEN",
        "fine_pending": "150.00",
        "is_collected": false,
        "collected_amount": "0.00",
        "collection_date": "2026-09-15T10:00:00Z",
        "payment_method": "CASH",
        "feedback": "",
        "created_at": "2026-09-15T10:00:00Z",
      };

      final model = CollectionModel.fromJson(json);

      expect(model.principalPending, 5000.0);
      expect(model.duePending, 2);
      expect(model.finePending, 150.0);
      expect(model.collectionDate, "2026-09-15T10:00:00Z");
      expect(model.formattedLastCollection, "15 Sep 2026");

      // Backward compatibility
      expect(model.principal, 5000.0);
      expect(model.due, 2.0);
      expect(model.duesPending, 2.0);
      expect(model.outstanding, 2.0);
    });

    test('handles null collection_date as No Collection', () {
      final json = {
        "sl_no": 1,
        "assignment_id": 1,
        "loan_id": "IND01-LAT-00085",
        "loan_method": "INDIVIDUAL",
        "customer_name": "John Doe",
        "loan_type": "WEEKLY",
        "branch_name": "Main Branch",
        "due_pending": 2,
        "principal_pending": "5000.00",
        "loan_status": "OPEN",
        "fine_pending": "150.00",
        "is_collected": false,
        "collected_amount": "0.00",
        "collection_date": null,
        "payment_method": "CASH",
        "feedback": "",
        "created_at": "2026-09-15T10:00:00Z",
      };

      final model = CollectionModel.fromJson(json);
      expect(model.collectionDate, isNull);
      expect(model.formattedLastCollection, "No Collection");
    });
  });

  group('CollectionCard widget tests', () {
    testWidgets('displays the new bottom information section properly', (
      tester,
    ) async {
      final model = CollectionModel.fromJson({
        "sl_no": 1,
        "assignment_id": 1,
        "loan_id": "IND01-LAT-00085",
        "loan_method": "INDIVIDUAL",
        "customer_name": "John Doe",
        "loan_type": "WEEKLY",
        "branch_name": "Main Branch",
        "due_pending": 2,
        "principal_pending": "5000.00",
        "loan_status": "OPEN",
        "fine_pending": "150.00",
        "is_collected": false,
        "collected_amount": "0.00",
        "collection_date": "2026-09-15T10:00:00Z",
        "payment_method": "CASH",
        "feedback": "",
        "created_at": "2026-09-15T10:00:00Z",
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CollectionCard(data: model)),
        ),
      );

      // Verify labels
      expect(find.text('Principal Balance'), findsOneWidget);
      expect(find.text('Fine Balance'), findsOneWidget);
      expect(find.text('Pending Dues'), findsOneWidget);
      expect(find.text('Collection Date'), findsOneWidget);

      // Verify values
      expect(find.text('₹5,000'), findsOneWidget);
      expect(find.text('₹150'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('15 Sep 2026'), findsOneWidget);

      // Verify old fields are removed
      expect(find.text('Principal'), findsNothing);
      expect(find.text('Due'), findsNothing);
      expect(find.text('Outstanding'), findsNothing);
      expect(find.text('Due Date'), findsNothing);
    });

    testWidgets('displays No Collection when collection_date is null', (
      tester,
    ) async {
      final model = CollectionModel.fromJson({
        "sl_no": 1,
        "assignment_id": 1,
        "loan_id": "IND01-LAT-00085",
        "loan_method": "INDIVIDUAL",
        "customer_name": "Jane Smith",
        "loan_type": "DAILY",
        "branch_name": "North Branch",
        "due_pending": 0,
        "principal_pending": "12000.00",
        "loan_status": "OPEN",
        "fine_pending": "0.00",
        "is_collected": false,
        "collected_amount": "0.00",
        "collection_date": null,
        "payment_method": "CASH",
        "feedback": "",
        "created_at": "2026-09-15T10:00:00Z",
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CollectionCard(data: model)),
        ),
      );

      expect(find.text('Principal Balance'), findsOneWidget);
      expect(find.text('₹12,000'), findsOneWidget);
      expect(find.text('Fine Balance'), findsOneWidget);
      expect(find.text('₹0'), findsOneWidget);
      expect(find.text('Pending Dues'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Collection Date'), findsOneWidget);
      expect(find.text('No Collection'), findsOneWidget);
    });
  });
}
