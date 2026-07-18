import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/cache_manager.dart';
import '../../shared/models/glossary_term.dart';
import 'dictionary_repository.dart';

final dictionaryRepositoryProvider = Provider<DictionaryRepository>(
    (ref) => DictionaryRepository(ref.watch(apiClientProvider), CacheManager()));

// Dictionary list controller
final dictionaryListControllerProvider = AsyncNotifierProvider.family<
    DictionaryListController, DictionaryListState, String?>(
    () => DictionaryListController());

class DictionaryListState {
  final List<GlossaryTerm> terms;
  final int page;
  final int totalPages;
  final bool isLoadingMore;
  const DictionaryListState(
      {this.terms = const [],
      this.page = 1,
      this.totalPages = 1,
      this.isLoadingMore = false});
}

class DictionaryListController
    extends FamilyAsyncNotifier<DictionaryListState, String?> {
  @override
  Future<DictionaryListState> build(String? letter) async {
    final repo = ref.read(dictionaryRepositoryProvider);
    final result = await repo.getTerms(letter: letter);
    return DictionaryListState(
        terms: result.items,
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
    state = AsyncData(DictionaryListState(
        terms: current.terms,
        page: current.page,
        totalPages: current.totalPages,
        isLoadingMore: true));
    final repo = ref.read(dictionaryRepositoryProvider);
    final nextPage = current.page + 1;
    final result = await repo.getTerms(letter: arg, page: nextPage);
    state = AsyncData(DictionaryListState(
      terms: [...current.terms, ...result.items],
      page: result.page,
      totalPages: result.totalPages,
    ));
  }
}

// Dictionary detail controller
final dictionaryDetailControllerProvider = AsyncNotifierProvider.family<
    DictionaryDetailController, GlossaryTerm, String>(
    () => DictionaryDetailController());

class DictionaryDetailController
    extends FamilyAsyncNotifier<GlossaryTerm, String> {
  @override
  Future<GlossaryTerm> build(String slug) async {
    return ref.read(dictionaryRepositoryProvider).getTermDetail(slug);
  }
}

/// Provides a term-name → slug lookup map for resolving related terms.
final termSlugMapProvider = FutureProvider<Map<String, String>>((ref) {
  return ref.read(dictionaryRepositoryProvider).getTermSlugMap();
});
