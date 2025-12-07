import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../data/models/tag_model.dart';
import '../../data/providers/library_provider.dart';

class HierarchySelector extends ConsumerStatefulWidget {
  final List<String> selectedTagIds;
  final Function(List<String>) onTagsSelected;

  const HierarchySelector({
    super.key,
    required this.selectedTagIds,
    required this.onTagsSelected,
  });

  @override
  ConsumerState<HierarchySelector> createState() => _HierarchySelectorState();
}

class _HierarchySelectorState extends ConsumerState<HierarchySelector> {
  final Map<TagType, TagModel?> _selectedTags = {};

  @override
  Widget build(BuildContext context) {
    final hierarchyAsync = ref.watch(hierarchyProvider);

    return hierarchyAsync.when(
      data: (hierarchy) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildSelector(
                context,
                'Grade',
                _selectedTags[TagType.grade],
                () => _showTagPicker(
                  context,
                  'Select Grade',
                  hierarchy,
                  TagType.grade,
                ),
              ),
              if (_selectedTags[TagType.grade] != null) ...[
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 20),
                const SizedBox(width: 8),
                _buildSelector(
                  context,
                  'Subject',
                  _selectedTags[TagType.subject],
                  () => _showTagPicker(
                    context,
                    'Select Subject',
                    _getChildren(hierarchy, _selectedTags[TagType.grade]!.id),
                    TagType.subject,
                  ),
                ),
              ],
              if (_selectedTags[TagType.subject] != null) ...[
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 20),
                const SizedBox(width: 8),
                _buildSelector(
                  context,
                  'Lesson',
                  _selectedTags[TagType.lesson],
                  () => _showTagPicker(
                    context,
                    'Select Lesson',
                    _getChildren(
                        hierarchy, _selectedTags[TagType.subject]!.id),
                    TagType.lesson,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Failed to load hierarchy',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.error),
        ),
      ),
    );
  }

  Widget _buildSelector(
    BuildContext context,
    String label,
    TagModel? selectedTag,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedTag != null
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedTag != null
                ? AppColors.primary
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedTag?.name ?? label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selectedTag != null
                        ? AppColors.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: selectedTag != null
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: selectedTag != null
                  ? AppColors.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showTagPicker(
    BuildContext context,
    String title,
    List<TagHierarchyNode> nodes,
    TagType type,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: nodes.length,
              itemBuilder: (context, index) {
                final node = nodes[index];
                final isSelected = _selectedTags[type]?.id == node.tag.id;

                return ListTile(
                  title: Text(node.tag.name),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedTags[type] = node.tag;
                      // Clear child selections
                      if (type == TagType.grade) {
                        _selectedTags.remove(TagType.subject);
                        _selectedTags.remove(TagType.lesson);
                      } else if (type == TagType.subject) {
                        _selectedTags.remove(TagType.lesson);
                      }
                    });
                    _updateSelection();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
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

  void _updateSelection() {
    final tagIds = _selectedTags.values.map((tag) => tag!.id).toList();
    widget.onTagsSelected(tagIds);
  }
}
