# Task 14 Report: Favorites Feature

**Date:** 2026-06-29
**Commit:** 83cb124

## Summary
Implemented the Favorites feature with repository, controller, favorites list page, favorite toggle button on SutraDetailPage, and router update. All changes pass `flutter analyze` with zero issues.

## Files Created

### 1. `lib/features/favorites/favorites_repository.dart`
- `getFavorites()` — fetches all favorites via `GET /api/favorites`
- `toggleFavorite()` — toggles favorite status via `POST /api/favorites`, returns boolean
- `removeFavorite(id)` — deletes a favorite via `DELETE /api/favorites/{id}`
- `checkFavorite(type, slug)` — checks favorite status via `GET /api/favorites/check`

### 2. `lib/features/favorites/favorites_controller.dart`
- `favoritesRepositoryProvider` — provides `FavoritesRepository`
- `favoritesProvider` — `AsyncNotifierProvider` for the favorites list; `FavoritesController` with `toggle()` and `remove()` methods that invalidate self
- `favoriteStatusProvider` — `FutureProvider.family<bool, ({String type, String slug})>` for per-item favorite status

### 3. `lib/features/favorites/favorites_page.dart`
- `ConsumerWidget` showing favorites list with loading/error/empty states
- Type icons: sutra -> menu_book, glossary -> bookmark, story -> auto_stories, encyclopedia -> account_balance
- `Dismissible` swipe-to-delete with red background and delete icon
- Tap navigates to detail page via `'/${fav.type}/${fav.slug}'`

## Files Modified

### 4. `lib/features/sutra/sutra_detail_page.dart`
- Added favorite button (heart icon) in AppBar actions using `Consumer`
- Watches `favoriteStatusProvider` to show filled/outlined heart with red color
- On tap: calls `toggleFavorite` and invalidates the status provider
- Gracefully handles 401 errors (API returns 401 -> AuthException -> "登录已过期，请重新登录")

### 5. `lib/core/router/app_router.dart`
- Added import for `FavoritesPage`
- Replaced `_PlaceholderPage('Favorites')` with `const FavoritesPage()`

## Verification
- `flutter analyze`: No issues found
- Error handling: 401 responses from the API are mapped to `AuthException` via `ErrorInterceptor`, showing user-facing message "登录已过期，请重新登录"

---

## Fix: Dismissible Error Handling & Toggle Logic (2026-06-29)

### Issue 1: Dismissible error handling (`favorites_page.dart`)

Replaced `onDismissed` with `confirmDismiss` in the `Dismissible` widget. The `confirmDismiss` callback awaits the async `remove()` call and only returns `true` (allowing the dismiss animation) if the server confirms deletion. On failure, it shows a `SnackBar` with the error message and returns `false` (keeping the item in the list). A `context.mounted` guard prevents using the `BuildContext` after the async gap.

### Issue 2a: Controller toggle invalidation (`favorites_controller.dart`)

Added `ref.invalidate(favoriteStatusProvider((type: type, slug: slug)))` to `FavoritesController.toggle()` so the per-item favorite status is invalidated alongside the favorites list. This ensures the heart icon in the detail page updates immediately after toggling.

### Issue 2b: Use controller toggle in detail page (`sutra_detail_page.dart`)

Replaced the direct `ref.read(favoritesRepositoryProvider).toggleFavorite(...)` call with `ref.read(favoritesProvider.notifier).toggle(...)`. Removed the explicit `ref.invalidate(favoriteStatusProvider(...))` line since the controller now handles that invalidation in its `toggle()` method.

### Post-Fix Verification

- `flutter analyze`: No issues found
