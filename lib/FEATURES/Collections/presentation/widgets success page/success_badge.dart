import 'package:flutter/material.dart';

import '../../../../CORE/Theme/app_color.dart';

class CollectionSuccessBadge extends StatelessWidget {
  const CollectionSuccessBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: AppColors.primary, size: 30),
        ),
      ),
    );
  }
}