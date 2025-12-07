import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/api_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../data/models/resource_model.dart';
import '../../data/providers/library_provider.dart';
import '../../../resources/presentation/screens/pdf_viewer_screen.dart';

class ResourceDetailScreen extends ConsumerWidget {
  final String resourceId;

  const ResourceDetailScreen({
    super.key,
    required this.resourceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourceAsync = ref.watch(resourceDetailProvider(resourceId));

    return Scaffold(
      body: resourceAsync.when(
        data: (resource) => _buildContent(context, ref, resource),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Failed to load resource',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(resourceDetailProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, ResourceModel resource) {
    final streamingUrl = ref
        .read(libraryRepositoryProvider)
        .getStreamingUrl(resource.id);

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              resource.title,
              style: const TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            background: resource.thumbnail != null
                ? Image.network(
                    resource.thumbnail!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: AppColors.primary,
                    child: const Icon(
                      Icons.picture_as_pdf,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareResource(resource),
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _downloadResource(context, resource),
            ),
          ],
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                if (resource.description != null) ...[
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resource.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                ],

                // Metadata
                _MetadataRow(
                  icon: Icons.person,
                  label: 'Uploader',
                  value: resource.uploader?.name ?? 'Unknown',
                ),
                _MetadataRow(
                  icon: Icons.schedule,
                  label: 'Uploaded',
                  value: timeago.format(resource.createdAt),
                ),
                _MetadataRow(
                  icon: Icons.visibility,
                  label: 'Views',
                  value: '${resource.viewCount}',
                ),
                _MetadataRow(
                  icon: Icons.download,
                  label: 'Downloads',
                  value: '${resource.downloadCount}',
                ),
                _MetadataRow(
                  icon: Icons.storage,
                  label: 'File Size',
                  value: resource.formattedSize,
                ),

                const SizedBox(height: 24),

                // Tags
                if (resource.tags.isNotEmpty) ...[
                  Text(
                    'Tags',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: resource.tags
                        .map((tag) => Chip(
                              label: Text(tag.name),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // View PDF Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _viewPDF(context, resource, streamingUrl),
                    icon: const Icon(Icons.visibility),
                    label: const Text('View PDF'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _viewPDF(BuildContext context, ResourceModel resource, String streamingUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(
          title: resource.title,
          streamingUrl: streamingUrl,
        ),
      ),
    );
  }

  void _shareResource(ResourceModel resource) {
    Share.share(
      'Check out this resource: ${resource.title}\n'
      '${ApiConstants.baseUrl}/resources/${resource.id}',
    );
  }

  void _downloadResource(BuildContext context, ResourceModel resource) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download started...')),
    );
    // TODO: Implement actual download functionality
  }
}

class _MetadataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetadataRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
