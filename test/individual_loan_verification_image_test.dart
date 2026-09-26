import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/customer_model.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/individual_loan_verification_model.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/loan_detail_model.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/individual_loan_verification.dart';
import 'package:mr_fincorp/FEATURES/Loans/provider/individual_loan_verification.dart';
import 'package:mr_fincorp/FEATURES/Loans/provider/loan_provider.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

void main() {
  group('IndividualLoanVerificationModel Image Tests', () {
    test('toJson excludes image when image is null', () {
      final model = IndividualLoanVerificationModel(
        feedback: 'Customer verified successfully.',
        latitude: '10.12345678',
        longitude: '76.12345678',
        fullAddress: '123 Main St, Ernakulam, Kerala',
        landmark: 'Near SBI Bank',
        state: 'Kerala',
        district: 'Ernakulam',
        googleMapLink: 'https://maps.google.com/?q=10.12345678,76.12345678',
        maxPayAmount: '5000',
      );

      final json = model.toJson();
      expect(json.containsKey('image'), isFalse);
      expect(json['feedback'], equals('Customer verified successfully.'));
      expect(json['latitude'], equals('10.12345678'));
      expect(json['longitude'], equals('76.12345678'));
      expect(json['full_address'], equals('123 Main St, Ernakulam, Kerala'));
      expect(json['landmark'], equals('Near SBI Bank'));
      expect(json['state'], equals('Kerala'));
      expect(json['district'], equals('Ernakulam'));
      expect(json['google_map_link'], equals('https://maps.google.com/?q=10.12345678,76.12345678'));
      expect(json['maximum_payable_amount'], equals('5000'));
    });

    test('toJson includes base64 data uri image when provided', () {
      const dummyBase64 = 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQ...';
      final model = IndividualLoanVerificationModel(
        feedback: 'Customer verified successfully.',
        latitude: '10.12345678',
        longitude: '76.12345678',
        fullAddress: '123 Main St, Ernakulam, Kerala',
        landmark: 'Near SBI Bank',
        state: 'Kerala',
        district: 'Ernakulam',
        googleMapLink: 'https://maps.google.com/?q=10.12345678,76.12345678',
        maxPayAmount: '5000',
        image: dummyBase64,
      );

      final json = model.toJson();
      expect(json.containsKey('image'), isTrue);
      expect(json['image'], equals(dummyBase64));
    });
  });

  group('IndividualLoanVerificationPage Widget Tests', () {
    testWidgets('renders capture photo / upload image section', (tester) async {
      final mockLoan = LoanDetailModel(
        id: 1,
        loanId: 'LN-1001',
        loanType: 'Individual',
        loanAmount: '25000',
        loanDuration: '12 months',
        dateOfApplication: '2026-01-01',
        dateOfExpiry: '2027-01-01',
        status: 'pending',
        feedback: '',
        loanMethod: 'regular',
        customer: CustomerModel(
          customerId: 'CUST-001',
          name: 'John Doe',
          phone: '9876543210',
          occupation: 'Business',
          fullAddress: '123 Main St, Ernakulam, Kerala',
          landmark: 'Near SBI Bank',
          district: 'Ernakulam',
          state: 'Kerala',
          pinCode: '682001',
          googleMapLink: 'https://maps.google.com/?q=10.12345678,76.12345678',
          profileImage: '',
        ),
        groupName: '',
        numberOfMembers: 0,
        branchName: '',
        members: [],
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => IndividualLoanVerificationProvider()),
            ChangeNotifierProvider(create: (_) => LoanProvider()),
            ChangeNotifierProvider(create: (_) => DashboardProvider()),
          ],
          child: MaterialApp(
            home: IndividualLoanVerificationPage(loan: mockLoan),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('VERIFICATION PHOTO (OPTIONAL)'), findsOneWidget);
      expect(find.text('Capture Photo / Upload Image'), findsOneWidget);
      expect(find.text('Submit Verification'), findsOneWidget);
    });
  });
}
