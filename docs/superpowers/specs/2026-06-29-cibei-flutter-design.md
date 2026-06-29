# Cibei Space Mobile — Design Document

**Date:** 2026-06-29  
**Project:** Cibei Space Mobile Flutter App  
**Package:** com.xxh.cibei  
**Platforms:** Android, iOS  

---

## 1. Overview

Cibei Space Mobile is the official mobile client for Cibei Space (https://cibei.space). A modern Buddhist learning app focused on reading experience, collections, notes, AI Q&A, offline caching, and push notifications. All business data comes from the Web REST API; the mobile app does not maintain independent data structures.

### Product Goal

打造中文体验最好的佛学学习 App — The best Chinese-language Buddhist learning app experience. Reading experience better than Kindle. Design style close to Apple Books. Content depth reaching CBETA as an entry-level learning tool. AI as a personal Buddhist learning assistant, not a religious consulting tool.

---

## 2. Architecture

### 2.1 High-Level Pattern: Clean Architecture

```
┌─────────────────────────────────────────────────┐
│  UI Layer (Pages + Widgets)                      │
│  StatelessWidget preferred, reads Riverpod       │
├─────────────────────────────────────────────────┤
│  Controller Layer (Riverpod Providers)           │
│  AsyncNotifier / StateNotifier for business logic│
├─────────────────────────────────────────────────┤
│  Repository Layer                                │
│  Abstraction over data sources, caching logic    │
├─────────────────────────────────────────────────┤
│  Data Layer (API + Local Storage)                │
│  ApiClient (Dio) + Hive boxes                    │
├─────────────────────────────────────────────────┤
│  Models (Freezed entities)                       │
│  Pure data, JSON serialization                   │
└─────────────────────────────────────────────────┘
```

### 2.2 Directory Structure

```
lib/
  core/
    api/             → ApiClient, ApiEndpoints, interceptors
    network/         → Dio setup, retry policy, error handling
    storage/         → Hive initialization, cache manager, box names
    constants/       → App-wide constants, API base URL
    theme/           → AppTheme, colors, typography, dark mode
    router/           → GoRouter configuration, route names
    utils/           → Date formatters, validators, extensions
    widgets/         → Shared widgets (ReadingToolbar, LoadingIndicator, ErrorWidget, etc.)
    services/        → Firebase Cloud Messaging, Analytics
  features/
    home/            → home_page, home_controller, home_repository
    sutra/           → list_page, detail_page, reading_page, search
    dictionary/      → list_page, detail_page, search
    encyclopedia/    → list_page, detail_page
    stories/         → list_page, detail_page
    notes/           → my_notes_page, highlights
    ai/              → chat_page, history_page
    profile/         → login_page, profile_page, settings_page
    favorites/       → favorites_page (shared across features)
    search/          → global_search_page
  shared/
    models/          → All Freezed models (Sutra, Glossary, Encyclopedia, Story, etc.)
    components/      → Shared UI components (cards, lists, buttons)
    extensions/      → Dart extensions (String, DateTime, BuildContext)
  app.dart           → App widget with ProviderScope
  main.dart          → Entry point, Hive + Firebase init
```

### 2.3 Data Flow

```
Page (StatelessWidget)
  ↓ ref.watch(provider)
Riverpod Provider (AsyncNotifier)
  ↓ calls
Repository (abstracts data source)
  ↓ delegates to
ApiClient (remote HTTP) + HiveCacheManager (local)
  ↓                        ↓
REST API               Hive Boxes
```

### 2.4 State Management — Riverpod

- **AsyncNotifierProvider** for all async data fetches (list pages, detail pages)
- **StateNotifierProvider** for UI state (auth state, theme mode, search query)
- **Provider** for injected dependencies (ApiClient, Repositories, Hive boxes)
- No God Widgets; widgets ≤ 300 lines

---

## 3. Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Framework | Flutter Stable (Dart 3) | Cross-platform mobile |
| State | flutter_riverpod | Reactive state management |
| Routing | go_router | Declarative routing with bottom nav |
| Network | dio + dio_cookie_manager + cookie_jar | HTTP client with cookie-based auth |
| Models | freezed + json_serializable | Immutable models with code generation |
| Local Storage | hive + hive_flutter | Offline cache, user preferences |
| Secure Storage | flutter_secure_storage | Token/sensitive data storage |
| Images | cached_network_image | Image caching with placeholders |
| Markdown | flutter_markdown | Sutra content rendering |
| Firebase | firebase_core + firebase_messaging + firebase_analytics | Push + analytics |
| Sharing | share_plus | System share sheet |
| URLs | url_launcher | External links |
| Connectivity | connectivity_plus | Network status detection |
| Device Info | device_info_plus + package_info_plus | Platform detection |
| i18n | intl | Chinese + English localization |

---

## 4. Core Layer Design

### 4.1 API Client (`core/api/`)

```dart
class ApiClient {
  final Dio _dio;
  
  // Standard HTTP methods
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParams});
  Future<Response<T>> post<T>(String path, {dynamic data});
  Future<Response<T>> put<T>(String path, {dynamic data});
  Future<Response<T>> delete<T>(String path);
}

class ApiEndpoints {
  static const String baseUrl = 'https://cibei.space';
  static const String home = '/api/home';
  static const String sutras = '/api/sutras';
  static const String glossary = '/api/glossary';
  static const String encyclopedia = '/api/encyclopedia';
  static const String stories = '/api/stories';
  static const String timeline = '/api/timeline';
  static const String paths = '/api/paths';
  static const String favorites = '/api/favorites';
  static const String search = '/api/search';
  static const String poster = '/api/poster';
  static const String aiChat = '/api/ai/chat';
  
  // Auth
  static const String signUp = '/api/auth/sign-up/email';
  static const String signIn = '/api/auth/sign-in/email';
  static const String signOut = '/api/auth/sign-out';
  static const String getSession = '/api/auth/get-session';
}
```

**Interceptors (Dio):**
- `AuthInterceptor` — Cookie management via cookie_jar
- `RetryInterceptor` — Exponential backoff, max 3 retries
- `LoggingInterceptor` — Request/response logging in debug mode
- `ErrorInterceptor` — Unified error mapping to domain exceptions

**Timeout:** 30s connect, 30s read/write

### 4.2 Theme (`core/theme/`)

```
Colors:
  Primary:     #C9A24A (warm gold)
  Background:  #FFFFFF
  Dark BG:     #111111
  Text:        #000000 (light) / #FFFFFF (dark)
  Secondary:   #888888
  Divider:     #EEEEEE

Typography:
  iOS:     SF Pro
  Android: Noto Sans SC
  Title:   24-34sp
  Body:    18sp
  Line Height: 1.8

Design Principles:
  - Apple Design Award style
  - Quiet, elegant, reading-first, minimal
  - Generous whitespace
  - Large fonts
  - Soft animations (no gradient backgrounds, complex shadows, flashy animations)
  - No excessive gold religious decorations
```

### 4.3 Router (`core/router/`)

```dart
GoRouter with ShellRoute for bottom navigation:

Tabs (max 5):
  /              → HomePage
  /library       → LibraryPage (sutras + dictionary + encyclopedia)
  /stories       → StoriesPage
  /ai            → AiChatPage
  /profile       → ProfilePage

Nested routes:
  /sutra/:slug           → SutraDetailPage
  /sutra/:slug/read      → SutraReadingPage
  /dictionary/:slug      → DictionaryDetailPage
  /encyclopedia/:slug    → EncyclopediaDetailPage
  /story/:slug           → StoryDetailPage
  /search                → SearchPage
  /favorites             → FavoritesPage
  /notes                 → NotesPage
  /settings              → SettingsPage
  /login                 → LoginPage
  /paths/:slug           → LearningPathPage
  /timeline              → TimelinePage
```

### 4.4 Storage (`core/storage/`)

```dart
class CacheManager {
  // Hive boxes
  // Cache strategy: LRU with 500MB max
  // Boxes: home_cache, sutra_cache, glossary_cache, 
  //        story_cache, reading_history, recent_search,
  //        user_settings, favorites_cache
}
```

---

## 5. Feature Design

### 5.1 Home (`features/home/`)

**Content:** Today's sutra, Buddhist stories, learning paths, AI recommendations, popular glossary terms, recent updates

**API:** `GET /api/home` (stub — uses `/api/sutras`, `/api/stories`, `/api/paths` individually until `/api/home` endpoint exists)

**Components:**
- `HomePage` — Scrollable aggregate feed
- `TodaySutraCard` — Large hero card
- `StoryCarousel` — Horizontal scrolling stories
- `LearningPathCard` — Path cards with icon + progress
- `PopularTermsList` — Trending glossary terms

**Offline:** Full home page cached in Hive, refreshed on pull-to-refresh

### 5.2 Sutras (`features/sutra/`)

**Pages:**
- `SutraListPage` — Paginated list with category filter
- `SutraDetailPage` — Metadata + actions (read, favorite, share, poster)
- `SutraReadingPage` — Full Markdown reading with adjustable font/spacing/width/night mode
- `SutraSearchPage` — Search within sutras

**API:** `GET /api/sutras`, `GET /api/sutras/{slug}`, `GET /api/sutras/{slug}/content`, `GET /api/sutras/categories`

**Components:**
- `SutraCard` — List card (title, translator, dynasty, category)
- `ReadingToolbar` — Font size, line spacing, width, night mode controls
- `SutraPosterButton` — Generate and share poster

### 5.3 Dictionary (`features/dictionary/`)

**Pages:**
- `DictionaryListPage` — Paginated with letter filter
- `DictionaryDetailPage` — Term, Sanskrit, definition, related terms

**API:** `GET /api/glossary`, `GET /api/glossary/{slug}`

**Components:**
- `GlossaryCard` — Term card
- `RelatedTermsList` — Horizontal chips of related terms

### 5.4 Encyclopedia (`features/encyclopedia/`)

**Pages:**
- `EncyclopediaListPage` — Paginated with category filter
- `EncyclopediaDetailPage` — Full content

**API:** `GET /api/encyclopedia`, `GET /api/encyclopedia/{slug}`, `GET /api/encyclopedia/categories`

### 5.5 Stories (`features/stories/`)

**Pages:**
- `StoryListPage` — Paginated with category filter
- `StoryDetailPage` — Full story with moral, source sutra, related recommendations

**API:** `GET /api/stories`, `GET /api/stories/{slug}`, `GET /api/stories/categories`

**Components:**
- `StoryCard` — Card with category badge
- `MoralQuote` — Highlighted moral/lesson box

### 5.6 AI Chat (`features/ai/`)

**Pages:**
- `AiChatPage` — Chat interface with disclaimer
- `AiHistoryPage` — Previous chat sessions

**API:** `POST /api/ai/chat` (mock for now — endpoint not yet implemented on backend)

**Components:**
- `AiMessage` — Chat bubble with sutra references
- `AiDisclaimer` — "AI 内容仅供学习参考" warning
- `AiSuggestionChips` — Suggested questions

**MVP note:** Store chat history locally in Hive. Disclaimer always visible.

### 5.7 Notes (`features/notes/`)

**Pages:**
- `NotesListPage` — My notes, highlights, excerpts
- `NoteDetailPage` — Edit/view single note

**API:** Mock for now (no notes API yet in backend)

**Storage:** Hive-based local notes with sync-ready structure

### 5.8 Profile & Auth (`features/profile/`)

**Pages:**
- `LoginPage` — Email login/register form
- `ProfilePage` — Reading stats, collections, notes overview
- `SettingsPage` — Theme, font, cache management, about

**Auth Flow:**
1. User enters email + password
2. POST to `/api/auth/sign-in/email` or `/api/auth/sign-up/email`
3. Session cookie stored via cookie_jar
4. Subsequent requests automatically include cookie
5. Session validated via `GET /api/auth/get-session`

**Components:**
- `LoginForm` — Email + password + submit
- `ReadingStatsCard` — Stats display
- `SettingsSection` — Grouped settings list

### 5.9 Favorites (`features/favorites/`)

**API:** `GET /api/favorites`, `POST /api/favorites`, `DELETE /api/favorites/{id}`, `GET /api/favorites/check`

**Behavior:** Toggle favorite from any detail page. Favorites synced with server when logged in, stored locally when offline.

---

## 6. Models (Freezed)

All models use `@freezed` with `json_serializable`:

| Model | Source API | Key Fields |
|-------|-----------|------------|
| `Sutra` | `/api/sutras` | id, slug, title, titleEn, dynasty, translator, summary, category |
| `SutraContent` | `/api/sutras/{slug}/content` | slug, title, content, format |
| `GlossaryTerm` | `/api/glossary` | id, slug, term, termEn, termSanskrit, definition, relatedTerms |
| `EncyclopediaEntry` | `/api/encyclopedia` | id, slug, title, category, content |
| `Story` | `/api/stories` | id, slug, title, titleEn, category, sourceSutra, summary, content, moral, imageUrl |
| `TimelineEvent` | `/api/timeline` | id, slug, year, yearDisplay, title, description, category, location |
| `LearningPath` | `/api/paths` | id, slug, title, description, level, levelLabel, icon, stepCount |
| `PathStep` | `/api/paths/{slug}` | id, pathId, stepNumber, title, description, guidance |
| `Favorite` | `/api/favorites` | id, userId, type, slug, title, subtitle |
| `User` | auth | id, email, name, image, emailVerified |
| `Session` | auth | id, userId, token, expiresAt |
| `SearchResult` | `/api/search` | type, slug, title, excerpt, category |
| `PaginatedResponse<T>` | (generic) | items, total, page, pageSize, totalPages |
| `AiMessage` | local | role, content, references, timestamp |
| `Note` | local | id, content, sourceType, sourceSlug, highlight, timestamp |

---

## 7. Offline & Caching

### Cache Strategy

- **LRU eviction** with 500MB max
- **Cache-first** for list pages (show cached, refresh in background)
- **Network-first** for detail pages (show fresh, cache on success)

### Cached Content

| Content | Box Name | Strategy |
|---------|----------|----------|
| Home feed | `home_cache` | Cache 24h, refresh on pull |
| Sutra list | `sutra_cache` | Cache 1h, refresh on navigate |
| Sutra content | `sutra_content_cache` | Cache 7d (content rarely changes) |
| Glossary | `glossary_cache` | Cache 24h |
| Stories | `story_cache` | Cache 24h |
| Reading history | `reading_history` | Persistent |
| Search history | `search_history` | Persistent, max 50 |
| User settings | `user_settings` | Persistent |
| Favorites | `favorites_cache` | Persistent, sync with server |

---

## 8. Error Handling

### API Error Flow

```
Dio Exception
  → ErrorInterceptor maps to DomainException
    → Repository catches, returns Result<T> (success/failure)
      → Controller sets AsyncValue (data/error/loading)
        → Page shows appropriate UI (content/error/loading)
```

### Result Type

```dart
sealed class Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(AppException error) = Failure<T>;
}
```

### AppException Hierarchy

```dart
sealed class AppException implements Exception {
  String get userMessage; // Localized, user-facing message
}

class NetworkException extends AppException { ... }
class AuthException extends AppException { ... }
class ServerException extends AppException { ... }
class CacheException extends AppException { ... }
class NotFoundException extends AppException { ... }
```

---

## 9. Accessibility

- Dynamic Type support throughout
- VoiceOver / TalkBack labels on all interactive elements
- High contrast mode
- Dark mode with full coverage
- Landscape support on all pages
- Minimum touch target 44pt

---

## 10. Performance Targets

- First open (home): < 2 seconds
- Scrolling: 60 FPS (use Sliver lists)
- Images: Lazy loading with cached_network_image
- Lists: Infinite scroll pagination
- Sliver-based layouts for all list pages

---

## 11. Testing Strategy

| Test Type | Scope | Framework |
|-----------|-------|-----------|
| Unit tests | Models, Repositories, Controllers | flutter_test |
| Widget tests | Pages, Widgets | flutter_test |
| Golden tests | Theme, key pages | flutter_test + golden_toolkit |
| Integration tests | Critical flows | integration_test |
| API tests | ApiClient methods | flutter_test + mockito |

---

## 12. Build Order (Implementation Sequence)

1. **Foundation** — Flutter project scaffold, pubspec.yaml with all dependencies
2. **Core Models** — All Freezed models with JSON serialization
3. **Core API** — ApiClient, interceptors, ApiEndpoints
4. **Core Theme** — AppTheme, colors, typography, dark mode
5. **Core Router** — GoRouter with ShellRoute and all routes
6. **Core Storage** — Hive setup, CacheManager
7. **Core Widgets** — Shared components (buttons, cards, loading, error)
8. **Home Feature** — Repository → Controller → Page → Widgets
9. **Sutras Feature** — List → Detail → Reading pages
10. **Stories Feature** — List → Detail pages
11. **Dictionary Feature** — List → Detail pages
12. **Encyclopedia Feature** — List → Detail pages
13. **Auth + Profile** — Login, profile, settings
14. **Favorites** — List, toggle, sync
15. **Search** — Global search
16. **AI Chat** — Mock chat interface
17. **Notes** — Local notes
18. **Offline & Polish** — Cache strategies, error handling, accessibility

---

## 13. Open Items / Future

- `/api/home` endpoint — currently not implemented; use individual endpoints as workaround
- `/api/ai/chat` endpoint — not yet in API; mock for now
- Notes sync API — not yet available; local-only for MVP
- Google / Apple / WeChat login — future auth methods
- GraphQL support — future
- iPad / MacOS / Windows / Linux / Web — future platforms
- Wear OS / Apple Watch — future
