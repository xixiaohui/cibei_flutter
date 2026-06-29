import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/cache_manager.dart';
import '../../shared/models/sutra.dart';
import '../../shared/models/sutra_content.dart';
import 'sutra_repository.dart';

final sutraRepositoryProvider =
    Provider((ref) => SutraRepository(ApiClient(), CacheManager()));

// Sutra list controller
final sutraListControllerProvider = AsyncNotifierProvider.family<
    SutraListController, SutraListState, String?>(() => SutraListController());

class SutraListState {
  final List<Sutra> sutras;
  final int page;
  final int totalPages;
  final bool isLoadingMore;
  const SutraListState(
      {this.sutras = const [],
      this.page = 1,
      this.totalPages = 1,
      this.isLoadingMore = false});
}

class SutraListController extends FamilyAsyncNotifier<SutraListState, String?> {
  @override
  Future<SutraListState> build(String? category) async {
    final repo = ref.read(sutraRepositoryProvider);
    final result = await repo.getSutras(category: category);
    return SutraListState(
        sutras: result.items,
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
    state = AsyncData(SutraListState(
        sutras: current.sutras,
        page: current.page,
        totalPages: current.totalPages,
        isLoadingMore: true));
    final repo = ref.read(sutraRepositoryProvider);
    final nextPage = current.page + 1;
    final result = await repo.getSutras(category: arg, page: nextPage);
    state = AsyncData(SutraListState(
      sutras: [...current.sutras, ...result.items],
      page: result.page,
      totalPages: result.totalPages,
    ));
  }
}

// Sutra detail controller
final sutraDetailControllerProvider =
    AsyncNotifierProvider.family<SutraDetailController, Sutra, String>(
        () => SutraDetailController());

class SutraDetailController extends FamilyAsyncNotifier<Sutra, String> {
  @override
  Future<Sutra> build(String slug) async {
    return ref.read(sutraRepositoryProvider).getSutraDetail(slug);
  }
}

// Sutra content controller
final sutraContentControllerProvider = AsyncNotifierProvider.family<
    SutraContentController, SutraContent, String>(
    () => SutraContentController());

class SutraContentController
    extends FamilyAsyncNotifier<SutraContent, String> {
  @override
  Future<SutraContent> build(String slug) async {
    return ref.read(sutraRepositoryProvider).getSutraContent(slug);
  }
}

// Categories
final sutraCategoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(sutraRepositoryProvider).getCategories();
});
