import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
import 'package:mr_fincorp/FEATURES/Account/presentation/widgets/account_switcher_sheet.dart';
import 'package:mr_fincorp/FEATURES/Profile/provider/profile_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/logout_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_tile.dart';
import '../widgets/profile_shimmer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color _pageBg = AppColors.background;
  static const Color _accentColor = AppColors.secondary;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileProvider>().getProfile();
      }
    });
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) {
      final s = parts.first;
      return (s.length >= 2 ? s.substring(0, 2) : s.substring(0, 1)).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: const ProfileHeader(),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const ProfileShimmer();
          }

          final profile = provider.profile;

          if (profile == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Failed to load profile',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context.read<ProfileProvider>().getProfile(),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: _accentColor,
            backgroundColor: Colors.white,
            onRefresh: () => context.read<ProfileProvider>().getProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),

                  // ── Centered Circular Avatar with Teal Border ──
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryLight,
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.35),
                        width: 2.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials(profile.fieldStaffName),
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: AppColors.secondaryDark,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── User Name (Centered, Bold, Dark) ──
                  Text(
                    profile.fieldStaffName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Details Card (White, Rounded Corners, Clean Border) ──
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Column(
                      children: [
                        ProfileInfoTile(
                          title: 'Staff ID',
                          value: profile.fieldStaffId,
                          icon: Icons.badge_outlined,
                        ),
                        ProfileInfoTile(
                          title: 'Full Name',
                          value: profile.fieldStaffName,
                          icon: Icons.person_outline_rounded,
                        ),
                        ProfileInfoTile(
                          title: 'Phone Number',
                          value: profile.phone,
                          icon: Icons.phone_outlined,
                        ),
                        ProfileInfoTile(
                          title: 'Email Address',
                          value: profile.email,
                          icon: Icons.mail_outline_rounded,
                        ),
                        ProfileInfoTile(
                          title: 'Role',
                          value: profile.role.isNotEmpty ? profile.role : 'Field Staff',
                          icon: Icons.work_outline_rounded,
                        ),
                        ProfileInfoTile(
                          title: 'Branch',
                          value: profile.branchName.isNotEmpty
                              ? (profile.branchCode.isNotEmpty
                                  ? '${profile.branchName} (${profile.branchCode})'
                                  : profile.branchName)
                              : (profile.branchCode.isNotEmpty
                                  ? profile.branchCode
                                  : ''),
                          icon: Icons.apartment_rounded,
                        ),
                        ProfileInfoTile(
                          title: 'Address',
                          value: profile.address,
                          icon: Icons.location_on_outlined,
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Account Actions Card (Switch Account & Logout) ──
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Switch Account Option
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => AccountSwitcherSheet.show(context),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            splashColor: AppColors.secondary.withValues(alpha: 0.08),
                            highlightColor: AppColors.secondary.withValues(alpha: 0.04),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.swap_horiz_rounded,
                                      size: 19,
                                      color: AppColors.secondaryDark,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Switch Account',
                                          style: TextStyle(
                                            fontFamily: AppTextStyles.fontFamily,
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Manage or switch between active accounts',
                                          style: TextStyle(
                                            fontFamily: AppTextStyles.fontFamily,
                                            fontSize: 11,
                                            color: AppColors.subtitle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 20,
                                    color: AppColors.textLight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const Divider(height: 1, thickness: 1, color: AppColors.border),

                        // Logout Option
                        const LogoutButton(),
                      ],
                    ),
                  ),

                  // Bottom padding to avoid any overlap
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 24,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
