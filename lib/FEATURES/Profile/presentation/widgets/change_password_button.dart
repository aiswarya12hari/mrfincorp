// // import 'package:flutter/material.dart';
// // import '../../../../../CORE/Theme/app_color.dart';

// // class ChangePasswordButton extends StatelessWidget {
// //   const ChangePasswordButton({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       width: double.infinity,
// //       height: 48,
// //       child: OutlinedButton(
// //         onPressed: () {},
// //         style: OutlinedButton.styleFrom(
// //           side: const BorderSide(
// //             color: AppColors.primary,
// //           ),
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(10),
// //           ),
// //         ),
// //         child: const Text(
// //           'Change Password',
// //           style: TextStyle(
// //             color: AppColors.primaryDark,
// //             fontWeight: FontWeight.w600,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import '../../../../../CORE/Theme/app_color.dart';

// class ChangePasswordButton extends StatelessWidget {
//   const ChangePasswordButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 52,
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//             colors: [
//               AppColors.primaryDark,
//               AppColors.primary,
//             ],
//           ),
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.primaryDark.withOpacity(0.35),
//               blurRadius: 14,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: ElevatedButton.icon(
//           onPressed: () {},
//           icon: const Icon(
//             Icons.lock_outline_rounded,
//             size: 18,
//             color: Colors.white,
//           ),
//           label: const Text(
//             'Change Password',
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//               letterSpacing: 0.3,
//             ),
//           ),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.transparent,
//             shadowColor: Colors.transparent,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }