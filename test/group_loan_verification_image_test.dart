import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/provider/dashboard_provider.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/group_member_model.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/group_verify_request_model.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/group_member_verification_page.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets/verification_image_section.dart';
import 'package:mr_fincorp/FEATURES/Loans/provider/group_loan_verification_provider.dart';
import 'package:mr_fincorp/FEATURES/Loans/provider/loan_provider.dart';
import 'package:provider/provider.dart';

void main() {
  group('GroupMemberVerifyRequestModel Image Tests', () {
    test('toJson excludes image when image is null', () {
      final model = GroupMemberVerifyRequestModel(
        customerId: 49,
        latitude: '10.22222222',
        longitude: '76.22222222',
        fullAddress: '45 Blue Ave, Thrissur',
        landmark: 'Near School',
        state: 'Kerala',
        district: 'Thrissur',
        googleMapLink: 'https://maps.google.com/?q=10.22222222,76.22222222',
        maxPayAmount: '5000',
      );

      final json = model.toJson();
      expect(json.containsKey('image'), isFalse);
      expect(json['customer_id'], equals(49));
      expect(json['latitude'], equals('10.22222222'));
      expect(json['longitude'], equals('76.22222222'));
      expect(json['full_address'], equals('45 Blue Ave, Thrissur'));
      expect(json['landmark'], equals('Near School'));
      expect(json['state'], equals('Kerala'));
      expect(json['district'], equals('Thrissur'));
      expect(
        json['google_map_link'],
        equals('https://maps.google.com/?q=10.22222222,76.22222222'),
      );
      expect(json['maximum_payable_amount'], equals('5000'));
    });

    test('toJson includes base64 data uri image when provided', () {
      const dummyBase64 = 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQ...';
      final model = GroupMemberVerifyRequestModel(
        customerId: 49,
        latitude: '10.22222222',
        longitude: '76.22222222',
        fullAddress: '45 Blue Ave, Thrissur',
        landmark: 'Near School',
        state: 'Kerala',
        district: 'Thrissur',
        pinCode: '680001',
        googleMapLink: 'https://maps.google.com/?q=10.22222222,76.22222222',
        maxPayAmount: '5000',
        image: dummyBase64,
      );

      final json = model.toJson();
      expect(json.containsKey('image'), isTrue);
      expect(json['image'], equals(dummyBase64));
      expect(json['pin_code'], equals('680001'));
      expect(json['customer_id'], equals(49));
    });

    test('GroupVerifyRequestModel encodes full payload correctly', () {
      const dummyBase64 = 'data:image/jpeg;base64,/9j...';
      final request = GroupVerifyRequestModel(
        feedback: 'All members verified.',
        members: [
          GroupMemberVerifyRequestModel(
            customerId: 49,
            latitude: '10.22222222',
            longitude: '76.22222222',
            fullAddress: '45 Blue Ave, Thrissur',
            landmark: 'Near School',
            state: 'Kerala',
            district: 'Thrissur',
            pinCode: '680001',
            googleMapLink: 'https://maps.google.com/?q=10.22222222,76.22222222',
            maxPayAmount: '',
            image: dummyBase64,
          ),
        ],
      );

      final json = request.toJson();
      expect(json['feedback'], equals('All members verified.'));
      expect(json['members'], isA<List>());
      expect((json['members'] as List).length, equals(1));
      final memberJson = (json['members'] as List).first as Map<String, dynamic>;
      expect(memberJson['customer_id'], equals(49));
      expect(memberJson['image'], equals(dummyBase64));
    });
  });

  group('GroupMemberVerificationPage Widget Tests', () {
    final mockMember = GroupMemberModel(
      customerId: 49,
      name: 'Priya Mohan',
      customerCode: 'CUST-049',
      installmentAmount: '1200',
      isVerified: false,
    );

    Widget createTestWidget() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GroupLoanVerificationProvider()),
          ChangeNotifierProvider(create: (_) => LoanProvider()),
          ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ],
        child: MaterialApp(
          home: GroupMemberVerificationPage(
            loanId: 'GRP-LN-1001',
            member: mockMember,
          ),
        ),
      );
    }

    testWidgets('renders member image section below location details', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(VerificationImageSection), findsOneWidget);
      expect(find.text('+ Add Photos'), findsOneWidget);
      expect(find.text('Submit Verification'), findsOneWidget);
    });

    testWidgets('shows bottom sheet modal with Camera and Gallery on tap', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final uploadFinder = find.text('+ Add Photos');
      await tester.ensureVisible(uploadFinder);
      await tester.pumpAndSettle();

      // Tap on image upload box
      await tester.tap(uploadFinder);
      await tester.pumpAndSettle();

      expect(find.text('Take a Photo'), findsOneWidget);
      expect(find.text('Choose from Gallery'), findsOneWidget);
    });
  });
}
