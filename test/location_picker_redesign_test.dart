import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/selected_location_model.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/location_picker_page.dart';

void main() {
  group('Location Picker Page Redesign Tests', () {
    test('SelectedLocationModel data contracts remain intact', () {
      final model = SelectedLocationModel(
        latitude: 10.5276,
        longitude: 76.2144,
        address: 'MG Road, Thrissur, Kerala',
        state: 'Kerala',
        district: 'Thrissur',
        googleMapLink: 'https://maps.google.com/?q=10.5276,76.2144',
      );

      expect(model.latitude, equals(10.5276));
      expect(model.longitude, equals(76.2144));
      expect(model.address, equals('MG Road, Thrissur, Kerala'));
      expect(model.state, equals('Kerala'));
      expect(model.district, equals('Thrissur'));
      expect(
        model.googleMapLink,
        equals('https://maps.google.com/?q=10.5276,76.2144'),
      );
    });

    testWidgets('LocationPickerPage renders AppBar with Choose Location and back arrow', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerPage(),
        ),
      );

      // Verify AppBar title
      expect(find.text('Choose Location'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Verify Search TextField and hint
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search location'), findsOneWidget);

      // Verify Confirm Location button
      expect(find.text('Confirm Location'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      // Verify floating current location button icon
      expect(find.byIcon(Icons.my_location_rounded), findsOneWidget);
    });

    testWidgets('LocationPickerPage search field typing and clear button behavior', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerPage(),
        ),
      );

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Enter search text
      await tester.enterText(textField, 'Thrissur');
      await tester.pump();

      // Clear button (X) should be visible when text is entered
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      // Tap clear button
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();

      // Text should be cleared
      final textFieldWidget = tester.widget<TextField>(textField);
      expect(textFieldWidget.controller?.text, isEmpty);
    });

    testWidgets('LocationPickerPage confirm button pops with SelectedLocationModel', (tester) async {
      SelectedLocationModel? poppedResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LocationPickerPage()),
                  );
                  poppedResult = result as SelectedLocationModel?;
                },
                child: const Text('Open Picker'),
              ),
            ),
          ),
        ),
      );

      // Open picker
      await tester.tap(find.text('Open Picker'));
      await tester.pumpAndSettle();

      expect(find.text('Choose Location'), findsOneWidget);

      // Tap Confirm Location
      await tester.tap(find.text('Confirm Location'));
      await tester.pumpAndSettle();

      // Verify popped back and returned valid model
      expect(find.text('Choose Location'), findsNothing);
      expect(poppedResult, isNotNull);
      expect(poppedResult?.latitude, isNotNull);
      expect(poppedResult?.longitude, isNotNull);
      expect(poppedResult?.googleMapLink, contains('https://maps.google.com/?q='));
    });

    testWidgets('LocationPickerPage uses Friends Fincorp Teal color theme', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerPage(),
        ),
      );

      // Check confirm button style
      final confirmBtn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final bg = confirmBtn.style?.backgroundColor?.resolve({});
      expect(bg, equals(AppColors.secondary)); // #18B7B0
    });
  });
}
