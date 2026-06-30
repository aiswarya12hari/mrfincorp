// import 'package:flutter/material.dart';

// import '../../../../../CORE/Theme/app_color.dart';
// import '../../../../../CORE/Theme/app_text_style.dart';

// class DashboardHeader extends StatelessWidget {
//   const DashboardHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             'Dashboard',
//             style: AppTextStyles.headline(context)
//                 .copyWith(fontSize: 22),
//           ),
//         ),

//         IconButton(
//           onPressed: () {},
//           icon: const Icon(
//             Icons.notifications_none_rounded,
//             color: AppColors.gray800,
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Utils/responsive.dart';
import '../../../../../CORE/Theme/app_color.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dim = Dimensions(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_none_rounded,
            color: AppColors.gray800,
            size: dim.sp(24),
          ),
        ),
      ],
    );
  }
}