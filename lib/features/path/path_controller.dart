import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/cache_manager.dart';
import '../../shared/models/learning_path.dart';
import '../../shared/models/path_step.dart';
import 'path_repository.dart';

final pathRepositoryProvider =
    Provider((ref) => PathRepository(ref.watch(apiClientProvider), CacheManager()));

// Path list controller
final pathListControllerProvider =
    AsyncNotifierProvider<PathListController, PathListState>(
        () => PathListController());

class PathListState {
  final List<LearningPath> paths;
  const PathListState({this.paths = const []});
}

class PathListController extends AsyncNotifier<PathListState> {
  @override
  Future<PathListState> build() async {
    final repo = ref.read(pathRepositoryProvider);
    final result = await repo.getPaths();
    return PathListState(paths: result.items);
  }
}

// Path detail state
class PathDetailState {
  final LearningPath path;
  final List<PathStep> steps;
  const PathDetailState({required this.path, required this.steps});
}

// Path detail controller
final pathDetailControllerProvider =
    AsyncNotifierProvider.family<PathDetailController, PathDetailState, String>(
        () => PathDetailController());

class PathDetailController
    extends FamilyAsyncNotifier<PathDetailState, String> {
  @override
  Future<PathDetailState> build(String slug) async {
    final repo = ref.read(pathRepositoryProvider);
    final result = await repo.getPathDetail(slug);
    return PathDetailState(path: result.path, steps: result.steps);
  }
}
