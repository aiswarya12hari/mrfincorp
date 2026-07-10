import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Login/presentation/pages/login_page.dart';
import 'package:mr_fincorp/FEATURES/Navigation/presentation/pages/bottom_nav_page.dart';
import 'package:provider/provider.dart';
import '../../provider/logout_provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _showLogoutDialog(
    BuildContext context,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Logout',
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final provider =
        context.read<LogoutProvider>();

    // final success =
    //     await provider.logout();

    // if (!context.mounted) return;

    // if (success) {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (_) => const LoginPage(),
    //     ),
    //     (route) => false,
    //   );
    // } else {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(
    //     const SnackBar(
    //       content: Text(
    //         'Logout failed',
    //       ),
    //     ),
    //   );
    // }

    final result = await provider.logout();

    if (!context.mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed')),
      );
      return;
    }

    if (result == true) {
      // Another saved account took over — go straight to Home.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavPage()),
        (route) => false,
      );
    } else {
      // No accounts left at all.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LogoutProvider>(
      builder: (
        context,
        provider,
        child,
      ) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: provider.isLoading
                  ? null
                  : const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFE53E3E),
                        Color(0xFFFC8181),
                      ],
                    ),
              color: provider.isLoading ? const Color(0xFFEDF2F7) : null,
              borderRadius: BorderRadius.circular(14),
              boxShadow: provider.isLoading
                  ? []
                  : [
                      BoxShadow(
                        color: const Color(0xFFE53E3E).withOpacity(0.30),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: ElevatedButton.icon(
              onPressed: provider.isLoading
                  ? null
                  : () => _showLogoutDialog(context),
              icon: provider.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF718096),
                      ),
                    )
                  : const Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
              label: provider.isLoading
                  ? const Text(
                      'Logging out...',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF718096),
                      ),
                    )
                  : const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}