# Cibei Space Mobile — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Build the complete Cibei Space Mobile Flutter app connecting to https://cibei.space REST API.

**Architecture:** Clean Architecture + feature-first. UI (StatelessWidget + Riverpod) → Controller (AsyncNotifier) → Repository → Data (ApiClient + Hive). Freezed models, cookie-based auth, LRU offline caching.

**Tech Stack:** Flutter Stable, Dart 3, Riverpod, Dio + cookie_jar, GoRouter, Hive, Freezed + json_serializable, cached_network_image, flutter_markdown, Firebase (core+messaging+analytics), flutter_secure_storage, share_plus, url_launcher, connectivity_plus, intl.

## Global Constraints

- Base URL: `https://cibei.space` — never hardcode, use `ApiEndpoints` constants
- All models `@freezed` + `json_serializable` — no hand-written serialization
- All network through `ApiClient` — no raw Dio in features
- Pages: `StatelessWidget` default — logic in Riverpod providers
- No widget > 300 lines — extract sub-widgets
- `intl` i18n for all strings, default zh + en
- Dark mode, accessibility (Dynamic Type, VoiceOver/TalkBack) on all pages
- Bottom nav max 5: Home, Library, Stories, AI, Profile
- Package: `com.xxh.cibei`
- Design: Apple Design Award — quiet, elegant, minimal, generous whitespace, large fonts

---

## Task 1: Project Scaffold & Dependencies

**Files:**
- Create: `pubspec.yaml`
- Create: `analysis_options.yaml`
- Create: `lib/main.dart`
- Create: `lib/app.dart`

**Interfaces:**
- Produces: Flutter project ready with all 20+ dependencies, Hive init, Firebase init, ProviderScope

- [ ] **Step 1: Create Flutter project**

```bash
cd e:/workspace/claw/cibei_flutter && flutter create --org com.xxh --project-name cibei_space . --platforms android,ios
```

- [ ] **Step 2: Write pubspec.yaml with all dependencies**

Replace generated pubspec.yaml with:

```yaml
name: cibei_space
description: Cibei Space Mobile - Modern Buddhist Learning App
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  dio: ^5.7.0
  dio_cookie_manager: ^3.2.0
  cookie_jar: ^4.0.8
  go_router: ^14.2.7
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.2.2
  cached_network_image: ^3.4.1
  flutter_markdown: ^0.7.3
  firebase_core: ^3.6.0
  firebase_messaging: ^15.1.3
  firebase_analytics: ^11.3.3
  share_plus: ^10.0.3
  url_launcher: ^6.3.1
  connectivity_plus: ^6.1.0
  package_info_plus: ^8.1.0
  device_info_plus: ^11.1.1
  path_provider: ^2.1.5
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.12
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.3
  mockito: ^5.4.4
  mocktail: ^1.0.4
  golden_toolkit: ^0.15.0

flutter:
  uses-material-design: true
  assets: []
```

- [ ] **Step 3: Run flutter pub get**

```bash
cd e:/workspace/claw/cibei_flutter && flutter pub get
```

- [ ] **Step 4: Write main.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const ProviderScope(child: CibeiApp()));
}
```

- [ ] **Step 5: Write app.dart (skeleton)**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CibeiApp extends ConsumerWidget {
  const CibeiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Cibei Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Placeholder — replaced in Task 4
      darkTheme: ThemeData.dark(),
      routerConfig: null, // Placeholder — replaced in Task 5
      locale: const Locale('zh'),
      supportedLocales: const [Locale('zh'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
```

- [ ] **Step 6: Verify project builds**

```bash
cd e:/workspace/claw/cibei_flutter && flutter analyze
```

- [ ] **Step 7: Commit**

```bash
git add -A && git commit -m "feat: scaffold Flutter project with dependencies"
```

---

## Task 2: Core Models — Freezed Data Classes

**Files:**
- Create: `lib/shared/models/sutra.dart`
- Create: `lib/shared/models/sutra_content.dart`
- Create: `lib/shared/models/glossary_term.dart`
- Create: `lib/shared/models/encyclopedia_entry.dart`
- Create: `lib/shared/models/story.dart`
- Create: `lib/shared/models/timeline_event.dart`
- Create: `lib/shared/models/learning_path.dart`
- Create: `lib/shared/models/path_step.dart`
- Create: `lib/shared/models/favorite.dart`
- Create: `lib/shared/models/user.dart`
- Create: `lib/shared/models/search_result.dart`
- Create: `lib/shared/models/paginated_response.dart`
- Create: `lib/shared/models/app_exception.dart`

**Interfaces:**
- Produces: All data models with `fromJson`/`toJson`, `==`/`hashCode`, `copyWith`

- [ ] **Step 1: Create sutra model**

```dart
// lib/shared/models/sutra.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'sutra.freezed.dart';
part 'sutra.g.dart';

@freezed
class Sutra with _$Sutra {
  const factory Sutra({
    required String id,
    required String slug,
    required String title,
    String? titleEn,
    String? dynasty,
    String? translator,
    String? summary,
    String? category,
    String? cbetaId,
    String? satId,
    required String createdAt,
  }) = _Sutra;

  factory Sutra.fromJson(Map<String, dynamic> json) => _$SutraFromJson(json);
}
```

- [ ] **Step 2: Create sutra_content model**

```dart
// lib/shared/models/sutra_content.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'sutra_content.freezed.dart';
part 'sutra_content.g.dart';

@freezed
class SutraContent with _$SutraContent {
  const factory SutraContent({
    required String slug,
    required String title,
    required String content,
    @Default('markdown') String format,
  }) = _SutraContent;

  factory SutraContent.fromJson(Map<String, dynamic> json) =>
      _$SutraContentFromJson(json);
}
```

- [ ] **Step 3: Create glossary_term model**

```dart
// lib/shared/models/glossary_term.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'glossary_term.freezed.dart';
part 'glossary_term.g.dart';

@freezed
class GlossaryTerm with _$GlossaryTerm {
  const factory GlossaryTerm({
    required String id,
    required String slug,
    required String term,
    String? termEn,
    String? termSanskrit,
    required String definition,
    @Default([]) List<String> relatedTerms,
    required String createdAt,
  }) = _GlossaryTerm;

  factory GlossaryTerm.fromJson(Map<String, dynamic> json) =>
      _$GlossaryTermFromJson(json);
}
```

- [ ] **Step 4: Create encyclopedia_entry model**

```dart
// lib/shared/models/encyclopedia_entry.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'encyclopedia_entry.freezed.dart';
part 'encyclopedia_entry.g.dart';

@freezed
class EncyclopediaEntry with _$EncyclopediaEntry {
  const factory EncyclopediaEntry({
    required String id,
    required String slug,
    required String title,
    String? category,
    required String content,
    required String createdAt,
  }) = _EncyclopediaEntry;

  factory EncyclopediaEntry.fromJson(Map<String, dynamic> json) =>
      _$EncyclopediaEntryFromJson(json);
}
```

- [ ] **Step 5: Create story model**

```dart
// lib/shared/models/story.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'story.freezed.dart';
part 'story.g.dart';

@freezed
class Story with _$Story {
  const factory Story({
    required String id,
    required String slug,
    required String title,
    String? titleEn,
    required String category,
    String? sourceSutra,
    required String summary,
    required String content,
    String? moral,
    String? imageUrl,
    required String createdAt,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
```

- [ ] **Step 6: Create timeline_event, learning_path, path_step models**

```dart
// lib/shared/models/timeline_event.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'timeline_event.freezed.dart';
part 'timeline_event.g.dart';

@freezed
class TimelineEvent with _$TimelineEvent {
  const factory TimelineEvent({
    required String id,
    required String slug,
    required int year,
    required String yearDisplay,
    required String title,
    required String description,
    required String category,
    String? location,
    required String createdAt,
  }) = _TimelineEvent;

  factory TimelineEvent.fromJson(Map<String, dynamic> json) =>
      _$TimelineEventFromJson(json);
}
```

```dart
// lib/shared/models/learning_path.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'learning_path.freezed.dart';
part 'learning_path.g.dart';

@freezed
class LearningPath with _$LearningPath {
  const factory LearningPath({
    required String id,
    required String slug,
    required String title,
    required String description,
    required String level,
    required String levelLabel,
    required String icon,
    required int stepCount,
    required String createdAt,
  }) = _LearningPath;

  factory LearningPath.fromJson(Map<String, dynamic> json) =>
      _$LearningPathFromJson(json);
}
```

```dart
// lib/shared/models/path_step.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'path_step.freezed.dart';
part 'path_step.g.dart';

@freezed
class PathStep with _$PathStep {
  const factory PathStep({
    required String id,
    required String pathId,
    required int stepNumber,
    required String title,
    String? description,
    String? guidance,
    @Default([]) List<String> relatedSutraSlugs,
    @Default([]) List<String> relatedTermSlugs,
    required String createdAt,
  }) = _PathStep;

  factory PathStep.fromJson(Map<String, dynamic> json) =>
      _$PathStepFromJson(json);
}
```

- [ ] **Step 7: Create favorite, user, search_result, paginated_response models**

```dart
// lib/shared/models/favorite.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'favorite.freezed.dart';
part 'favorite.g.dart';

@freezed
class Favorite with _$Favorite {
  const factory Favorite({
    required String id,
    required String userId,
    required String type, // sutra | glossary | story | encyclopedia
    required String slug,
    required String title,
    String? subtitle,
    required String createdAt,
  }) = _Favorite;

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);
}
```

```dart
// lib/shared/models/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    @Default(false) bool emailVerified,
    String? name,
    String? image,
    required String createdAt,
    String? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class Session with _$Session {
  const factory Session({
    required String id,
    required String userId,
    required String token,
    required String expiresAt,
    String? ipAddress,
    String? userAgent,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String token,
    required User user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

@freezed
class SessionResponse with _$SessionResponse {
  const factory SessionResponse({
    Session? session,
    User? user,
  }) = _SessionResponse;

  factory SessionResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionResponseFromJson(json);
}
```

