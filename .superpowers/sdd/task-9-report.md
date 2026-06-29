# Task 9: Sutras Feature Fix Report

**Date:** 2026-06-29

---

## Issue 1: ErrorDisplay missing onRetry (sutra_detail_page.dart)

**File:** `lib/features/sutra/sutra_detail_page.dart` (line ~18)

**Problem:** The error state used `ErrorDisplay` without the `onRetry` callback, so users could not retry loading after an error.

**Fix:** Added `onRetry` parameter that invalidates the `sutraDetailControllerProvider(slug)`, causing the provider to re-fetch.

```dart
// Before
error: (err, _) =>
    Scaffold(body: ErrorDisplay(message: err.toString())),

// After
error: (err, _) => Scaffold(
    body: ErrorDisplay(
        message: err.toString(),
        onRetry: () =>
            ref.invalidate(sutraDetailControllerProvider(slug)))),
```

---

## Issue 2: FilterChip scroll position not reset (sutra_list_page.dart)

**File:** `lib/features/sutra/sutra_list_page.dart` (line ~60)

**Problem:** When selecting a category filter chip, the list view scroll position was preserved, causing a confusing UX where the user stayed at the old scroll offset on a fresh filtered list.

**Fix:** Added `_scrollController.jumpTo(0)` before `setState` in the `onSelected` callback.

```dart
// Before
onSelected: (_) => setState(() => _selectedCategory = cat),

// After
onSelected: (_) {
  _scrollController.jumpTo(0);
  setState(() => _selectedCategory = cat);
},
```

---

## Issue 3: ReadingToolbar night mode (reading_toolbar.dart)

**File:** `lib/features/sutra/widgets/reading_toolbar.dart`

**Problem:** The toolbar background always used `Theme.of(context).colorScheme.surface`, ignoring the night mode toggle. Icon colors also did not adapt to a dark background, resulting in poor contrast.

**Fix:** 
- Watched `isNightModeProvider` in the build method.
- Set background to `Color(0xFF1E1E1E)` when night mode is active, otherwise using the theme surface color.
- Applied `Colors.white70` as the foreground color for icons and text when night mode is on, ensuring proper contrast.

```dart
final isNightMode = ref.watch(isNightModeProvider);
final isDark = isNightMode;
final bgColor =
    isDark ? const Color(0xFF1E1E1E) : Theme.of(context).colorScheme.surface;
final fgColor =
    isDark ? Colors.white70 : Theme.of(context).colorScheme.onSurface;
```

All `IconButton` icons now use `color: fgColor`, and the font size label text uses `fgColor` as well.

---

## Verification

```
$ flutter analyze
Analyzing cibei_flutter...
No issues found! (ran in 2.0s)
```

All three fixes pass static analysis with no errors.
