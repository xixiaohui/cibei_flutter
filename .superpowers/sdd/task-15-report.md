# Task 15 Report: Search Feature

**Status:** Complete
**Commit:** bf81d81

## Files Created

1. `lib/features/search/search_repository.dart` — SearchRepository class with `search(query, type?)`, `getRecentSearches()`, `saveRecentSearch(query)`, and `clearRecentSearches()`. Uses ApiClient for API calls and CacheManager with HiveBoxes.searchHistory for local persistence.

2. `lib/features/search/search_controller.dart` — Riverpod providers: `searchRepositoryProvider`, `searchResultsProvider` (StateNotifierProvider.family by query), and `recentSearchesProvider` (FutureProvider). SearchNotifier guards against empty queries and saves searches to history.

3. `lib/features/search/search_page.dart` — ConsumerStatefulWidget with:
   - TextField in AppBar with autofocus and search textInputAction
   - Recent searches list with clear button (when query is empty)
   - Search results grouped with type icons (sutra/menu_book, glossary/bookmark, story/auto_stories, encyclopedia/account_balance)
   - Tapping a result navigates to `/$type/$slug`

## Files Modified

4. `lib/core/router/app_router.dart` — Replaced `_PlaceholderPage('Search')` with `SearchPage()` import and usage.

## Verification

- `flutter analyze` — No issues found

## Refactor: StateNotifier to FamilyAsyncNotifier

**Commit:** (see latest)

Replaced `StateNotifierProvider.family` + `StateNotifier<AsyncValue<SearchResponse>>` with `AsyncNotifierProvider.family` + `FamilyAsyncNotifier<SearchResponse, String>`, matching the pattern used by all other controllers in the project (encyclopedia, dictionary, sutra, stories).

### Changes in `lib/features/search/search_controller.dart`

- `searchResultsProvider`: Changed from `StateNotifierProvider.family<SearchNotifier, AsyncValue<SearchResponse>, String>` to `AsyncNotifierProvider.family<SearchNotifier, SearchResponse, String>`
- `SearchNotifier`: Changed from `StateNotifier<AsyncValue<SearchResponse>>` to `FamilyAsyncNotifier<SearchResponse, String>`
- Removed manual `AsyncLoading`/`AsyncValue.guard` state management — the `build(String query)` method now returns `Future<SearchResponse>` directly and the framework handles loading/error states automatically
- `search_page.dart` required no changes — it already reads results as `AsyncValue<SearchResponse>` via the provider

### Verification

- `flutter analyze` — No issues found