```dart
// lib/shared/models/search_result.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'search_result.freezed.dart';
part 'search_result.g.dart';

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required String type,
    required String slug,
    required String title,
    required String excerpt,
    String? category,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}

@freezed
class SearchResponse with _$SearchResponse {
  const factory SearchResponse({
    @Default([]) List<SearchResult> results,
    required int total,
  }) = _SearchResponse;

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);
}
```

```dart
// lib/shared/models/paginated_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'paginated_response.freezed.dart';
part 'paginated_response.g.dart';

@freezed
class PaginatedResponse with _$PaginatedResponse {
  const factory PaginatedResponse({
    @Default([]) List<dynamic> items,
    required int total,
    required int page,
    required int pageSize,
    required int totalPages,
  }) = _PaginatedResponse;

  factory PaginatedResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginatedResponseFromJson(json);
}
```

```dart
// lib/shared/models/app_exception.dart
sealed class AppException implements Exception {
  String get userMessage;
  const AppException();
}

class NetworkException extends AppException {
  @override
  String get userMessage => '网络连接失败，请检查网络设置';
  const NetworkException();
}

class AuthException extends AppException {
  @override
  String get userMessage => '登录已过期，请重新登录';
  const AuthException();
}

class ServerException extends AppException {
  final String message;
  @override
  String get userMessage => message;
  const ServerException(this.message);
}

class NotFoundException extends AppException {
  @override
  String get userMessage => '内容未找到';
  const NotFoundException();
}

class CacheException extends AppException {
  @override
  String get userMessage => '缓存读取失败';
  const CacheException();
}
```

- [ ] **Step 8: Run build_runner to generate code**

```bash
cd e:/workspace/claw/cibei_flutter && dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 9: Verify — analyze should pass**

```bash
cd e:/workspace/claw/cibei_flutter && flutter analyze
```

- [ ] **Step 10: Commit**

```bash
git add -A && git commit -m "feat: add all Freezed data models"
```

---

## Task 3: Core API Layer — ApiClient + Interceptors + Endpoints

**Files:**
- Create: `lib/core/constants/api_endpoints.dart`
- Create: `lib/core/network/dio_client.dart`
- Create: `lib/core/network/auth_interceptor.dart`
- Create: `lib/core/network/error_interceptor.dart`
- Create: `lib/core/network/retry_interceptor.dart`
- Create: `lib/core/network/logging_interceptor.dart`
- Create: `lib/core/api/api_client.dart`

**Interfaces:**
- Produces: `ApiClient` class with `get<T>`, `post<T>`, `put<T>`, `delete<T>` methods. `ApiEndpoints` constants. Dio configured with all interceptors.

- [ ] **Step 1: Create ApiEndpoints constants**

```dart
// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = 'https://cibei.space';
  
  // Auth
  static const String signUp = '/api/auth/sign-up/email';
  static const String signIn = '/api/auth/sign-in/email';
  static const String signOut = '/api/auth/sign-out';
  static const String getSession = '/api/auth/get-session';
  
  // Sutras
  static const String sutras = '/api/sutras';
  static String sutraDetail(String slug) => '/api/sutras/$slug';
  static String sutraContent(String slug) => '/api/sutras/$slug/content';
  static const String sutraCategories = '/api/sutras/categories';
  
  // Glossary
  static const String glossary = '/api/glossary';
  static String glossaryDetail(String slug) => '/api/glossary/$slug';
  
  // Encyclopedia
  static const String encyclopedia = '/api/encyclopedia';
  static String encyclopediaDetail(String slug) => '/api/encyclopedia/$slug';
  static const String encyclopediaCategories = '/api/encyclopedia/categories';
  
  // Stories
  static const String stories = '/api/stories';
  static String storyDetail(String slug) => '/api/stories/$slug';
  static const String storyCategories = '/api/stories/categories';
  
  // Timeline
  static const String timeline = '/api/timeline';
  
  // Learning Paths
  static const String paths = '/api/paths';
  static String pathDetail(String slug) => '/api/paths/$slug';
  
  // Favorites
  static const String favorites = '/api/favorites';
  static String favoriteDelete(String id) => '/api/favorites/$id';
  static const String favoriteCheck = '/api/favorites/check';
  
  // Search
  static const String search = '/api/search';
  
  // Poster
  static String poster(String type, String slug) => '/api/poster/$type/$slug';
  
  // AI
  static const String aiChat = '/api/ai/chat';
}
```

- [ ] **Step 2: Create Dio client factory**

```dart
// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'retry_interceptor.dart';
import 'logging_interceptor.dart';
import '../constants/api_endpoints.dart';

Dio createDioClient({CookieJar? cookieJar}) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  if (cookieJar != null) {
    dio.interceptors.add(CookieManager(cookieJar));
  }
  dio.interceptors.add(RetryInterceptor(dio));
  dio.interceptors.add(ErrorInterceptor());
  dio.interceptors.add(LoggingInterceptor());

  return dio;
}
```

- [ ] **Step 3: Create interceptors**

```dart
// lib/core/network/auth_interceptor.dart
// Cookie-based auth via dio_cookie_manager — no custom interceptor needed,
// CookieManager handles Set-Cookie automatically.
// This file is intentionally minimal; cookie management is transparent.
```

```dart
// lib/core/network/retry_interceptor.dart
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  
  RetryInterceptor(this.dio, {this.maxRetries = 3});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && (err.requestOptions.extra['retryCount'] ?? 0) < maxRetries) {
      final retryCount = (err.requestOptions.extra['retryCount'] ?? 0) + 1;
      err.requestOptions.extra['retryCount'] = retryCount;
      await Future.delayed(Duration(milliseconds: 500 * retryCount));
      try {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // Will be handled by ErrorInterceptor
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError;
  }
}
```

```dart
// lib/core/network/error_interceptor.dart
import 'package:dio/dio.dart';
import '../../shared/models/app_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        handler.next(DioException(
          requestOptions: err.requestOptions,
          error: const NetworkException(),
          type: err.type,
        ));
        return;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          handler.next(DioException(
            requestOptions: err.requestOptions,
            error: const AuthException(),
            type: err.type,
          ));
          return;
        }
        if (statusCode == 404) {
          handler.next(DioException(
            requestOptions: err.requestOptions,
            error: const NotFoundException(),
            type: err.type,
          ));
          return;
        }
        final message = err.response?.data is Map
            ? (err.response?.data['error'] as String?) ?? '服务器错误'
            : '服务器错误';
        handler.next(DioException(
          requestOptions: err.requestOptions,
          error: ServerException(message),
          type: err.type,
        ));
        return;
      default:
        handler.next(err);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
```

```dart
// lib/core/network/logging_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[DIO] ${options.method} ${options.path}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[DIO] ${response.statusCode} ${response.requestOptions.path}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[DIO] ERROR ${err.requestOptions.path}: ${err.message}');
    }
    handler.next(err);
  }
}
```

- [ ] **Step 4: Create ApiClient**

```dart
// lib/core/api/api_client.dart
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import '../network/dio_client.dart';

class ApiClient {
  late final Dio _dio;
  late final CookieJar _cookieJar;

  ApiClient() {
    _cookieJar = CookieJar();
    _dio = createDioClient(cookieJar: _cookieJar);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters, cancelToken: cancelToken);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(path, data: data, cancelToken: cancelToken);
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(path, data: data, cancelToken: cancelToken);
  }

  Future<Response<T>> delete<T>(
    String path, {
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(path, cancelToken: cancelToken);
  }

  void clearCookies() {
    _cookieJar.deleteAll();
  }
}
```

- [ ] **Step 5: Verify — analyze should pass**

```bash
cd e:/workspace/claw/cibei_flutter && flutter analyze
```

- [ ] **Step 6: Commit**

```bash
git add -A && git commit -m "feat: add ApiClient with Dio interceptors and endpoints"
```

---

## Task 4: Core Theme — Apple Design Award Style

**Files:**
- Create: `lib/core/theme/app_colors.dart`
- Create: `lib/core/theme/app_typography.dart`
- Create: `lib/core/theme/app_theme.dart`

**Interfaces:**
- Produces: `AppColors`, `AppTypography`, `AppTheme.lightTheme`, `AppTheme.darkTheme`

- [ ] **Step 1: Create app_colors.dart**

```dart
// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFC9A24A);
  static const Color background = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF111111);
  static const Color text = Color(0xFF000000);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFF888888);
  static const Color darkSecondaryText = Color(0xFFAAAAAA);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color darkDivider = Color(0xFF2A2A2A);
  static const Color surface = Color(0xFFF8F8F8);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color error = Color(0xFFD32F2F);

  // Light Theme ColorScheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    secondary: primary,
    onSecondary: Colors.white,
    surface: background,
    onSurface: text,
    error: error,
    onError: Colors.white,
  );

  // Dark Theme ColorScheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: Colors.white,
    secondary: primary,
    onSecondary: Colors.white,
    surface: darkBackground,
    onSurface: darkText,
    error: error,
    onError: Colors.white,
  );
}
```

- [ ] **Step 2: Create app_typography.dart**

```dart
// lib/core/theme/app_typography.dart
import 'package:flutter/material.dart';

class AppTypography {
  static const double bodySize = 18.0;
  static const double titleSize = 24.0;
  static const double largeTitleSize = 34.0;
  static const double captionSize = 14.0;
  static const double lineHeight = 1.8;

  static const String iosFont = 'SF Pro';
  static const String androidFont = 'Noto Sans SC';

  static String get fontFamily {
    return defaultTargetPlatform == TargetPlatform.iOS ? iosFont : androidFont;
  }

  static TextTheme createTextTheme({required bool isDark}) {
    final color = isDark ? AppColors.darkText : AppColors.text;
    final secondaryColor = isDark ? AppColors.darkSecondaryText : AppColors.secondaryText;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: largeTitleSize,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: titleSize,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        fontSize: bodySize,
        fontWeight: FontWeight.w400,
        color: color,
        height: lineHeight,
      ),
      bodyMedium: TextStyle(
        fontSize: captionSize,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.5,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        letterSpacing: 0.5,
      ),
    );
  }
}
```

- [ ] **Step 3: Create app_theme.dart**

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.divider,
      textTheme: AppTypography.createTextTheme(isDark: false),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: AppColors.surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: AppColors.darkColorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      dividerColor: AppColors.darkDivider,
      textTheme: AppTypography.createTextTheme(isDark: true),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkText,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: AppColors.darkSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
```

