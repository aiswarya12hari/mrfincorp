import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Account/provider/account_switch_provider.dart';
import 'package:provider/provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../../../Login/presentation/pages/login_page.dart';
import '../../../Navigation/presentation/pages/bottom_nav_page.dart';
import 'package:mr_fincorp/FEATURES/Account/data/models/account_model.dart';

/// Gmail-style quick account switcher. Call
/// AccountSwitcherSheet.show(context) from anywhere (header, profile).
class AccountSwitcherSheet extends StatefulWidget {
  const AccountSwitcherSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AccountSwitcherSheet(),
    );
  }

  @override
  State<AccountSwitcherSheet> createState() => _AccountSwitcherSheetState();
}

class _AccountSwitcherSheetState extends State<AccountSwitcherSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountSwitcherProvider>().loadAccounts();
    });
  }

  Future<void> _handleSwitch(BuildContext context, AccountModel account) async {
    final provider = context.read<AccountSwitcherProvider>();

    if (account.userId == provider.activeUserId) {
      Navigator.pop(context);
      return;
    }

    final result = await provider.switchTo(account.userId);
    if (!context.mounted) return;

    if (result == SwitchResult.success) {
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BottomNavPage()),
        (route) => false,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(provider.errorMessage ?? 'Failed to switch account')),
    );
  }

  void _handleAddAccount(BuildContext context) {
    Navigator.pop(context); // close sheet first
    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountSwitcherProvider>(
      builder: (context, provider, _) {
        final activeId = provider.activeUserId;

        return SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.gray200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Text(
                  'Switch Account',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray800,
                  ),
                ),
                const SizedBox(height: 12),

                if (provider.accounts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('No saved accounts yet.'),
                  )
                else
                  ...provider.accounts.map(
                    (account) => _AccountRow(
                      account: account,
                      isActive: account.userId == activeId,
                      isBusy: provider.isSwitching,
                      onTap: () => _handleSwitch(context, account),
                    ),
                  ),

                const Divider(height: 28),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gray100,
                    ),
                    child: Icon(Icons.add_rounded, color: AppColors.primary),
                  ),
                  title: Text(
                    'Add Account',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray800,
                    ),
                  ),
                  onTap: provider.isSwitching ? null : () => _handleAddAccount(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AccountRow extends StatelessWidget {
  final AccountModel account;
  final bool isActive;
  final bool isBusy;
  final VoidCallback onTap;

  const _AccountRow({
    required this.account,
    required this.isActive,
    required this.isBusy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: isBusy ? null : onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryLight,
          border: Border.all(
            color: AppColors.secondary,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          account.initials,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: AppColors.secondary,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      title: Text(
        account.name,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.gray800,
        ),
      ),
      subtitle: Text(
        account.email,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 12,
          color: AppColors.gray600,
        ),
      ),
      trailing: isActive
          ? Icon(Icons.check_circle_rounded, color: AppColors.secondary)
          : (isBusy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : null),
    );
  }
}