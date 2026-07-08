import 'package:flutter/material.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

class CollectionSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;

  const CollectionSearchBar({
    super.key,
    required this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 20, color: AppColors.gray400),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: onChanged,
                    style: AppTextStyles.inputText(context),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Search by Loan ID, Customer',
                      hintStyle: AppTextStyles.hint(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 46,
            width: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Icon(Icons.tune, size: 20, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}