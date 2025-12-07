import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resource_model.dart';
import '../models/tag_model.dart';
import '../repositories/library_repository.dart';

// Dio provider
final _dioProvider = Provider<Dio>((ref) {
  return Dio();
});

// Export repository provider for use in other features
final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  final dio = ref.watch(_dioProvider);
  return LibraryRepository(dio: dio);
});

/// Hierarchy provider
final hierarchyProvider = FutureProvider<List<TagHierarchyNode>>((ref) async {
  final repository = ref.watch(libraryRepositoryProvider);
  return repository.getHierarchy();
});

/// Browse resources state
class BrowseState {
  final List<ResourceModel> resources;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final List<String> selectedTagIds;
  final String? searchQuery;

  BrowseState({
    this.resources = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.selectedTagIds = const [],
    this.searchQuery,
  });

  BrowseState copyWith({
    List<ResourceModel>? resources,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasMore,
    List<String>? selectedTagIds,
    String? searchQuery,
  }) {
    return BrowseState(
      resources: resources ?? this.resources,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Browse resources notifier
class BrowseNotifier extends StateNotifier<BrowseState> {
  final LibraryRepository _repository;

  BrowseNotifier(this._repository) : super(BrowseState());

  /// Load initial resources
  Future<void> loadResources({
    List<String>? tagIds,
    String? search,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = BrowseState(
        selectedTagIds: tagIds ?? [],
        searchQuery: search,
        isLoading: true,
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final response = await _repository.browseResources(
        search: search,
        page: 1,
        limit: 20,
      );

      state = state.copyWith(
        resources: response.data,
        currentPage: 1,
        hasMore: response.hasMore,
        isLoading: false,
        selectedTagIds: tagIds ?? [],
        searchQuery: search,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Load more resources (pagination)
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final response = await _repository.browseResources(
        search: state.searchQuery,
        page: nextPage,
        limit: 20,
      );

      state = state.copyWith(
        resources: [...state.resources, ...response.data],
        currentPage: nextPage,
        hasMore: response.hasMore,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoadingMore: false,
      );
    }
  }

  /// Filter by tags
  Future<void> filterByTags(List<String> tagIds) async {
    await loadResources(tagIds: tagIds, search: state.searchQuery, refresh: true);
  }

  /// Search resources
  Future<void> search(String query) async {
    await loadResources(
      tagIds: state.selectedTagIds.isEmpty ? null : state.selectedTagIds,
      search: query,
      refresh: true,
    );
  }

  /// Clear filters
  Future<void> clearFilters() async {
    await loadResources(refresh: true);
  }
}

/// Browse resources provider
final browseProvider = StateNotifierProvider<BrowseNotifier, BrowseState>((ref) {
  return BrowseNotifier(ref.watch(libraryRepositoryProvider));
});

/// Recent resources provider
final recentResourcesProvider = FutureProvider<List<ResourceModel>>((ref) async {
  final repository = ref.watch(libraryRepositoryProvider);
  return repository.getRecentResources(limit: 10);
});

/// Popular resources provider
final popularResourcesProvider = FutureProvider<List<ResourceModel>>((ref) async {
  final repository = ref.watch(libraryRepositoryProvider);
  return repository.getPopularResources(limit: 10);
});

/// Resource detail provider
final resourceDetailProvider = FutureProvider.family<ResourceModel, String>((ref, id) async {
  final repository = ref.watch(libraryRepositoryProvider);
  return repository.getResourceById(id);
});
