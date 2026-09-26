import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/Widgets/collection_filter_page.dart';
import 'package:mr_fincorp/FEATURES/Navigation/navigation_provider.dart';
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
import 'package:mr_fincorp/main.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> with RouteAware {
  CollectionStatus _selectedTab = CollectionStatus.outstanding;
  String _searchQuery = '';
  int _lastNavIndex = -1;
  int _lastTapCounter = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _refreshActiveTab();
      }
    });
  }

  void _refreshActiveTab() {
    if (_selectedTab == CollectionStatus.collected) {
      context.read<CollectedListProvider>().fetchCollected();
    } else {
      context.read<CollectionListProvider>().fetchCollections();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }

    final nav = Provider.of<NavigationProvider>(context, listen: true);
    if (nav.currentIndex == 2 &&
        (_lastNavIndex != 2 || _lastTapCounter != nav.tabTapCounter)) {
      final shouldRefresh = _lastNavIndex != -1;
      _lastNavIndex = 2;
      _lastTapCounter = nav.tabTapCounter;
      if (shouldRefresh) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _refreshActiveTab();
        });
      }
    } else if (nav.currentIndex != 2) {
      _lastNavIndex = nav.currentIndex;
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    final nav = context.read<NavigationProvider>();
    if (nav.currentIndex == 2) {
      _refreshActiveTab();
    }
  }

  List<CollectionModel> _filteredOutstanding(List<CollectionModel> all) {
    final query = _searchQuery.trim().toLowerCase();
    return all.where((item) {
      final matchesTab = item.status == CollectionStatus.outstanding;
      final matchesSearch =
          query.isEmpty ||
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
  leading: IconButton(
    icon: Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.gray800),
    onPressed: () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        context.read<NavigationProvider>().changeTab(0);
      }
    },
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
                  onFilterTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CollectionFilterPage(activeTab: _selectedTab),
                      ),
                    );
                    if (mounted) {
                      _refreshActiveTab();
                    }
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
                        onItemTap: (CollectionModel item) async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CollectionDetailsPage(data: item),
                            ),
                          );
                          if (mounted) {
                            _refreshActiveTab();
                          }
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
