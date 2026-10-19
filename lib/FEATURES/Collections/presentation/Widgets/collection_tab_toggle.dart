import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_model.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

class CollectionTabToggle extends StatelessWidget {
  final CollectionStatus selected;
  final ValueChanged<CollectionStatus> onChanged;

  const CollectionTabToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildPill(
            context,
            label: 'Outstanding',
            value: CollectionStatus.outstanding,
          ),
          _buildPill(
            context,
            label: 'Collected',
            value: CollectionStatus.collected,
          ),
        ],
      ),
    );
  }

  Widget _buildPill(
    BuildContext context, {
    required String label,
    required CollectionStatus value,
  }) {
    final bool isActive = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: isActive
              ? AppTextStyles.tabActive(context)
              : AppTextStyles.tabInactive(context),
        ),
      ),
    );
  }
}
