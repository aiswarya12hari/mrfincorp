// import 'package:flutter/material.dart';
// import 'package:mr_fincorp/FEATURES/Profile/presentation/pages/profile_page.dart';

// import '../../../../../CORE/Storage/shared_preference.dart';
// import '../../../../../CORE/Theme/app_color.dart';
// import '../../../../../CORE/Theme/app_text_style.dart';

// class ProfileCard extends StatelessWidget {
//   const ProfileCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userData = AppPreferences.getUserData();

//     final name =
//         userData?['field_staff_name'] ?? '';

//     final staffId =
//         userData?['field_staff_id'] ?? '';

//     final branchName =
//         userData?['branch_name'] ?? '';

//     final branchCode =
//         userData?['branch_code'] ?? '';

//     return InkWell(
//       borderRadius: BorderRadius.circular(18),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const ProfilePage(),
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(
//             color: AppColors.borderColor,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(.03),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 34,
//                   backgroundColor:
//                       AppColors.primary.withOpacity(.15),
//                   child: const Icon(
//                     Icons.person,
//                     size: 40,
//                     color: AppColors.primary,
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 2,
//                   right: 2,
//                   child: Container(
//                     width: 14,
//                     height: 14,
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius:
//                           BorderRadius.circular(20),
//                       border: Border.all(
//                         color: Colors.white,
//                         width: 2,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(width: 16),

//             Expanded(
//               child: Column(
//                 crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: AppTextStyles.body(context)
//                         .copyWith(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 18,
//                     ),
//                   ),

//                   const SizedBox(height: 4),

//                   Text(
//                     staffId,
//                     style:
//                         AppTextStyles.bodySmall(context),
//                   ),

//                   const SizedBox(height: 2),

//                   Text(
//                     '$branchName ($branchCode)',
//                     style:
//                         AppTextStyles.bodySmall(context),
//                   ),
//                 ],
//               ),
//             ),

//             const Icon(
//               Icons.arrow_forward_ios_rounded,
//               size: 18,
//               color: AppColors.gray400,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }