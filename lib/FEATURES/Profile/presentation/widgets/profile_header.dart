// import 'package:flutter/material.dart';
// import '../../../../../CORE/Theme/app_color.dart';

// class ProfileHeader extends StatelessWidget {
//   const ProfileHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 56,
//       alignment: Alignment.center,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [AppColors.primaryDark, AppColors.primary],
//         ),
//       ),
//       child: const Text(
//         'Profile',
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w700,
//           color: Colors.white,
//           letterSpacing: 0.3,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Navigation/navigation_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../CORE/Theme/app_color.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Text(
              'Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.read<NavigationProvider>().changeTab(0);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
