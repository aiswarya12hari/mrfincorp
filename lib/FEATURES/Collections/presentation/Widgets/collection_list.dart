import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_model.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import 'collection_card.dart';

class CollectionList extends StatelessWidget {
  final List<CollectionModel> items;
  final ValueChanged<CollectionModel>? onItemTap;

  const CollectionList({
    super.key,
    required this.items,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Center(
          child: Text(
            'No records found',
            style: AppTextStyles.body(context).copyWith(color: AppColors.gray400),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = items[index];
        return CollectionCard(
          data: item,
          onTap: onItemTap == null ? null : () => onItemTap!(item),
        );
      },
    );
  }
}