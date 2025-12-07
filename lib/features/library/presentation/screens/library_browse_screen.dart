import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../data/models/resource_model.dart';
import '../../data/providers/library_provider.dart';
import '../widgets/resource_card.dart';
import '../widgets/hierarchy_selector.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(browseProvider.notifier).loadResources(refresh: true),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Hierarchy Selector
            SliverToBoxAdapter(
              child: HierarchySelector(
                selectedTagIds: selectedTagIds,
                onTagsSelected: (tagIds) {
                  setState(() => selectedTagIds = tagIds);
                  ref.read(browseProvider.notifier).filterByTags(tagIds);
                },
              ),
            ),

            // Loading indicator
            if (browseState.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),

            // Error state
            if (browseState.error != null && browseState.resources.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_off_outlined,
                            size: 80, color: AppColors.error),
                        const SizedBox(height: 24),
                        Text(
                          'Cannot Load Resources',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          browseState.error!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Make sure you have an internet connection and the server is available.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => ref
                              .read(browseProvider.notifier)
                              .loadResources(refresh: true),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Empty state
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
                        'Try adjusting your filters',
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
              child: SizedBox(height: 80),
            ),
          ],
        ),
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

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => selectedTagIds = []);
                      ref.read(browseProvider.notifier).clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Sort By',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Recent'),
                        selected: true,
                        onSelected: (_) {},
                      ),
                      FilterChip(
                        label: const Text('Popular'),
                        selected: false,
                        onSelected: (_) {},
                      ),
                      FilterChip(
                        label: const Text('Most Downloaded'),
                        selected: false,
                        onSelected: (_) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Resource Type',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Notes'),
                        selected: false,
                        onSelected: (_) {},
                      ),
                      FilterChip(
                        label: const Text('Past Papers'),
                        selected: false,
                        onSelected: (_) {},
                      ),
                      FilterChip(
                        label: const Text('Model Papers'),
                        selected: false,
                        onSelected: (_) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply Filters'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
