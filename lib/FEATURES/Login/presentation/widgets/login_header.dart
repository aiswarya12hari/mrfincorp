// import 'package:flutter/material.dart';
// import 'package:mr_fincorp/CORE/Theme/app_color.dart';
// import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';

// class LoginHeader extends StatelessWidget {
//   const LoginHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Logo Card
//           Container(
//             width: 100,
//             height: 100,
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.primary.withOpacity(0.15),
//                   blurRadius: 15,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Image.asset(
//                 'assets/icons/icon.png',
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),

//           const SizedBox(height: 20),

//           Text(
//             'Field Staff Login',
//             style: AppTextStyles.headline(context),
//           ),

//           const SizedBox(height: 8),

//           Text(
//             'Welcome back! Please login to continue',
//             style: AppTextStyles.subheading(context),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
import 'package:mr_fincorp/CORE/Utils/responsive.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dim = Dimensions(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Card — bigger now, with a softer/larger shadow to match
        // the increased scale.
        Container(
          width: dim.isTablet ? 110 : 96,
          height: dim.isTablet ? 110 : 96,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Image.asset(
              'assets/icons/icon.png',
              fit: BoxFit.contain,
            ),
          ),
        ),

        SizedBox(height: dim.gap(0.024)),

        Text(
          'Field Staff Login',
          style: AppTextStyles.headline(context),
        ),

        SizedBox(height: dim.gap(0.008)),

        Text(
          'Welcome back! Please login to continue',
          style: AppTextStyles.subheading(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}