import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_model.dart';
import 'package:provider/provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../../../../CORE/Widgets/app_pagination.dart';

import '../../provider/collection_list_provider.dart';

import 'collection_card.dart';

class CollectionList extends StatelessWidget {
  final List<CollectionModel> items;

  final ValueChanged<CollectionModel>? onItemTap;

  const CollectionList({super.key, required this.items, this.onItemTap});

  Future<void> _refreshCollections(BuildContext context) async {
    await context.read<CollectionListProvider>().fetchCollections();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CollectionListProvider>();

    return RefreshIndicator(
      onRefresh: () => _refreshCollections(context),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          /// ==========================================================
          /// COLLECTION CARDS
          /// ==========================================================
          if (items.isEmpty)
            SizedBox(
              height: 180,
              child: Center(
                child: Text(
                  'No records found',
                  style: AppTextStyles.body(
                    context,
                  ).copyWith(color: AppColors.gray400),
                ),
              ),
            )
          else
            ...List.generate(items.length, (index) {
              final item = items[index];

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == items.length - 1 ? 0 : 12,
                ),
                child: CollectionCard(
                  data: item,
                  onTap: onItemTap == null ? null : () => onItemTap!(item),
                ),
              );
            }),

          /// ==========================================================
          /// PAGINATION
          /// Appears AFTER the last collection card
          /// and scrolls with the list
          /// ==========================================================
          if (provider.totalPages > 1) ...[
            const SizedBox(height: 16),

            Center(
              child: AppPagination(
                currentPage: provider.currentPage,
                totalPages: provider.totalPages,
                isLoading: provider.isLoading,
                onPageChanged: (page) {
                  provider.goToPage(page);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
