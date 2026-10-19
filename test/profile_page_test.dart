import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/FEATURES/Profile/data/models/profile_model.dart';
import 'package:mr_fincorp/FEATURES/Profile/presentation/pages/profile_page.dart';
import 'package:mr_fincorp/FEATURES/Profile/presentation/widgets/profile_header.dart';
import 'package:mr_fincorp/FEATURES/Profile/presentation/widgets/profile_info_tile.dart';
import 'package:mr_fincorp/FEATURES/Profile/provider/logout_provider.dart';
import 'package:mr_fincorp/FEATURES/Profile/provider/profile_provider.dart';
import 'package:mr_fincorp/FEATURES/Navigation/navigation_provider.dart';
import 'package:provider/provider.dart';

class MockProfileProvider extends ProfileProvider {
  ProfileModel? _mockProfile;
  bool _mockLoading = false;

  MockProfileProvider(this._mockProfile);

  @override
  ProfileModel? get profile => _mockProfile;

  @override
  bool get isLoading => _mockLoading;

  @override
  Future<void> getProfile() async {
    // No-op for test
  }
}

void main() {
  final sampleProfile = ProfileModel(
    id: 1,
    role: 'FIELD_STAFF',
    email: 'abcd@gmail.com',
    phone: '9812345678',
    fieldStaffId: 'FLD_STF_001',
    fieldStaffName: 'Hareiharan',
    branchId: 10,
    branchName: 'Palakkad',
    branchCode: 'PKD01',
    address: 'plkd',
  );

  Widget createWidgetUnderTest(ProfileModel? profile) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => MockProfileProvider(profile),
        ),
        ChangeNotifierProvider<LogoutProvider>(
          create: (_) => LogoutProvider(),
        ),
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
        ),
      ],
      child: const MaterialApp(
        home: ProfilePage(),
      ),
    );
  }

  testWidgets('Redesigned ProfilePage renders header, avatar, name, details card, and all fields', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(sampleProfile));
    await tester.pump();

    // Verify ProfileHeader
    expect(find.byType(ProfileHeader), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

    // Verify Avatar Initials & Name
    expect(find.text('HA'), findsOneWidget);
    expect(find.text('Hareiharan'), findsNWidgets(2)); // Centered name + Full Name tile value

    // Verify Details Card & Info Tiles
    expect(find.text('Staff ID'), findsOneWidget);
    expect(find.text('FLD_STF_001'), findsOneWidget);

    expect(find.text('Full Name'), findsOneWidget);

    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('9812345678'), findsOneWidget);

    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('abcd@gmail.com'), findsOneWidget);

    expect(find.text('Role'), findsOneWidget);
    expect(find.text('FIELD_STAFF'), findsOneWidget);

    expect(find.text('Branch'), findsOneWidget);
    expect(find.text('Palakkad (PKD01)'), findsOneWidget);

    expect(find.text('Address'), findsOneWidget);
    expect(find.text('plkd'), findsOneWidget);

    // Verify Action Buttons
    expect(find.text('Switch Account'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);

    // Verify ProfileInfoTile count
    expect(find.byType(ProfileInfoTile), findsNWidgets(7));
  });

  testWidgets('Redesigned ProfilePage handles fallback values gracefully', (tester) async {
    final minimalProfile = ProfileModel(
      id: 2,
      role: '',
      email: '',
      phone: '',
      fieldStaffId: 'FLD_002',
      fieldStaffName: 'User Two',
      branchId: 10,
      branchName: '',
      branchCode: '',
      address: '',
    );

    await tester.pumpWidget(createWidgetUnderTest(minimalProfile));
    await tester.pump();

    expect(find.text('UT'), findsOneWidget); // Initials for User Two
    expect(find.text('User Two'), findsNWidgets(2));
    expect(find.text('Field Staff'), findsOneWidget); // Role fallback
    expect(find.text('Not provided'), findsNWidgets(4)); // Phone, email, branch, address
  });
}

