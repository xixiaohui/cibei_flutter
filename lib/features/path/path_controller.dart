import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/cache_manager.dart';
import '../../shared/models/learning_path.dart';
import 'path_repository.dart';

final pathRepositoryProvider =
    Provider((ref) => PathRepository(ApiClient(), CacheManager()));

// Path list controller
final pathListControllerProvider =
    AsyncNotifierProvider<PathListController, PathListState>(
        () => PathListController());

class PathListState {
  final List<LearningPath> paths;
  final int page;
  final int totalPages;
  final bool isLoadingMore;
  const PathListState(
      {this.paths = const [],
      this.page = 1,
      this.totalPages = 1,
      this.isLoadingMore = false});
}

class PathListController extends AsyncNotifier<PathListState> {
  @override
  Future<PathListState> build() async {
    final repo = ref.read(pathRepositoryProvider);
    final result = await repo.getPaths();
    return PathListState(
        paths: result.items,
        page: result.page,
        totalPages: result.totalPages);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null ||
        current.isLoadingMore ||
        current.page >= current.totalPages) {
      return;
    }
    state = AsyncData(PathListState(
        paths: current.paths,
        page: current.page,
        totalPages: current.totalPages,
        isLoadingMore: true));
    final repo = ref.read(pathRepositoryProvider);
    final nextPage = current.page + 1;
    final result = await repo.getPaths(page: nextPage);
    state = AsyncData(PathListState(
      paths: [...current.paths, ...result.items],
      page: result.page,
      totalPages: result.totalPages,
    ));
  }
}

// Path detail controller
final pathDetailControllerProvider =
    AsyncNotifierProvider.family<PathDetailController, LearningPath, String>(
        () => PathDetailController());

class PathDetailController extends FamilyAsyncNotifier<LearningPath, String> {
  @override
  Future<LearningPath> build(String slug) async {
    return ref.read(pathRepositoryProvider).getPathDetail(slug);
  }
}
