import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/cache_manager.dart';
import '../../shared/models/sutra.dart';
import '../../shared/models/story.dart';
import '../../shared/models/learning_path.dart';
import '../../shared/models/glossary_term.dart';
import 'home_repository.dart';

final homeRepositoryProvider = Provider((ref) {
  return HomeRepository(ApiClient(), CacheManager());
});

final homeControllerProvider =
    AsyncNotifierProvider<HomeController, HomeState>(
        () => HomeController());

class HomeState {
  final List<Sutra> sutras;
  final List<Story> stories;
  final List<LearningPath> paths;
  final List<GlossaryTerm> terms;
  final bool isFromCache;

  const HomeState({
    this.sutras = const [],
    this.stories = const [],
    this.paths = const [],
    this.terms = const [],
    this.isFromCache = false,
  });
}

class HomeController extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    final repo = ref.read(homeRepositoryProvider);
    // Try cache first
    final cached = await repo.getCachedHome();
    if (cached['sutras'] != null) {
      // Return cached immediately, then refresh in background
      ref.read(homeRepositoryProvider).getRecentSutras();
      return HomeState(
        sutras: cached['sutras'] as List<Sutra>,
        stories: (cached['stories'] as List<Story>?) ?? [],
        paths: (cached['paths'] as List<LearningPath>?) ?? [],
        terms: (cached['terms'] as List<GlossaryTerm>?) ?? [],
        isFromCache: true,
      );
    }
    // No cache — fetch all
    final results = await Future.wait([
      repo.getRecentSutras(),
      repo.getRecentStories(),
      repo.getLearningPaths(),
      repo.getPopularTerms(),
    ]);
    return HomeState(
      sutras: results[0] as List<Sutra>,
      stories: results[1] as List<Story>,
      paths: results[2] as List<LearningPath>,
      terms: results[3] as List<GlossaryTerm>,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(homeRepositoryProvider);
      final results = await Future.wait([
        repo.getRecentSutras(),
        repo.getRecentStories(),
        repo.getLearningPaths(),
        repo.getPopularTerms(),
      ]);
      return HomeState(
        sutras: results[0] as List<Sutra>,
        stories: results[1] as List<Story>,
        paths: results[2] as List<LearningPath>,
        terms: results[3] as List<GlossaryTerm>,
      );
    });
  }
}