- [ ] **Step 4: Update app.dart to use AppTheme**

```dart
// lib/app.dart — update theme references
// Replace ThemeData.light() with AppTheme.lightTheme
// Replace ThemeData.dark() with AppTheme.darkTheme
```

Update app.dart theme lines:
```dart
theme: AppTheme.lightTheme,
darkTheme: AppTheme.darkTheme,
themeMode: ref.watch(themeModeProvider),
```

- [ ] **Step 5: Add themeModeProvider to a new file**

```dart
// lib/core/theme/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
```

- [ ] **Step 6: Verify and commit**

```bash
cd e:/workspace/claw/cibei_flutter && flutter analyze
git add -A && git commit -m "feat: add Apple-style theme with light/dark mode"
```

---

## Task 5: Core Router — GoRouter with ShellRoute

**Files:**
- Create: `lib/core/router/app_router.dart`
- Create: `lib/core/router/route_names.dart`

**Interfaces:**
- Produces: `appRouter` (GoRouter instance), `RouteNames` constants
- Note: Feature pages don't exist yet, so routes use placeholder Page constructors that will be replaced in later tasks

- [ ] **Step 1: Create route_names.dart**

```dart
// lib/core/router/route_names.dart
class RouteNames {
  static const String home = 'home';
  static const String library = 'library';
  static const String stories = 'stories';
  static const String ai = 'ai';
  static const String profile = 'profile';
  static const String sutraDetail = 'sutraDetail';
  static const String sutraRead = 'sutraRead';
  static const String glossaryDetail = 'glossaryDetail';
  static const String encyclopediaDetail = 'encyclopediaDetail';
  static const String storyDetail = 'storyDetail';
  static const String search = 'search';
  static const String favorites = 'favorites';
  static const String notes = 'notes';
  static const String settings = 'settings';
  static const String login = 'login';
  static const String pathDetail = 'pathDetail';
  static const String timeline = 'timeline';
}
```

- [ ] **Step 2: Create app_router.dart with placeholder pages**

```dart
// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';

// Placeholder pages — replaced with real pages in later tasks
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage(this.title);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text('$title — Coming Soon')),
  );
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        // ScaffoldWithNavShell will be created in Task 7 (Core Widgets)
        return _ScaffoldWithNavShell(child: child, currentLocation: state.uri.toString());
      },
      routes: [
        GoRoute(
          path: '/',
          name: RouteNames.home,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: _PlaceholderPage('Home'),
          ),
        ),
        GoRoute(
          path: '/library',
          name: RouteNames.library,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: _PlaceholderPage('Library'),
          ),
        ),
        GoRoute(
          path: '/stories',
          name: RouteNames.stories,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: _PlaceholderPage('Stories'),
          ),
        ),
        GoRoute(
          path: '/ai',
          name: RouteNames.ai,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: _PlaceholderPage('AI Chat'),
          ),
        ),
        GoRoute(
          path: '/profile',
          name: RouteNames.profile,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: _PlaceholderPage('Profile'),
          ),
        ),
      ],
    ),
    // Detail routes (outside shell — full screen)
    GoRoute(
      path: '/sutra/:slug',
      name: RouteNames.sutraDetail,
      builder: (context, state) => _PlaceholderPage('Sutra: ${state.pathParameters['slug']}'),
    ),
    GoRoute(
      path: '/sutra/:slug/read',
      name: RouteNames.sutraRead,
      builder: (context, state) => _PlaceholderPage('Reading: ${state.pathParameters['slug']}'),
    ),
    GoRoute(
      path: '/glossary/:slug',
      name: RouteNames.glossaryDetail,
      builder: (context, state) => _PlaceholderPage('Glossary: ${state.pathParameters['slug']}'),
    ),
    GoRoute(
      path: '/encyclopedia/:slug',
      name: RouteNames.encyclopediaDetail,
      builder: (context, state) => _PlaceholderPage('Encyclopedia: ${state.pathParameters['slug']}'),
    ),
    GoRoute(
      path: '/story/:slug',
      name: RouteNames.storyDetail,
      builder: (context, state) => _PlaceholderPage('Story: ${state.pathParameters['slug']}'),
    ),
    GoRoute(
      path: '/search',
      name: RouteNames.search,
      builder: (context, state) => const _PlaceholderPage('Search'),
    ),
    GoRoute(
      path: '/favorites',
      name: RouteNames.favorites,
      builder: (context, state) => const _PlaceholderPage('Favorites'),
    ),
    GoRoute(
      path: '/notes',
      name: RouteNames.notes,
      builder: (context, state) => const _PlaceholderPage('Notes'),
    ),
    GoRoute(
      path: '/settings',
      name: RouteNames.settings,
      builder: (context, state) => const _PlaceholderPage('Settings'),
    ),
    GoRoute(
      path: '/login',
      name: RouteNames.login,
      builder: (context, state) => const _PlaceholderPage('Login'),
    ),
    GoRoute(
      path: '/paths/:slug',
      name: RouteNames.pathDetail,
      builder: (context, state) => _PlaceholderPage('Path: ${state.pathParameters['slug']}'),
    ),
    GoRoute(
      path: '/timeline',
      name: RouteNames.timeline,
      builder: (context, state) => const _PlaceholderPage('Timeline'),
    ),
  ],
);

// Bottom navigation scaffold
class _ScaffoldWithNavShell extends StatelessWidget {
  final Widget child;
  final String currentLocation;
  const _ScaffoldWithNavShell({required this.child, required this.currentLocation});

  int _currentIndex() {
    if (currentLocation.startsWith('/library')) return 1;
    if (currentLocation.startsWith('/stories')) return 2;
    if (currentLocation.startsWith('/ai')) return 3;
    if (currentLocation.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(),
        onDestinationSelected: (index) {
          final locations = ['/', '/library', '/stories', '/ai', '/profile'];
          final router = GoRouter.of(context);
          if (locations[index] != currentLocation) {
            router.go(locations[index]);
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '首页'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: '文库'),
          NavigationDestination(icon: Icon(Icons.auto_stories_outlined), selectedIcon: Icon(Icons.auto_stories), label: '故事'),
          NavigationDestination(icon: Icon(Icons.psychology_outlined), selectedIcon: Icon(Icons.psychology), label: 'AI'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Update app.dart to use appRouter**

```dart
// Replace routerConfig: null with:
import 'core/router/app_router.dart';
// ...
routerConfig: appRouter,
```

- [ ] **Step 4: Verify and commit**

```bash
cd e:/workspace/claw/cibei_flutter && flutter analyze
git add -A && git commit -m "feat: add GoRouter with ShellRoute and bottom navigation"
```

---

## Task 6: Core Storage — Hive & CacheManager

**Files:**
- Create: `lib/core/storage/cache_manager.dart`
- Create: `lib/core/storage/hive_boxes.dart`

**Interfaces:**
- Produces: `CacheManager` with `get<T>`, `put<T>`, `clear`, `clearAll`. Box name constants.

- [ ] **Step 1: Create hive_boxes.dart**

```dart
// lib/core/storage/hive_boxes.dart
class HiveBoxes {
  static const String homeCache = 'home_cache';
  static const String sutraCache = 'sutra_cache';
  static const String sutraContentCache = 'sutra_content_cache';
  static const String glossaryCache = 'glossary_cache';
  static const String storyCache = 'story_cache';
  static const String readingHistory = 'reading_history';
  static const String searchHistory = 'search_history';
  static const String userSettings = 'user_settings';
  static const String favoritesCache = 'favorites_cache';
  static const String chatHistory = 'chat_history';
  static const String notes = 'notes';
}
```

- [ ] **Step 2: Create cache_manager.dart**

```dart
// lib/core/storage/cache_manager.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'hive_boxes.dart';

class CacheManager {
  static const int maxCacheSizeBytes = 500 * 1024 * 1024; // 500MB

  Future<void> init() async {
    await Hive.openBox(HiveBoxes.homeCache);
    await Hive.openBox(HiveBoxes.sutraCache);
    await Hive.openBox(HiveBoxes.sutraContentCache);
    await Hive.openBox(HiveBoxes.glossaryCache);
    await Hive.openBox(HiveBoxes.storyCache);
    await Hive.openBox(HiveBoxes.readingHistory);
    await Hive.openBox(HiveBoxes.searchHistory);
    await Hive.openBox(HiveBoxes.userSettings);
    await Hive.openBox(HiveBoxes.favoritesCache);
    await Hive.openBox(HiveBoxes.chatHistory);
    await Hive.openBox(HiveBoxes.notes);
  }

  T? get<T>(String boxName, String key) {
    final box = Hive.box(boxName);
    return box.get(key) as T?;
  }

