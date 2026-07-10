// import 'package:flutter/material.dart';
// import 'package:mr_fincorp/CORE/Theme/app_color.dart';
// import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
// import 'package:mr_fincorp/CORE/Utils/responsive.dart';

// /// Full-width teal gradient button used across FinCorp.
// class FincorpPrimaryButton extends StatelessWidget {
//   final String label;
//   final VoidCallback? onPressed;
//   final bool isLoading;

//   const FincorpPrimaryButton({
//     super.key,
//     required this.label,
//     this.onPressed,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final dim = Dimensions(context);

//     return SizedBox(
//       width: double.infinity,
//       height: dim.height(0.065).clamp(50.0, 60.0),
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           // Stronger, more visible 3-stop gradient (left → right) so the
//           // teal depth actually reads on screen, matching a polished
//           // fintech-app look instead of a flat single-tone fill.
//           gradient: const LinearGradient(
//             colors: [
//               AppColors.primaryLight,
//               AppColors.primary,
//               AppColors.primaryDark,
//             ],
//             stops: [0.0, 0.5, 1.0],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.primaryDark.withOpacity(0.38),
//               blurRadius: 20,
//               spreadRadius: -2,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(16),
//           child: InkWell(
//             onTap: isLoading ? null : onPressed,
//             borderRadius: BorderRadius.circular(16),
//             splashColor: AppColors.white.withOpacity(0.15),
//             highlightColor: AppColors.white.withOpacity(0.08),
//             child: Center(
//               child: isLoading
//                   ? const SizedBox(
//                       width: 22,
//                       height: 22,
//                       child: CircularProgressIndicator(
//                         color: AppColors.white,
//                         strokeWidth: 2.5,
//                       ),
//                     )
//                   : Text(label, style: AppTextStyles.button(context)),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
import 'package:mr_fincorp/CORE/Utils/responsive.dart';

/// Full-width teal gradient pill button used across FinCorp.
class FincorpPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const FincorpPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final dim = Dimensions(context);
    final height = dim.height(0.065).clamp(50.0, 60.0);
    final radius = height / 2; // fully rounded pill, matches reference

    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          // Smooth left-to-right brand gradient, pill-shaped.
          gradient: const LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withOpacity(0.35),
              blurRadius: 18,
              spreadRadius: -2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(radius),
            splashColor: AppColors.white.withOpacity(0.15),
            highlightColor: AppColors.white.withOpacity(0.08),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(label, style: AppTextStyles.button(context)),
            ),
          ),
        ),
      ),
    );
  }
}