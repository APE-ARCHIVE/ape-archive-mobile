import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/grid_background.dart';
import '../../data/models/resource_model.dart';
import '../../data/providers/library_provider.dart';
import '../widgets/resource_card.dart';
import '../widgets/category_grid_selector.dart';
import 'resource_detail_screen.dart';

class LibraryBrowseScreen extends ConsumerStatefulWidget {
  const LibraryBrowseScreen({super.key});

  @override
  ConsumerState<LibraryBrowseScreen> createState() => _LibraryBrowseScreenState();
}

class _LibraryBrowseScreenState extends ConsumerState<LibraryBrowseScreen> {
  final ScrollController _scrollController = ScrollController();
  List<String> selectedTagIds = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial resources - wrapped in try-catch to handle errors gracefully
    Future.microtask(() {
      try {
        ref.read(browseProvider.notifier).loadResources(refresh: true);
      } catch (e) {
        debugPrint('Error loading initial resources: $e');
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(browseProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final browseState = ref.watch(browseProvider);
    final bool showCategorySelector = selectedTagIds.length < 4; // Show until all 4 levels selected

    return Scaffold(
      body: GridBackground(
        backgroundColor: AppColors.backgroundDark,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large title section with search icon
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Library',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, size: 28, color: Colors.white),
                      onPressed: () {
                        // Navigate to search screen
                      },
                    ),
                  ],
                ),
              ),
              
              // Main content area
              Expanded(
                child: showCategorySelector && browseState.resources.isEmpty
                  ? // Show category grid when no resources loaded yet
                    CategoryGridSelector(
                      selectedTagIds: selectedTagIds,
                      onTagsSelected: (tagIds, tagFilters) {
                        setState(() => selectedTagIds = tagIds);
                        ref.read(browseProvider.notifier).filterByTags(tagIds, tagFilters);
                      },
                    )
                  : // Show resources when available
                    RefreshIndicator(
                      onRefresh: () =>
                          ref.read(browseProvider.notifier).loadResources(refresh: true),
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                  // Web platform notice
                  if (kIsWeb)
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Web Version Limitations',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Browse and explore resources by hierarchy. PDF viewing requires the mobile app.',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  // Compact breadcrumb bar
                  SliverToBoxAdapter(
                    child: _buildCompactBreadcrumb(context),
                  ),

                  // Loading indicator
                  if (browseState.isLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),

                  // Empty state - subtle message
                  if (!browseState.isLoading &&
                      browseState.resources.isEmpty &&
                      browseState.error == null)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open,
                              size: 64,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No resources found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try different categories',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Resource grid
                  if (browseState.resources.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final resource = browseState.resources[index];
                            return ResourceCard(
                              resource: resource,
                              onTap: () => _navigateToDetail(context, resource),
                            );
                          },
                          childCount: browseState.resources.length,
                        ),
                      ),
                    ),

                  // Load more indicator
                  if (browseState.isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),

                  // Bottom padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 16),
                  ),
                        ],
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactBreadcrumb(BuildContext context) {
    if (selectedTagIds.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        children: [
          Icon(Icons.category, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Viewing filtered resources',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() => selectedTagIds = []);
              ref.read(browseProvider.notifier).clearFilters();
            },
            icon: const Icon(Icons.clear, size: 16),
            label: const Text('Clear'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, ResourceModel resource) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResourceDetailScreen(resourceId: resource.id),
      ),
    );
  }

}
