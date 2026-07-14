import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Account/presentation/widgets/account_switcher_sheet.dart';
import 'package:provider/provider.dart';

import '../../../../../CORE/Theme/app_color.dart';

import '../../provider/profile_provider.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_info_tile.dart';
import '../widgets/logout_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final profile = provider.profile;

            if (profile == null) {
              return const Center(child: Text('Failed to load profile'));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const ProfileHeader(),

                  // ── Teal gradient hero section ──────────────────────
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryDark,
                          AppColors.primary,
                          AppColors.primaryLight,
                        ],
                        stops: [0.0, 0.55, 1.0],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                    child: Column(
                      children: [
                        // Avatar with online badge
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.6),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryDark.withOpacity(
                                      0.35,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 42,
                                backgroundColor: Colors.white.withOpacity(0.25),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 44,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 2,
                              bottom: 2,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF48BB78),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Name
                        Text(
                          profile.fieldStaffName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Staff ID badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.35),
                            ),
                          ),
                          child: Text(
                            profile.fieldStaffId,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Pull-up info sheet ──────────────────────────────
                  Transform.translate(
                    offset: const Offset(0, -24),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Section label ────────────────────────
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
                            child: Text(
                              'Account Info',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                                letterSpacing: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 4),

                          // ── Info tiles ───────────────────────────
                          ProfileInfoTile(title: 'Email', value: profile.email),

                          _divider(),

                          ProfileInfoTile(title: 'Phone', value: profile.phone),

                          _divider(),

                          ProfileInfoTile(
                            title: 'Branch',
                            value:
                                '${profile.branchName} (${profile.branchCode})',
                          ),

                          _divider(),

                          ProfileInfoTile(
                            title: 'Address',
                            value: profile.address,
                          ),

                          // ── Divider before actions ───────────────
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(
                              color: AppColors.borderColor,
                              thickness: 1,
                              height: 36,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                            child: Column(
                              children: [
                                // const ChangePasswordButton(),
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      AccountSwitcherSheet.show(context),
                                  icon: Icon(
                                    Icons.swap_horiz_rounded,
                                    color: AppColors.primary,
                                  ),
                                  label: Text(
                                    'Switch Account',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(
                                      double.infinity,
                                      52,
                                    ),
                                    side: BorderSide(color: AppColors.primary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const LogoutButton(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Divider(color: AppColors.borderColor, thickness: 1, height: 1),
  );
}
