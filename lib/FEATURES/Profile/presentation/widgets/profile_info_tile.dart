// import 'package:flutter/material.dart';
// import '../../../../../CORE/Theme/app_color.dart';

// class ProfileInfoTile extends StatelessWidget {
//   final String title;
//   final String value;

//   const ProfileInfoTile({
//     super.key,
//     required this.title,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             title,
//             style: const TextStyle(
//               color: AppColors.gray600,
//               fontSize: 14,
//             ),
//           ),
//         ),

//         Expanded(
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: Text(
//               value,
//               textAlign: TextAlign.right,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../../../../CORE/Theme/app_color.dart';

class ProfileInfoTile extends StatelessWidget {
  final String title;
  final String value;

  const ProfileInfoTile({
    super.key,
    required this.title,
    required this.value,
  });

  IconData get _icon {
    switch (title.toLowerCase()) {
      case 'email':
        return Icons.email_outlined;
      case 'phone':
        return Icons.phone_outlined;
      case 'branch':
        return Icons.account_balance_outlined;
      case 'address':
        return Icons.location_on_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Teal icon pill
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _icon,
              size: 18,
              color: AppColors.primaryDark,
            ),
          ),

          const SizedBox(width: 14),

          // Label
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.gray600,
              ),
            ),
          ),

          // Value
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gray800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}