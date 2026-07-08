import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_model.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/Widgets/collected_list.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/Widgets/collection_list.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/Widgets/collection_search_bar.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/Widgets/collection_tab_toggle.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/pages/collection_detail_page.dart';
import 'package:mr_fincorp/FEATURES/Collections/provider/collected_list_provider.dart';
import 'package:mr_fincorp/FEATURES/Collections/provider/collection_list_provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  CollectionStatus _selectedTab = CollectionStatus.outstanding;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollectionListProvider>().fetchCollections();
    });
  }

  List<CollectionModel> _filteredOutstanding(List<CollectionModel> all) {
    final query = _searchQuery.trim().toLowerCase();
    return all.where((item) {
      final matchesTab = item.status == CollectionStatus.outstanding;
      final matchesSearch = query.isEmpty ||
          item.customerName.toLowerCase().contains(query) ||
          item.loanId.toLowerCase().contains(query);
      return matchesTab && matchesSearch;
    }).toList();
  }

  void _onTabChanged(CollectionStatus status) {
    setState(() => _selectedTab = status);

    if (status == CollectionStatus.collected) {
      context.read<CollectedListProvider>().fetchCollected();
    } else {
      context.read<CollectionListProvider>().fetchCollections();
    }
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        backgroundColor: AppColors.gray100,
        elevation: 0,
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColors.gray800),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text('Collections', style: AppTextStyles.pageTitle(context)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CollectionTabToggle(
                  selected: _selectedTab,
                  onChanged: _onTabChanged,
                ),
                const SizedBox(height: 16),
                CollectionSearchBar(
                  onChanged: _onSearchChanged,
                  onFilterTap: () {
                    // TODO: open filter sheet once filter UI is defined
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedTab == CollectionStatus.outstanding
                ? Consumer<CollectionListProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (provider.errorMessage != null) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Failed to load collections.\n${provider.errorMessage}',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.body(context),
                            ),
                          ),
                        );
                      }

                      final items = _filteredOutstanding(provider.collections);

                      return CollectionList(
                        items: items,
                        onItemTap: (CollectionModel item) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CollectionDetailsPage(data: item),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Consumer<CollectedListProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (provider.errorMessage != null) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Failed to load collected list.\n${provider.errorMessage}',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.body(context),
                            ),
                          ),
                        );
                      }

                      final query = _searchQuery.trim().toLowerCase();
                      final items = provider.collectedItems.where((item) {
                        return query.isEmpty ||
                            item.customerName.toLowerCase().contains(query) ||
                            item.loanId.toLowerCase().contains(query);
                      }).toList();

                      return CollectedList(items: items);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}