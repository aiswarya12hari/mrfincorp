import 'package:flutter/material.dart';

import '../../../../../CORE/Theme/app_color.dart';
import '../../../../../CORE/Theme/app_text_style.dart';

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
        return Icons.mail_outline_rounded;
      case 'phone':
        return Icons.phone_outlined;
      case 'branch':
        return Icons.business_outlined;
      case 'address':
        return Icons.location_on_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Small uppercase gray label above field ──
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.gray600,
              letterSpacing: 0.8,
            ),
          ),

          const SizedBox(height: 6),

          // ── Light gray rounded rectangular box (subtle border, soft fill) ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.borderColor,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  _icon,
                  size: 18,
                  color: AppColors.gray600,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value.isNotEmpty ? value : 'Not provided',
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray800,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}