  Future<void> put<T>(String boxName, String key, T value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  Future<void> delete(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  Future<void> clear(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  Future<void> clearAll() async {
    for (final name in Hive.boxNames) {
      await Hive.box(name).clear();
    }
  }

  List<T> getAll<T>(String boxName) {
    final box = Hive.box(boxName);
    return box.values.whereType<T>().toList();
  }

  Future<void> putAll<T>(String boxName, Map<String, T> entries) async {
    final box = Hive.box(boxName);
    await box.putAll(entries);
  }
}
```

- [ ] **Step 3: Create CacheManager provider and update main.dart**

In `lib/core/storage/cache_manager.dart`, add at bottom:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cacheManagerProvider = Provider<CacheManager>((ref) {
  return CacheManager();
});
```

Update `lib/main.dart` to initialize cache:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/storage/cache_manager.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final cacheManager = CacheManager();
  await cacheManager.init();
  runApp(const ProviderScope(child: CibeiApp()));
}
```

- [ ] **Step 4: Verify and commit**

```bash
cd e:/workspace/claw/cibei_flutter && flutter analyze
git add -A && git commit -m "feat: add Hive storage with CacheManager"
```

---

## Task 7: Core Widgets — Shared UI Components

**Files:**
- Create: `lib/core/widgets/loading_indicator.dart`
- Create: `lib/core/widgets/error_display.dart`
- Create: `lib/core/widgets/empty_state.dart`
- Create: `lib/core/widgets/app_scaffold.dart`
- Create: `lib/core/widgets/section_header.dart`

**Interfaces:**
- Produces: Reusable widgets used across all features

- [ ] **Step 1: Create loading_indicator.dart**

```dart
// lib/core/widgets/loading_indicator.dart
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFFC9A24A),
            strokeWidth: 2,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Create error_display.dart**

```dart
// lib/core/widgets/error_display.dart
import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const ErrorDisplay({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              TextButton(onPressed: onRetry, child: const Text('重试')),
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Create empty_state.dart**

```dart
// lib/core/widgets/empty_state.dart
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  const EmptyState({super.key, required this.icon, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Create section_header.dart**

```dart
// lib/core/widgets/section_header.dart
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!)),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Verify and commit**

```bash
cd e:/workspace/claw/cibei_flutter && flutter analyze
git add -A && git commit -m "feat: add shared core widgets"
```

---

## Task 8: Home Feature

**Files:**
- Create: `lib/shared/components/sutra_card.dart`
- Create: `lib/shared/components/story_card.dart`
- Create: `lib/features/home/home_repository.dart`
- Create: `lib/features/home/home_controller.dart`
- Create: `lib/features/home/home_page.dart`
- Create: `lib/features/home/widgets/today_sutra_card.dart`
- Create: `lib/features/home/widgets/story_carousel.dart`
- Create: `lib/features/home/widgets/learning_path_section.dart`
- Create: `lib/features/home/widgets/popular_terms_section.dart`

**Interfaces:**
- Produces: `HomePage` at `/`, full home screen with sections
- Consumes: `ApiClient` (Task 3), `CacheManager` (Task 6), models (Task 2)

- [ ] **Step 1: Create shared components sutra_card.dart and story_card.dart**

```dart
// lib/shared/components/sutra_card.dart
import 'package:flutter/material.dart';
import '../../shared/models/sutra.dart';

class SutraCard extends StatelessWidget {
  final Sutra sutra;
  final VoidCallback? onTap;
  const SutraCard({super.key, required this.sutra, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sutra.category != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC9A24A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(sutra.category!, style: const TextStyle(fontSize: 12, color: Color(0xFFC9A24A))),
                ),
              const SizedBox(height: 8),
              Text(sutra.title, style: Theme.of(context).textTheme.headlineMedium),
              if (sutra.translator != null || sutra.dynasty != null) ...[
                const SizedBox(height: 4),
                Text(
                  [sutra.dynasty, sutra.translator].whereType<String>().join(' · '),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              if (sutra.summary != null) ...[
                const SizedBox(height: 8),
                Text(sutra.summary!, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

```dart
// lib/shared/components/story_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../shared/models/story.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback? onTap;
  const StoryCard({super.key, required this.story, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (story.imageUrl != null)
              CachedNetworkImage(
                imageUrl: story.imageUrl!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => const SizedBox(height: 160, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                errorWidget: (_, __, ___) => const SizedBox(height: 160, child: Center(child: Icon(Icons.image_outlined))),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC9A24A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(story.category, style: const TextStyle(fontSize: 12, color: Color(0xFFC9A24A))),
                      ),
                      if (story.sourceSutra != null) ...[
                        const SizedBox(width: 8),
                        Flexible(child: Text(story.sourceSutra!, style: Theme.of(context).textTheme.labelMedium, overflow: TextOverflow.ellipsis)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(story.title, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(story.summary, maxLines: 3, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Create home_repository.dart**

```dart
// lib/features/home/home_repository.dart
import 'dart:convert';
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';
import '../../shared/models/sutra.dart';
import '../../shared/models/story.dart';
import '../../shared/models/learning_path.dart';
import '../../shared/models/glossary_term.dart';

class HomeRepository {
  final ApiClient _api;
  final CacheManager _cache;

  HomeRepository(this._api, this._cache);

  Future<List<Sutra>> getRecentSutras() async {
    final response = await _api.get(ApiEndpoints.sutras, queryParameters: {'pageSize': 5});
    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List).map((j) => Sutra.fromJson(j)).toList();
    await _cache.put(HiveBoxes.homeCache, 'recent_sutras', jsonEncode(data['items']));
    return items;
  }

  Future<List<Story>> getRecentStories() async {
    final response = await _api.get(ApiEndpoints.stories, queryParameters: {'pageSize': 5});
    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List).map((j) => Story.fromJson(j)).toList();
    await _cache.put(HiveBoxes.homeCache, 'recent_stories', jsonEncode(data['items']));
    return items;
  }

  Future<List<LearningPath>> getLearningPaths() async {
    final response = await _api.get(ApiEndpoints.paths);
    final paths = (response.data as List).map((j) => LearningPath.fromJson(j)).toList();
    await _cache.put(HiveBoxes.homeCache, 'learning_paths', jsonEncode(response.data));
    return paths;
  }

  Future<List<GlossaryTerm>> getPopularTerms() async {
    final response = await _api.get(ApiEndpoints.glossary, queryParameters: {'pageSize': 10});
    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List).map((j) => GlossaryTerm.fromJson(j)).toList();
    await _cache.put(HiveBoxes.homeCache, 'popular_terms', jsonEncode(data['items']));
    return items;
  }

  Future<Map<String, dynamic>> getCachedHome() async {
    final cachedSutras = _cache.get<String>(HiveBoxes.homeCache, 'recent_sutras');
    final cachedStories = _cache.get<String>(HiveBoxes.homeCache, 'recent_stories');
    final cachedPaths = _cache.get<String>(HiveBoxes.homeCache, 'learning_paths');
    final cachedTerms = _cache.get<String>(HiveBoxes.homeCache, 'popular_terms');

    return {
      'sutras': cachedSutras != null ? (jsonDecode(cachedSutras) as List).map((j) => Sutra.fromJson(j)).toList() : null,
      'stories': cachedStories != null ? (jsonDecode(cachedStories) as List).map((j) => Story.fromJson(j)).toList() : null,
      'paths': cachedPaths != null ? (jsonDecode(cachedPaths) as List).map((j) => LearningPath.fromJson(j)).toList() : null,
      'terms': cachedTerms != null ? (jsonDecode(cachedTerms) as List).map((j) => GlossaryTerm.fromJson(j)).toList() : null,
    };
  }
}
```

- [ ] **Step 3: Create home_controller.dart**

```dart
// lib/features/home/home_controller.dart
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

final homeControllerProvider = AsyncNotifierProvider<HomeController, HomeState>(() => HomeController());

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
      // Return cached immediately, then refresh
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
```

- [ ] **Step 4: Create home widget files**

```dart
// lib/features/home/widgets/today_sutra_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/sutra.dart';

class TodaySutraCard extends StatelessWidget {
  final Sutra sutra;
  const TodaySutraCard({super.key, required this.sutra});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/sutra/${sutra.slug}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFC9A24A).withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('今日经典', style: TextStyle(fontSize: 13, color: Color(0xFFC9A24A), fontWeight: FontWeight.w500, letterSpacing: 1)),
            const SizedBox(height: 12),
            Text(sutra.title, style: Theme.of(context).textTheme.displayLarge),
            if (sutra.summary != null) ...[
              const SizedBox(height: 12),
              Text(sutra.summary!, maxLines: 3, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ],
        ),
      ),
    );
  }
}
```

```dart
// lib/features/home/widgets/story_carousel.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/story.dart';
import '../../../shared/components/story_card.dart';

class StoryCarousel extends StatelessWidget {
  final List<Story> stories;
  const StoryCarousel({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) return const SizedBox.shrink();
    return Column(
      children: stories.map((story) => StoryCard(
        story: story,
        onTap: () => context.push('/story/${story.slug}'),
      )).toList(),
    );
  }
}
```

```dart
// lib/features/home/widgets/learning_path_section.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/learning_path.dart';
import '../../../core/widgets/section_header.dart';

class LearningPathSection extends StatelessWidget {
  final List<LearningPath> paths;
  const LearningPathSection({super.key, required this.paths});

  @override
  Widget build(BuildContext context) {
    if (paths.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '学习路线', action: '查看全部'),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: paths.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final path = paths[index];
              return GestureDetector(
                onTap: () => context.push('/paths/${path.slug}'),
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(path.icon, style: const TextStyle(fontSize: 28)),
                      const Spacer(),
                      Text(path.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('${path.levelLabel} · ${path.stepCount}课', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
```

```dart
// lib/features/home/widgets/popular_terms_section.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/glossary_term.dart';
import '../../../core/widgets/section_header.dart';

class PopularTermsSection extends StatelessWidget {
  final List<GlossaryTerm> terms;
  const PopularTermsSection({super.key, required this.terms});

  @override
  Widget build(BuildContext context) {
    if (terms.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '热门词条'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: terms.map((term) => ActionChip(
              label: Text(term.term),
              onPressed: () => context.push('/glossary/${term.slug}'),
            )).toList(),
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 5: Create home_page.dart**

```dart
// lib/features/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../../core/widgets/section_header.dart';
import '../shared/components/sutra_card.dart';
import 'home_controller.dart';
import 'widgets/today_sutra_card.dart';
import 'widgets/story_carousel.dart';
import 'widgets/learning_path_section.dart';
import 'widgets/popular_terms_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cibei Space')),
      body: state.when(
        loading: () => const LoadingIndicator(),
        error: (err, st) => ErrorDisplay(message: err.toString(), onRetry: () => ref.invalidate(homeControllerProvider)),
        data: (home) => RefreshIndicator(
          onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              const SizedBox(height: 8),
              // Today's Sutra (first sutra as hero)
              if (home.sutras.isNotEmpty) TodaySutraCard(sutra: home.sutras.first),
              const SizedBox(height: 24),
              // Recent Sutras
              if (home.sutras.length > 1) ...[
                const SectionHeader(title: '经典浏览'),
                ...home.sutras.skip(1).map((s) => SutraCard(
                  sutra: s,
                  onTap: () => context.push('/sutra/${s.slug}'),
                )),
              ],
              const SizedBox(height: 24),
              // Learning Paths
              LearningPathSection(paths: home.paths),
              const SizedBox(height: 24),
              // Stories
              if (home.stories.isNotEmpty) ...[
                const SectionHeader(title: '佛经故事'),
                StoryCarousel(stories: home.stories),
              ],
              const SizedBox(height: 24),
              // Popular Terms
              PopularTermsSection(terms: home.terms),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 6: Update router to use HomePage**

In `lib/core/router/app_router.dart`, replace the Home placeholder:
```dart
import '../../features/home/home_page.dart';
// Replace _PlaceholderPage('Home') with HomePage()
```

- [ ] **Step 7: Verify build and commit**

```bash
cd e:/workspace/claw/cibei_flutter && flutter analyze
git add -A && git commit -m "feat: add Home feature with sutras, stories, paths, terms"
```

---

## Task 9: Sutras Feature — List, Detail, Reading

**Files:**
- Create: `lib/features/sutra/sutra_repository.dart`
- Create: `lib/features/sutra/sutra_controller.dart`
- Create: `lib/features/sutra/sutra_list_page.dart`
- Create: `lib/features/sutra/sutra_detail_page.dart`
- Create: `lib/features/sutra/sutra_reading_page.dart`
- Create: `lib/features/sutra/widgets/reading_toolbar.dart`

**Interfaces:**
- Produces: Full sutra browsing, detail, and reading experience
- Consumes: `ApiClient`, `CacheManager`, `Sutra`, `SutraContent` models

- [ ] **Step 1: Create sutra_repository.dart**

```dart
// lib/features/sutra/sutra_repository.dart
import 'dart:convert';
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';
import '../../shared/models/sutra.dart';
import '../../shared/models/sutra_content.dart';

class SutraRepository {
  final ApiClient _api;
  final CacheManager _cache;

  SutraRepository(this._api, this._cache);

  Future<({List<Sutra> items, int total, int page, int totalPages})> getSutras({
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'pageSize': pageSize};
    if (category != null) params['category'] = category;
    final response = await _api.get(ApiEndpoints.sutras, queryParameters: params);
    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List).map((j) => Sutra.fromJson(j)).toList();
    await _cache.put(HiveBoxes.sutraCache, 'list_p$page', jsonEncode(data['items']));
    return (items: items, total: data['total'], page: data['page'], totalPages: data['totalPages']);
  }

  Future<Sutra> getSutraDetail(String slug) async {
    final response = await _api.get(ApiEndpoints.sutraDetail(slug));
    return Sutra.fromJson(response.data);
  }

  Future<SutraContent> getSutraContent(String slug) async {
    final response = await _api.get(ApiEndpoints.sutraContent(slug));
    final content = SutraContent.fromJson(response.data);
    await _cache.put(HiveBoxes.sutraContentCache, slug, jsonEncode(response.data));
    return content;
  }

  Future<List<String>> getCategories() async {
    final response = await _api.get(ApiEndpoints.sutraCategories);
    return (response.data as List).cast<String>();
  }
}
```

- [ ] **Step 2: Create sutra_controller.dart**

```dart
// lib/features/sutra/sutra_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/cache_manager.dart';
import '../../shared/models/sutra.dart';
import '../../shared/models/sutra_content.dart';
import 'sutra_repository.dart';

final sutraRepositoryProvider = Provider((ref) => SutraRepository(ApiClient(), CacheManager()));

// Sutra list controller
final sutraListControllerProvider = AsyncNotifierProvider.family<SutraListController, SutraListState, String?>(() => SutraListController());

class SutraListState {
  final List<Sutra> sutras;
  final int page;
  final int totalPages;
  final bool isLoadingMore;
  const SutraListState({this.sutras = const [], this.page = 1, this.totalPages = 1, this.isLoadingMore = false});
}

class SutraListController extends FamilyAsyncNotifier<SutraListState, String?> {
  @override
  Future<SutraListState> build(String? category) async {
    final repo = ref.read(sutraRepositoryProvider);
    final result = await repo.getSutras(category: category);
    return SutraListState(sutras: result.items, page: result.page, totalPages: result.totalPages);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || current.page >= current.totalPages) return;
    state = AsyncData(SutraListState(sutras: current.sutras, page: current.page, totalPages: current.totalPages, isLoadingMore: true));
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
final sutraDetailControllerProvider = AsyncNotifierProvider.family<SutraDetailController, Sutra, String>(() => SutraDetailController());

class SutraDetailController extends FamilyAsyncNotifier<Sutra, String> {
  @override
  Future<Sutra> build(String slug) async {
    return ref.read(sutraRepositoryProvider).getSutraDetail(slug);
  }
}

// Sutra content controller
final sutraContentControllerProvider = AsyncNotifierProvider.family<SutraContentController, SutraContent, String>(() => SutraContentController());

class SutraContentController extends FamilyAsyncNotifier<SutraContent, String> {
  @override
  Future<SutraContent> build(String slug) async {
    return ref.read(sutraRepositoryProvider).getSutraContent(slug);
  }
}

// Categories
final sutraCategoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(sutraRepositoryProvider).getCategories();
});
```

- [ ] **Step 3: Create sutra_list_page.dart**

```dart
// lib/features/sutra/sutra_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../../shared/components/sutra_card.dart';
import 'sutra_controller.dart';

class SutraListPage extends ConsumerStatefulWidget {
  const SutraListPage({super.key});

  @override
  ConsumerState<SutraListPage> createState() => _SutraListPageState();
}

class _SutraListPageState extends ConsumerState<SutraListPage> {
  String? _selectedCategory;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(sutraListControllerProvider(_selectedCategory).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sutraListControllerProvider(_selectedCategory));
    final categories = ref.watch(sutraCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('经典文库')),
      body: Column(
        children: [
          // Category filter
          categories.when(
            data: (cats) => SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cats.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isAll = index == 0;
                  final cat = isAll ? null : cats[index - 1];
                  final isSelected = _selectedCategory == cat;
                  return FilterChip(
                    label: Text(isAll ? '全部' : cat!),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  );
                },
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(height: 1),
          Expanded(
            child: state.when(
              loading: () => const LoadingIndicator(),
              error: (err, _) => ErrorDisplay(message: err.toString(), onRetry: () => ref.invalidate(sutraListControllerProvider(_selectedCategory))),
              data: (data) => RefreshIndicator(
                onRefresh: () async => ref.invalidate(sutraListControllerProvider(_selectedCategory)),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 32),
                  itemCount: data.sutras.length + (data.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= data.sutras.length) return const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
                    final sutra = data.sutras[index];
                    return SutraCard(sutra: sutra, onTap: () => context.push('/sutra/${sutra.slug}'));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
```

- [ ] **Step 4: Create sutra_detail_page.dart**

```dart
// lib/features/sutra/sutra_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import 'sutra_controller.dart';

class SutraDetailPage extends ConsumerWidget {
  final String slug;
  const SutraDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sutra = ref.watch(sutraDetailControllerProvider(slug));
    return sutra.when(
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (err, _) => Scaffold(body: ErrorDisplay(message: err.toString())),
      data: (s) => Scaffold(
        appBar: AppBar(title: Text(s.title)),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(s.title, style: Theme.of(context).textTheme.displayLarge),
            if (s.titleEn != null) ...[
              const SizedBox(height: 4),
              Text(s.titleEn!, style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 20),
            _InfoRow(label: '朝代', value: s.dynasty),
            _InfoRow(label: '译者', value: s.translator),
            _InfoRow(label: '分类', value: s.category),
            _InfoRow(label: 'CBETA', value: s.cbetaId),
            if (s.summary != null) ...[
              const SizedBox(height: 20),
              Text(s.summary!, style: Theme.of(context).textTheme.bodyLarge),
            ],
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.push('/sutra/$slug/read'),
              icon: const Icon(Icons.menu_book),
              label: const Text('开始阅读'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: const Color(0xFFC9A24A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  const _InfoRow({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Expanded(child: Text(value!)),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Create reading_toolbar.dart and sutra_reading_page.dart**

```dart
// lib/features/sutra/widgets/reading_toolbar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fontSizeProvider = StateProvider<double>((ref) => 18.0);
final lineHeightProvider = StateProvider<double>((ref) => 1.8);
final readingWidthProvider = StateProvider<double>((ref) => 1.0); // fraction of screen width
final isNightModeProvider = StateProvider<bool>((ref) => false);

class ReadingToolbar extends ConsumerWidget {
  const ReadingToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.text_decrease), onPressed: () => ref.read(fontSizeProvider.notifier).state = (ref.read(fontSizeProvider) - 2).clamp(14, 34)),
            Text('${ref.watch(fontSizeProvider).toInt()}pt', style: Theme.of(context).textTheme.labelMedium),
            IconButton(icon: const Icon(Icons.text_increase), onPressed: () => ref.read(fontSizeProvider.notifier).state = (ref.read(fontSizeProvider) + 2).clamp(14, 34)),
            IconButton(icon: const Icon(Icons.format_line_spacing), onPressed: () => ref.read(lineHeightProvider.notifier).state = ref.read(lineHeightProvider) == 1.8 ? 2.2 : ref.read(lineHeightProvider) == 2.2 ? 2.6 : 1.8),
            IconButton(
              icon: Icon(ref.watch(isNightModeProvider) ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => ref.read(isNightModeProvider.notifier).state = !ref.read(isNightModeProvider),
            ),
            IconButton(icon: const Icon(Icons.width_normal), onPressed: () => ref.read(readingWidthProvider.notifier).state = ref.read(readingWidthProvider) == 1.0 ? 0.85 : 1.0),
          ],
        ),
      ),
    );
  }
}
```

```dart
// lib/features/sutra/sutra_reading_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import 'sutra_controller.dart';
import 'widgets/reading_toolbar.dart';

class SutraReadingPage extends ConsumerWidget {
  final String slug;
  const SutraReadingPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(sutraContentControllerProvider(slug));
    final fontSize = ref.watch(fontSizeProvider);
    final lineHeight = ref.watch(lineHeightProvider);
    final width = ref.watch(readingWidthProvider);
    final isNight = ref.watch(isNightModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(content.valueOrNull?.title ?? '阅读')),
      body: content.when(
        loading: () => const LoadingIndicator(),
        error: (err, _) => ErrorDisplay(message: err.toString()),
        data: (c) => Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * width,
            child: Markdown(
              data: c.content,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(fontSize: fontSize, height: lineHeight),
                h1: TextStyle(fontSize: fontSize + 10, fontWeight: FontWeight.w700),
                h2: TextStyle(fontSize: fontSize + 6, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const ReadingToolbar(),
    );
  }
}
```

- [ ] **Step 6: Update router with sutra pages**

In `lib/core/router/app_router.dart`:
```dart
import '../../features/sutra/sutra_detail_page.dart';
import '../../features/sutra/sutra_reading_page.dart';

// Replace sutra detail placeholder:
builder: (context, state) => SutraDetailPage(slug: state.pathParameters['slug']!),

// Replace sutra read placeholder:
builder: (context, state) => SutraReadingPage(slug: state.pathParameters['slug']!),
```

- [ ] **Step 7: Verify and commit**

```bash
cd e:/workspace/claw/cibei_flutter && flutter analyze
git add -A && git commit -m "feat: add Sutras feature with list, detail, and reading pages"
```

---

## Task 10: Stories Feature — List & Detail

**Files:**
- Create: `lib/features/stories/story_repository.dart`
- Create: `lib/features/stories/story_controller.dart`
- Create: `lib/features/stories/story_list_page.dart`
- Create: `lib/features/stories/story_detail_page.dart`

**Interfaces:**
- Consumes: `ApiClient`, `CacheManager`, `Story` model
- Produces: Story browsing and reading pages

- [ ] **Step 1-2: Create repository and controller (abbreviated — same pattern as Sutras)**

```dart
// lib/features/stories/story_repository.dart — follows same pattern as SutraRepository
// Methods: getStories(category, page, pageSize), getStoryDetail(slug), getCategories()
```

```dart
// lib/features/stories/story_controller.dart — follows same pattern as sutra_controller
// Providers: storyListControllerProvider, storyDetailControllerProvider, storyCategoriesProvider
```

- [ ] **Step 3-4: Create list and detail pages**

```dart
// lib/features/stories/story_list_page.dart — paginated list with StoryCard + category filter
// lib/features/stories/story_detail_page.dart — full story with moral quote, source sutra, related stories
```

- [ ] **Step 5: Update router**

- [ ] **Step 6: Commit**

```bash
git add -A && git commit -m "feat: add Stories feature with list and detail pages"
```

---

## Task 11: Dictionary Feature — List & Detail

**Files:**
- Create: `lib/features/dictionary/dictionary_repository.dart`
- Create: `lib/features/dictionary/dictionary_controller.dart`
- Create: `lib/features/dictionary/dictionary_list_page.dart`
- Create: `lib/features/dictionary/dictionary_detail_page.dart`

**Same pattern as Sutras, using `/api/glossary` endpoints and `GlossaryTerm` model.**

- [ ] Commit: `git add -A && git commit -m "feat: add Dictionary feature"`

---

## Task 12: Encyclopedia Feature — List & Detail

**Files:**
- Create: `lib/features/encyclopedia/encyclopedia_repository.dart`
- Create: `lib/features/encyclopedia/encyclopedia_controller.dart`
- Create: `lib/features/encyclopedia/encyclopedia_list_page.dart`
- Create: `lib/features/encyclopedia/encyclopedia_detail_page.dart`

**Same pattern using `/api/encyclopedia` endpoints and `EncyclopediaEntry` model.**

- [ ] Commit: `git add -A && git commit -m "feat: add Encyclopedia feature"`

---

## Task 13: Auth + Profile Feature

**Files:**
- Create: `lib/features/profile/auth_repository.dart`
- Create: `lib/features/profile/auth_controller.dart`
- Create: `lib/features/profile/login_page.dart`
- Create: `lib/features/profile/profile_page.dart`
- Create: `lib/features/profile/settings_page.dart`

**Interfaces:**
- Consumes: `ApiClient` (cookie-based auth), `flutter_secure_storage` for session state
- Produces: Login flow, profile display, settings page

- [ ] **Step 1: Create auth_repository.dart**

```dart
// lib/features/profile/auth_repository.dart
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../shared/models/user.dart';

class AuthRepository {
  final ApiClient _api;

  AuthRepository(this._api);

  Future<AuthResponse> signIn(String email, String password) async {
    final response = await _api.post(ApiEndpoints.signIn, data: {'email': email, 'password': password});
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> signUp(String email, String password, String name) async {
    final response = await _api.post(ApiEndpoints.signUp, data: {'email': email, 'password': password, 'name': name});
    return AuthResponse.fromJson(response.data);
  }

  Future<SessionResponse?> getSession() async {
    try {
      final response = await _api.get(ApiEndpoints.getSession);
      return SessionResponse.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _api.post(ApiEndpoints.signOut);
  }
}
```

- [ ] **Step 2: Create auth_controller.dart**

```dart
// lib/features/profile/auth_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../shared/models/user.dart';
import 'auth_repository.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(ApiClient()));

final sessionProvider = FutureProvider<SessionResponse?>((ref) {
  return ref.read(authRepositoryProvider).getSession();
});

final isLoggedInProvider = Provider<bool>((ref) {
  final session = ref.watch(sessionProvider);
  return session.valueOrNull?.user != null;
});

final currentUserProvider = Provider<AsyncValue<User?>>((ref) {
  final session = ref.watch(sessionProvider);
  return session.when(
    data: (s) => AsyncData(s?.user),
    loading: () => const AsyncLoading(),
    error: (e, _) => AsyncError(e, StackTrace.current),
  );
});
```

- [ ] **Step 3: Create login_page.dart**

```dart
// lib/features/profile/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';
import 'auth_repository.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  String? _error;

  Future<void> _submit() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final repo = ref.read(authRepositoryProvider);
      if (_isLogin) {
        await repo.signIn(_emailController.text.trim(), _passwordController.text);
      } else {
        await repo.signUp(_emailController.text.trim(), _passwordController.text, _nameController.text.trim());
      }
      ref.invalidate(sessionProvider);
      if (mounted) context.go('/profile');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? '登录' : '注册')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 40),
          Icon(Icons.self_improvement, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 32),
          if (!_isLogin) ...[
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: '用户名'), textInputAction: TextInputAction.next),
            const SizedBox(height: 16),
          ],
          TextField(controller: _emailController, decoration: const InputDecoration(labelText: '邮箱'), keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next),
          const SizedBox(height: 16),
          TextField(controller: _passwordController, decoration: const InputDecoration(labelText: '密码'), obscureText: true, textInputAction: TextInputAction.done, onSubmitted: (_) => _submit()),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          const SizedBox(height: 24),
          FilledButton(onPressed: _isLoading ? null : _submit, child: Text(_isLoading ? '请稍候...' : (_isLogin ? '登录' : '注册'))),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => setState(() { _isLogin = !_isLogin; _error = null; }),
            child: Text(_isLogin ? '没有账号？点击注册' : '已有账号？点击登录'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
```

- [ ] **Step 4: Create profile_page.dart**

```dart
// lib/features/profile/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: user.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (_, __) => const Center(child: Text('加载失败')),
        data: (u) {
          if (u == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline, size: 80, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text('登录以同步数据'),
                  const SizedBox(height: 24),
                  FilledButton(onPressed: () => context.push('/login'), child: const Text('登录 / 注册')),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              CircleAvatar(radius: 40, backgroundImage: u.image != null ? NetworkImage(u.image!) : null, child: u.image == null ? Text(u.name?[0] ?? '?') : null),
              const SizedBox(height: 12),
              Text(u.name ?? u.email, style: Theme.of(context).textTheme.headlineMedium),
              const Divider(height: 32),
              _menuItem(context, '我的收藏', Icons.favorite_border, () => context.push('/favorites')),
              _menuItem(context, '我的笔记', Icons.edit_note, () => context.push('/notes')),
              _menuItem(context, '阅读历史', Icons.history, () {}),
              _menuItem(context, '学习统计', Icons.bar_chart, () {}),
              _menuItem(context, '设置', Icons.settings_outlined, () => context.push('/settings')),
              const SizedBox(height: 24),
              OutlinedButton(onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
                ref.invalidate(sessionProvider);
              }, child: const Text('退出登录')),
            ],
          );
        },
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(leading: Icon(icon), title: Text(title), trailing: const Icon(Icons.chevron_right), onTap: onTap);
  }
}
```

- [ ] **Step 5: Create settings_page.dart**

```dart
// lib/features/profile/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          const _SectionHeader('外观'),
          ListTile(
            title: const Text('深色模式'),
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('跟随系统')),
                ButtonSegment(value: ThemeMode.light, label: Text('浅色')),
                ButtonSegment(value: ThemeMode.dark, label: Text('深色')),
              ],
              selected: {themeMode},
              onSelectionChanged: (v) => ref.read(themeModeProvider.notifier).state = v,
            ),
          ),
          const _SectionHeader('阅读'),
          ListTile(title: const Text('字体大小'), trailing: const Text('默认')),
          ListTile(title: const Text('行间距'), trailing: const Text('1.8')),
          const _SectionHeader('数据'),
          ListTile(title: const Text('清除缓存'), onTap: () {}),
          ListTile(title: const Text('离线内容'), trailing: const Text('已缓存 0MB')),
          const _SectionHeader('关于'),
          ListTile(title: const Text('版本'), trailing: const Text('1.0.0')),
          ListTile(title: const Text('Cibei Space'), subtitle: const Text('https://cibei.space')),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 13)),
    );
  }
}
```

- [ ] **Step 6: Update router and commit**

```bash
git add -A && git commit -m "feat: add Auth, Profile, and Settings features"
```

---

## Task 14: Favorites Feature

**Files:**
- Create: `lib/features/favorites/favorites_repository.dart`
- Create: `lib/features/favorites/favorites_controller.dart`
- Create: `lib/features/favorites/favorites_page.dart`
- Modify: `lib/features/sutra/sutra_detail_page.dart` (add favorite button)
- Modify: `lib/shared/components/story_card.dart` (add favorite toggle)

**API:** `GET /api/favorites`, `POST /api/favorites`, `DELETE /api/favorites/{id}`, `GET /api/favorites/check`

- [ ] **Step 1: Create favorites_repository.dart**

```dart
// lib/features/favorites/favorites_repository.dart
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../shared/models/favorite.dart';

class FavoritesRepository {
  final ApiClient _api;
  FavoritesRepository(this._api);

  Future<List<Favorite>> getFavorites() async {
    final response = await _api.get(ApiEndpoints.favorites);
    return (response.data as List).map((j) => Favorite.fromJson(j)).toList();
  }

  /// Returns true if now favorited, false if unfavorited
  Future<bool> toggleFavorite({required String type, required String slug, required String title, String? subtitle}) async {
    final response = await _api.post(ApiEndpoints.favorites, data: {
      'type': type,
      'slug': slug,
      'title': title,
      'subtitle': subtitle,
    });
    return response.data['favorited'] as bool;
  }

  Future<void> removeFavorite(String id) async {
    await _api.delete(ApiEndpoints.favoriteDelete(id));
  }

  Future<bool> checkFavorite(String type, String slug) async {
    final response = await _api.get(ApiEndpoints.favoriteCheck, queryParameters: {'type': type, 'slug': slug});
    return response.data['favorited'] as bool;
  }
}
```

- [ ] **Step 2: Create favorites_controller.dart**

```dart
// lib/features/favorites/favorites_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../shared/models/favorite.dart';
import 'favorites_repository.dart';

final favoritesRepositoryProvider = Provider((ref) => FavoritesRepository(ApiClient()));

final favoritesProvider = AsyncNotifierProvider<FavoritesController, List<Favorite>>(() => FavoritesController());

class FavoritesController extends AsyncNotifier<List<Favorite>> {
  @override
  Future<List<Favorite>> build() async {
    return ref.read(favoritesRepositoryProvider).getFavorites();
  }

  Future<void> toggle(String type, String slug, String title, {String? subtitle}) async {
    await ref.read(favoritesRepositoryProvider).toggleFavorite(type: type, slug: slug, title: title, subtitle: subtitle);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    await ref.read(favoritesRepositoryProvider).removeFavorite(id);
    ref.invalidateSelf();
  }
}

// Check individual item favorite status
final favoriteStatusProvider = FutureProvider.family<bool, ({String type, String slug})>((ref, params) {
  return ref.read(favoritesRepositoryProvider).checkFavorite(params.type, params.slug);
});
```

- [ ] **Step 3: Create favorites_page.dart**

```dart
// lib/features/favorites/favorites_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_indicator.dart';
import 'favorites_controller.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('我的收藏')),
      body: favorites.when(
        loading: () => const LoadingIndicator(),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(icon: Icons.favorite_border, title: '暂无收藏', subtitle: '浏览内容时点击收藏按钮即可添加');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final fav = items[index];
              return Dismissible(
                key: Key(fav.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Theme.of(context).colorScheme.error,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => ref.read(favoritesProvider.notifier).remove(fav.id),
                child: ListTile(
                  leading: Icon(_typeIcon(fav.type)),
                  title: Text(fav.title),
                  subtitle: fav.subtitle != null ? Text(fav.subtitle!) : null,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/${fav.type}/${fav.slug}'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _typeIcon(String type) {
    return switch (type) {
      'sutra' => Icons.menu_book,
      'glossary' => Icons.bookmark,
      'story' => Icons.auto_stories,
      'encyclopedia' => Icons.account_balance,
      _ => Icons.favorite,
    };
  }
}
```

- [ ] **Step 4: Add favorite button to SutraDetailPage (modify existing file)**

In `lib/features/sutra/sutra_detail_page.dart`, add to the AppBar:
```dart
actions: [
  Consumer(
    builder: (context, ref, _) {
      final status = ref.watch(favoriteStatusProvider((type: 'sutra', slug: slug)));
      return IconButton(
        icon: Icon(status.valueOrNull == true ? Icons.favorite : Icons.favorite_border),
        color: status.valueOrNull == true ? Colors.red : null,
        onPressed: () async {
          await ref.read(favoritesRepositoryProvider).toggleFavorite(type: 'sutra', slug: slug, title: s.title, subtitle: s.category);
          ref.invalidate(favoriteStatusProvider((type: 'sutra', slug: slug)));
        },
      );
    },
  ),
],
```

- [ ] **Step 5: Update router and commit**

```bash
git add -A && git commit -m "feat: add Favorites feature with toggle and swipe-to-delete"
```

---

## Task 15: Search Feature

**Files:**
- Create: `lib/features/search/search_repository.dart`
- Create: `lib/features/search/search_controller.dart`
- Create: `lib/features/search/search_page.dart`

**API:** `GET /api/search?q={keyword}&type={filter}`

- [ ] **Step 1: Create search_repository.dart**

```dart
// lib/features/search/search_repository.dart
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';
import '../../shared/models/search_result.dart';

class SearchRepository {
  final ApiClient _api;
  final CacheManager _cache;

  SearchRepository(this._api, this._cache);

  Future<SearchResponse> search(String query, {String? type}) async {
    final params = <String, dynamic>{'q': query};
    if (type != null) params['type'] = type;
    final response = await _api.get(ApiEndpoints.search, queryParameters: params);
    return SearchResponse.fromJson(response.data);
  }

  Future<List<String>> getRecentSearches() async {
    return _cache.get<List>(HiveBoxes.searchHistory, 'recent')?.cast<String>() ?? [];
  }

  Future<void> saveRecentSearch(String query) async {
    var recent = await getRecentSearches();
    recent.remove(query);
    recent.insert(0, query);
    if (recent.length > 50) recent = recent.sublist(0, 50);
    await _cache.put(HiveBoxes.searchHistory, 'recent', recent);
  }

  Future<void> clearRecentSearches() async {
    await _cache.delete(HiveBoxes.searchHistory, 'recent');
  }
}
```

- [ ] **Step 2: Create search_controller.dart**

```dart
// lib/features/search/search_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/cache_manager.dart';
import '../../shared/models/search_result.dart';
import 'search_repository.dart';

final searchRepositoryProvider = Provider((ref) => SearchRepository(ApiClient(), CacheManager()));

final searchResultsProvider = StateNotifierProvider.family<SearchNotifier, AsyncValue<SearchResponse>, String>((ref, query) {
  return SearchNotifier(ref, query);
});

class SearchNotifier extends StateNotifier<AsyncValue<SearchResponse>> {
  final Ref _ref;
  final String _query;

  SearchNotifier(this._ref, this._query) : super(const AsyncLoading()) {
    _search();
  }

  Future<void> _search() async {
    if (_query.isEmpty) {
      state = const AsyncData(SearchResponse(results: [], total: 0));
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = _ref.read(searchRepositoryProvider);
      await repo.saveRecentSearch(_query);
      return repo.search(_query);
    });
  }
}

final recentSearchesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(searchRepositoryProvider).getRecentSearches();
});
```

- [ ] **Step 3: Create search_page.dart**

```dart
// lib/features/search/search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'search_controller.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = _query.isNotEmpty ? ref.watch(searchResultsProvider(_query)) : null;
    final recent = ref.watch(recentSearchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: '搜索经典、词典、百科、故事...', border: InputBorder.none),
          onSubmitted: (v) => setState(() => _query = v.trim()),
          textInputAction: TextInputAction.search,
        ),
        actions: [
          if (_query.isNotEmpty) IconButton(icon: const Icon(Icons.clear), onPressed: () { _controller.clear(); setState(() => _query = ''); }),
        ],
      ),
      body: _query.isEmpty
        ? recent.when(
            data: (items) => ListView(
              children: [
                if (items.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('最近搜索', style: Theme.of(context).textTheme.labelMedium),
                        TextButton(onPressed: () => ref.read(searchRepositoryProvider).clearRecentSearches().then((_) => ref.invalidate(recentSearchesProvider)), child: const Text('清除')),
                      ],
                    ),
                  ),
                  ...items.map((q) => ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(q),
                    onTap: () { _controller.text = q; setState(() => _query = q); },
                  )),
                ],
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, __) => const SizedBox.shrink(),
          )
        : results?.when(
            loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (e, _) => Center(child: Text(e.toString())),
            data: (resp) => resp.results.isEmpty
              ? const Center(child: Text('未找到相关结果'))
              : ListView.builder(
                  itemCount: resp.results.length,
                  itemBuilder: (context, index) {
                    final r = resp.results[index];
                    return ListTile(
                      leading: Icon(_typeIcon(r.type)),
                      title: Text(r.title),
                      subtitle: Text(r.excerpt, maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: Text(r.type, style: Theme.of(context).textTheme.labelMedium),
                      onTap: () => context.push('/${r.type}/${r.slug}'),
                    );
                  },
                ),
          ) ?? const SizedBox.shrink(),
    );
  }

  IconData _typeIcon(String type) {
    return switch (type) {
      'sutra' => Icons.menu_book,
      'glossary' => Icons.bookmark,
      'story' => Icons.auto_stories,
      'encyclopedia' => Icons.account_balance,
      _ => Icons.search,
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

- [ ] **Step 4: Update router and commit**

---

## Task 16: Library Tab — Aggregate Sutras + Dictionary + Encyclopedia

**Files:**
- Create: `lib/features/home/library_page.dart`

**Note:** The "Library" bottom tab combines sutras, dictionary, and encyclopedia access. This page acts as a hub.

```dart
// lib/features/home/library_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('文库')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _LibraryCard(
            icon: Icons.menu_book,
            title: '经典文库',
            subtitle: '浏览佛经原文，支持全文阅读',
            onTap: () => context.push('/sutras'),
          ),
          const SizedBox(height: 12),
          _LibraryCard(
            icon: Icons.bookmark,
            title: '佛学词典',
            subtitle: '查阅佛教术语与概念',
            onTap: () => context.push('/glossary'),
          ),
          const SizedBox(height: 12),
          _LibraryCard(
            icon: Icons.account_balance,
            title: '佛学百科',
            subtitle: '人物、宗派、历史知识',
            onTap: () => context.push('/encyclopedia'),
          ),
          const SizedBox(height: 12),
          _LibraryCard(
            icon: Icons.timeline,
            title: '佛教时间线',
            subtitle: '纵观佛教历史发展',
            onTap: () => context.push('/timeline'),
          ),
          const SizedBox(height: 12),
          _LibraryCard(
            icon: Icons.route,
            title: '学习路线',
            subtitle: '系统化学习佛学知识',
            onTap: () => context.push('/paths'),
          ),
        ],
      ),
    );
  }
}

class _LibraryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LibraryCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 32, color: const Color(0xFFC9A24A)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 1: Update router — replace Library placeholder with LibraryPage**

- [ ] **Step 2: Add routes for timeline and paths list pages**

- [ ] **Step 3: Commit**

---

## Task 17: AI Chat Feature (Mock)

**Files:**
- Create: `lib/features/ai/ai_repository.dart`
- Create: `lib/features/ai/ai_controller.dart`
- Create: `lib/features/ai/ai_chat_page.dart`
- Create: `lib/features/ai/widgets/ai_message_bubble.dart`
- Create: `lib/features/ai/widgets/ai_disclaimer.dart`

**Note:** AI chat endpoint not yet available on backend. Messages stored locally in Hive. Mock responses for MVP.

- [ ] **Step 1: Create ai_repository.dart with mock responses**

```dart
// lib/features/ai/ai_repository.dart
import 'dart:convert';
import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';

class AiMessage {
  final String id;
  final String role; // 'user' or 'assistant'
  final String content;
  final List<String> references;
  final DateTime timestamp;

  AiMessage({required this.id, required this.role, required this.content, this.references = const [], DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {'id': id, 'role': role, 'content': content, 'references': references, 'timestamp': timestamp.toIso8601String()};

  factory AiMessage.fromJson(Map<String, dynamic> json) => AiMessage(
    id: json['id'],
    role: json['role'],
    content: json['content'],
    references: (json['references'] as List?)?.cast<String>() ?? [],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class AiRepository {
  final CacheManager _cache;

  AiRepository(this._cache);

  Future<List<AiMessage>> getHistory() async {
    final data = _cache.get<String>(HiveBoxes.chatHistory, 'messages');
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.map((j) => AiMessage.fromJson(j)).toList();
  }

  Future<void> saveMessage(AiMessage message) async {
    final history = await getHistory();
    history.add(message);
    await _cache.put(HiveBoxes.chatHistory, 'messages', jsonEncode(history.map((m) => m.toJson()).toList()));
  }

  // Mock AI response — will be replaced with real API call
  Future<AiMessage> sendMessage(String content) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return AiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'assistant',
      content: _mockResponse(content),
      references: ['金刚般若波罗蜜经', '六祖坛经'],
    );
  }

  String _mockResponse(String query) {
    if (query.contains('空') || query.contains('空性')) {
      return '「空性」（śūnyatā）是佛教的核心概念之一。\n\n《金刚经》云："凡所有相，皆是虚妄。若见诸相非相，即见如来。"\n\n空并非虚无，而是指一切法无自性，没有永恒不变的实体。理解空性不是否定现象的存在，而是洞察现象的真实本质。\n\n> ⚠️ AI 内容仅供学习参考，不代表佛法权威解释。';
    }
    if (query.contains('苦') || query.contains('四圣谛')) {
      return '四圣谛（Catvāri Āryasatyāni）是佛陀初转法轮时宣说的根本教义：\n\n1. **苦谛** — 生命中有苦的存在\n2. **集谛** — 苦的原因在于渴爱和执著\n3. **灭谛** — 苦可以被止息\n4. **道谛** — 通过八正道可以达到苦的止息\n\n> ⚠️ AI 内容仅供学习参考。';
    }
    return '这是一个很好的问题。在佛学视角下，建议您从基础经典开始了解，如《心经》和《金刚经》。您也可以查看我们的学习路线来系统学习。\n\n> ⚠️ AI 内容仅供学习参考。';
  }
}
```

- [ ] **Step 2: Create ai_controller.dart**

```dart
// lib/features/ai/ai_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart'; // Note: may need to add uuid package or use timestamp
import '../../core/storage/cache_manager.dart';
import 'ai_repository.dart';

final aiRepositoryProvider = Provider((ref) => AiRepository(CacheManager()));

final chatMessagesProvider = StateNotifierProvider<ChatController, AsyncValue<List<AiMessage>>>((ref) {
  return ChatController(ref);
});

class ChatController extends StateNotifier<AsyncValue<List<AiMessage>>> {
  final Ref _ref;

  ChatController(this._ref) : super(const AsyncLoading()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _ref.read(aiRepositoryProvider).getHistory());
  }

  Future<void> sendMessage(String content) async {
    final repo = _ref.read(aiRepositoryProvider);
    final userMsg = AiMessage(id: DateTime.now().millisecondsSinceEpoch.toString(), role: 'user', content: content);
    await repo.saveMessage(userMsg);
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, userMsg]);

    // Get AI response
    final aiMsg = await repo.sendMessage(content);
    await repo.saveMessage(aiMsg);
    state = AsyncData([...state.valueOrNull ?? [], aiMsg]);
  }
}
```

- [ ] **Step 3: Create ai_chat_page.dart with disclaimer**

```dart
// lib/features/ai/ai_chat_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_controller.dart';
import 'ai_repository.dart';
import 'widgets/ai_message_bubble.dart';
import 'widgets/ai_disclaimer.dart';

class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    ref.read(chatMessagesProvider.notifier).sendMessage(text);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('AI 学习助手')),
      body: Column(
        children: [
          const AiDisclaimer(),
          Expanded(
            child: messages.when(
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (msgs) => msgs.isEmpty
                ? const Center(child: Text('向AI学习助手提问佛学问题'))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: msgs.length,
                    itemBuilder: (_, i) => AiMessageBubble(message: msgs[i]),
                  ),
            ),
          ),
          _ChatInput(controller: _textController, onSend: _send),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _ChatInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: '输入问题...', border: OutlineInputBorder()),
                onSubmitted: (_) => onSend(),
                textInputAction: TextInputAction.send,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(onPressed: onSend, icon: const Icon(Icons.send)),
          ],
        ),
      ),
    );
  }
}
```

```dart
// lib/features/ai/widgets/ai_message_bubble.dart
import 'package:flutter/material.dart';
import '../ai_repository.dart';

class AiMessageBubble extends StatelessWidget {
  final AiMessage message;
  const AiMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFC9A24A) : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Text(message.content, style: TextStyle(color: isUser ? Colors.white : null, fontSize: 16, height: 1.6)),
      ),
    );
  }
}
```

```dart
// lib/features/ai/widgets/ai_disclaimer.dart
import 'package:flutter/material.dart';

class AiDisclaimer extends StatelessWidget {
  const AiDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color(0xFFC9A24A).withOpacity(0.08),
      child: const Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: Color(0xFFC9A24A)),
          SizedBox(width: 8),
          Expanded(child: Text('AI 内容仅供学习参考，不代表佛法权威解释', style: TextStyle(fontSize: 12, color: Color(0xFFC9A24A)))),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Update router and commit**

---

## Task 18: Notes Feature (Local)

**Files:**
- Create: `lib/features/notes/notes_repository.dart`
- Create: `lib/features/notes/notes_controller.dart`
- Create: `lib/features/notes/notes_page.dart`
- Create: `lib/features/notes/note_detail_page.dart`

**Note:** Local-only for MVP. Notes stored in Hive. Sync-ready structure.

- [ ] Create repository with CRUD operations on Hive `notes` box
- [ ] Create controller with note list + CRUD
- [ ] Create list page with search/filter
- [ ] Create detail/edit page
- [ ] Update router
- [ ] Commit

---

## Task 19: Offline & Polish

**Files:**
- Modify: Various repositories (add cache-first strategies)
- Create: `lib/core/network/connectivity_provider.dart`

**Checklist:**
- [ ] Add connectivity listener to detect offline state
- [ ] Implement cache-first reading for all list pages
- [ ] Add pull-to-refresh on all list pages
- [ ] Ensure all pages render correctly in dark mode
- [ ] Add Semantics labels for accessibility
- [ ] Test landscape layouts
- [ ] Run `flutter analyze` — fix all warnings
- [ ] Run `flutter test` — ensure all tests pass

```bash
cd e:/workspace/claw/cibei_flutter && flutter analyze
```

---

## Task 20: Final Integration & Verification

- [ ] Update `app.dart` with final imports and all providers
- [ ] Verify router: all routes navigate correctly (`flutter run`)
- [ ] Verify auth flow: login → session → favorites
- [ ] Verify offline: enable airplane mode → cached content displays
- [ ] Run full analyze: `flutter analyze` — zero issues
- [ ] Run tests: `flutter test` — all pass
- [ ] Final commit

```bash
git add -A && git commit -m "feat: complete Cibei Space Mobile v1.0.0"
```

---

## Dependency Graph

```
Task 1 (Scaffold)
 └─► Task 2 (Models)
      └─► Task 3 (API Client)
      │    ├─► Task 8 (Home)
      │    ├─► Task 9 (Sutras)
      │    ├─► Task 10 (Stories)
      │    ├─► Task 11 (Dictionary)
      │    ├─► Task 12 (Encyclopedia)
      │    ├─► Task 13 (Auth/Profile)
      │    │    └─► Task 14 (Favorites) [needs auth]
      │    ├─► Task 15 (Search)
      │    ├─► Task 16 (Library Tab)
      │    ├─► Task 17 (AI Chat)
      │    └─► Task 18 (Notes)
      ├─► Task 4 (Theme)
      ├─► Task 5 (Router)
      ├─► Task 6 (Storage)
      └─► Task 7 (Core Widgets)

Task 19 (Offline/Polish) depends on all feature tasks
Task 20 (Final Integration) depends on Task 19
```
