import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../data/models/tag_model.dart';
import '../../data/providers/library_provider.dart';

/// Modern grid-based category selector inspired by Khan Academy, Coursera, Duolingo
class CategoryGridSelector extends ConsumerStatefulWidget {
  final List<String> selectedTagIds;
  final Function(List<String> tagIds, Map<String, String> tagFilters) onTagsSelected;

  const CategoryGridSelector({
    super.key,
    required this.selectedTagIds,
    required this.onTagsSelected,
  });

  @override
  ConsumerState<CategoryGridSelector> createState() => _CategoryGridSelectorState();
}

class _CategoryGridSelectorState extends ConsumerState<CategoryGridSelector> {
  final Map<TagType, TagModel?> _selectedTags = {};

  @override
  Widget build(BuildContext context) {
    final hierarchyAsync = ref.watch(hierarchyProvider);

    return hierarchyAsync.when(
      data: (hierarchy) => _buildCategoryView(context, hierarchy),
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading categories...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load categories',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(hierarchyProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryView(BuildContext context, List<TagHierarchyNode> hierarchy) {
    final nextLevelOptions = _getNextLevelOptions(hierarchy);
    
    if (nextLevelOptions.isEmpty && _selectedTags.isNotEmpty) {
      // Reached the end, show resources
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Breadcrumb navigation bar
        if (_selectedTags.isNotEmpty) _buildBreadcrumbBar(context),
        
        // Main content area with categories
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and description
                    _buildSectionHeader(context),
                    const SizedBox(height: 24),
                    
                    // Category grid
                    _buildCategoryGrid(context, nextLevelOptions),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBreadcrumbBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: _clearAllSelections,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home, size: 18, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Home',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_selectedTags[TagType.grade] != null) ...[
                    const Icon(Icons.chevron_right, size: 16),
                    _buildBreadcrumbItem(
                      context,
                      _selectedTags[TagType.grade]!.name,
                      () => _clearFrom(TagType.grade),
                    ),
                  ],
                  if (_selectedTags[TagType.subject] != null) ...[
                    const Icon(Icons.chevron_right, size: 16),
                    _buildBreadcrumbItem(
                      context,
                      _selectedTags[TagType.subject]!.name,
                      () => _clearFrom(TagType.subject),
                    ),
                  ],
                  if (_selectedTags[TagType.medium] != null) ...[
                    const Icon(Icons.chevron_right, size: 16),
                    _buildBreadcrumbItem(
                      context,
                      _selectedTags[TagType.medium]!.name,
                      () => _clearFrom(TagType.medium),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbItem(BuildContext context, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    String title = _getHeaderTitle();
    String subtitle = _getHeaderSubtitle();
    IconData icon = _getHeaderIcon();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(BuildContext context, List<TagHierarchyNode> nodes) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    
    if (screenWidth > 1200) {
      crossAxisCount = 4;
    } else if (screenWidth > 800) {
      crossAxisCount = 3;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(context, nodes[index]);
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, TagHierarchyNode node) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _selectTag(node.tag),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            // Transparent effect with subtle border
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              // Subtle shadow for depth
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  _getIconForTagType(node.tag.type),
                  size: 80,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconForTagType(node.tag.type),
                        color: Colors.white.withOpacity(0.8),
                        size: 28,
                      ),
                    ),
                    // Text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          node.tag.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Explore',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.75),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForTagType(TagType type) {
    switch (type) {
      case TagType.grade:
        return Icons.school_rounded;
      case TagType.subject:
        return Icons.menu_book_rounded;
      case TagType.medium:
        return Icons.language_rounded;
      case TagType.resourceType:
        return Icons.description_rounded;
      case TagType.lesson:
        return Icons.book_rounded;
    }
  }

  String _getHeaderTitle() {
    if (_selectedTags[TagType.grade] == null) return 'Select Your Grade';
    if (_selectedTags[TagType.subject] == null) return 'Choose a Subject';
    if (_selectedTags[TagType.medium] == null) return 'Select Medium';
    if (_selectedTags[TagType.resourceType] == null) return 'Resource Type';
    return 'Browse Resources';
  }

  String _getHeaderSubtitle() {
    if (_selectedTags[TagType.grade] == null) {
      return 'Choose your grade level to get started';
    }
    if (_selectedTags[TagType.subject] == null) {
      return 'Select a subject from ${_selectedTags[TagType.grade]!.name}';
    }
    if (_selectedTags[TagType.medium] == null) {
      return 'Choose your preferred learning medium';
    }
    if (_selectedTags[TagType.resourceType] == null) {
      return 'What type of resource are you looking for?';
    }
    return 'Explore available resources';
  }

  IconData _getHeaderIcon() {
    if (_selectedTags[TagType.grade] == null) return Icons.school_rounded;
    if (_selectedTags[TagType.subject] == null) return Icons.menu_book_rounded;
    if (_selectedTags[TagType.medium] == null) return Icons.language_rounded;
    if (_selectedTags[TagType.resourceType] == null) return Icons.description_rounded;
    return Icons.folder_rounded;
  }

  List<TagHierarchyNode> _getNextLevelOptions(List<TagHierarchyNode> hierarchy) {
    if (_selectedTags[TagType.grade] == null) {
      return hierarchy;
    }
    if (_selectedTags[TagType.subject] == null) {
      return _getChildren(hierarchy, _selectedTags[TagType.grade]!.id);
    }
    if (_selectedTags[TagType.medium] == null) {
      return _getChildren(hierarchy, _selectedTags[TagType.subject]!.id);
    }
    if (_selectedTags[TagType.resourceType] == null) {
      return _getChildren(hierarchy, _selectedTags[TagType.medium]!.id);
    }
    return [];
  }

  List<TagHierarchyNode> _getChildren(
    List<TagHierarchyNode> hierarchy,
    String parentId,
  ) {
    for (final node in hierarchy) {
      if (node.tag.id == parentId) {
        return node.children;
      }
      final result = _getChildren(node.children, parentId);
      if (result.isNotEmpty) return result;
    }
    return [];
  }

  void _selectTag(TagModel tag) {
    setState(() {
      _selectedTags[tag.type] = tag;
      // Clear child selections
      switch (tag.type) {
        case TagType.grade:
          _selectedTags.remove(TagType.subject);
          _selectedTags.remove(TagType.medium);
          _selectedTags.remove(TagType.resourceType);
          break;
        case TagType.subject:
          _selectedTags.remove(TagType.medium);
          _selectedTags.remove(TagType.resourceType);
          break;
        case TagType.medium:
          _selectedTags.remove(TagType.resourceType);
          break;
        default:
          break;
      }
    });
    _updateSelection();
  }

  void _clearFrom(TagType type) {
    setState(() {
      switch (type) {
        case TagType.grade:
          _selectedTags.clear();
          break;
        case TagType.subject:
          _selectedTags.remove(TagType.subject);
          _selectedTags.remove(TagType.medium);
          _selectedTags.remove(TagType.resourceType);
          break;
        case TagType.medium:
          _selectedTags.remove(TagType.medium);
          _selectedTags.remove(TagType.resourceType);
          break;
        case TagType.resourceType:
          _selectedTags.remove(TagType.resourceType);
          break;
        default:
          break;
      }
    });
    _updateSelection();
  }

  void _clearAllSelections() {
    setState(() {
      _selectedTags.clear();
    });
    _updateSelection();
  }

  void _updateSelection() {
    final tagIds = _selectedTags.values
        .where((tag) => tag != null)
        .map((tag) => tag!.id)
        .toList();
    
    // Build filter map for API
    final tagFilters = <String, String>{};
    if (_selectedTags[TagType.grade] != null) {
      tagFilters['grade'] = _selectedTags[TagType.grade]!.name;
    }
    if (_selectedTags[TagType.subject] != null) {
      tagFilters['subject'] = _selectedTags[TagType.subject]!.name;
    }
    if (_selectedTags[TagType.medium] != null) {
      tagFilters['medium'] = _selectedTags[TagType.medium]!.name;
    }
    if (_selectedTags[TagType.resourceType] != null) {
      tagFilters['resourceType'] = _selectedTags[TagType.resourceType]!.name;
    }
    
    widget.onTagsSelected(tagIds, tagFilters);
  }
}
