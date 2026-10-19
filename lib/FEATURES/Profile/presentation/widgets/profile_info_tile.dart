import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';

class ProfileInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final bool showDivider;

  const ProfileInfoTile({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.showDivider = true,
  });

  IconData get _icon {
    if (icon != null) return icon!;
    final lower = title.toLowerCase();
    if (lower.contains('staff') ||
        lower.contains('employee') ||
        lower.contains('id')) {
      return Icons.badge_outlined;
    }
    if (lower.contains('name')) return Icons.person_outline_rounded;
    if (lower.contains('phone')) return Icons.phone_outlined;
    if (lower.contains('mail') || lower.contains('email')) {
      return Icons.mail_outline_rounded;
    }
    if (lower.contains('role') ||
        lower.contains('type') ||
        lower.contains('member') ||
        lower.contains('designation')) {
      return Icons.work_outline_rounded;
    }
    if (lower.contains('gender')) return Icons.person_outline_rounded;
    if (lower.contains('blood')) return Icons.water_drop_outlined;
    if (lower.contains('dob') ||
        lower.contains('birth') ||
        lower.contains('date')) {
      return Icons.cake_outlined;
    }
    if (lower.contains('branch')) return Icons.apartment_rounded;
    if (lower.contains('address')) return Icons.location_on_outlined;
    return Icons.info_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Rounded-square teal icon container ──
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  _icon,
                  size: 19,
                  color: AppColors.secondaryDark,
                ),
              ),
              const SizedBox(width: 12),

              // ── Label & Value ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.subtitle,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasValue ? value : 'Not provided',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: hasValue
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                        fontStyle:
                            hasValue ? FontStyle.normal : FontStyle.italic,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.border,
          ),
      ],
    );
  }
}