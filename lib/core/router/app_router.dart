import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/home/home_page.dart';
import '../../features/home/library_page.dart';
import '../../features/sutra/sutra_detail_page.dart';
import '../../features/sutra/sutra_list_page.dart';
import '../../features/sutra/sutra_reading_page.dart';
import '../../features/stories/story_list_page.dart';
import '../../features/stories/story_detail_page.dart';
import '../../features/dictionary/dictionary_detail_page.dart';
import '../../features/dictionary/dictionary_list_page.dart';
import '../../features/encyclopedia/encyclopedia_detail_page.dart';
import '../../features/encyclopedia/encyclopedia_list_page.dart';
import '../../features/profile/login_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/profile/settings_page.dart';
import '../../features/favorites/favorites_page.dart';
import '../../features/search/search_page.dart';
import '../../features/ai/ai_chat_page.dart';
import '../../features/notes/notes_page.dart';
import '../../features/notes/note_detail_page.dart';

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
        return _ScaffoldWithNavShell(
            currentLocation: state.uri.toString(), child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: RouteNames.home,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomePage(),
          ),
        ),
        GoRoute(
          path: '/library',
          name: RouteNames.library,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LibraryPage(),
          ),
        ),
        GoRoute(
          path: '/stories',
          name: RouteNames.stories,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: StoryListPage(),
          ),
        ),
        GoRoute(
          path: '/ai',
          name: RouteNames.ai,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AiChatPage(),
          ),
        ),
        GoRoute(
          path: '/profile',
          name: RouteNames.profile,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfilePage(),
          ),
        ),
      ],
    ),
    // Detail routes (outside shell — full screen)
    GoRoute(
      path: '/sutra/:slug',
      name: RouteNames.sutraDetail,
      builder: (context, state) =>
          SutraDetailPage(slug: state.pathParameters['slug']!),
    ),
    GoRoute(
      path: '/sutra/:slug/read',
      name: RouteNames.sutraRead,
      builder: (context, state) =>
          SutraReadingPage(slug: state.pathParameters['slug']!),
    ),
    GoRoute(
      path: '/sutras',
      name: RouteNames.sutraList,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SutraListPage(),
      ),
    ),
    GoRoute(
      path: '/glossary',
      name: RouteNames.glossaryList,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: DictionaryListPage(),
      ),
    ),
    GoRoute(
      path: '/glossary/:slug',
      name: RouteNames.glossaryDetail,
      builder: (context, state) =>
          DictionaryDetailPage(slug: state.pathParameters['slug']!),
    ),
    GoRoute(
      path: '/encyclopedia',
      name: RouteNames.encyclopediaList,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: EncyclopediaListPage(),
      ),
    ),
    GoRoute(
      path: '/encyclopedia/:slug',
      name: RouteNames.encyclopediaDetail,
      builder: (context, state) =>
          EncyclopediaDetailPage(slug: state.pathParameters['slug']!),
    ),
    GoRoute(
      path: '/story/:slug',
      name: RouteNames.storyDetail,
      builder: (context, state) =>
          StoryDetailPage(slug: state.pathParameters['slug']!),
    ),
    GoRoute(
      path: '/search',
      name: RouteNames.search,
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: '/favorites',
      name: RouteNames.favorites,
      builder: (context, state) => const FavoritesPage(),
    ),
    GoRoute(
      path: '/notes',
      name: RouteNames.notes,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: NotesPage(),
      ),
    ),
    GoRoute(
      path: '/note/new',
      builder: (context, state) => const NoteDetailPage(id: null),
    ),
    GoRoute(
      path: '/note/:id',
      name: RouteNames.noteDetail,
      builder: (context, state) =>
          NoteDetailPage(id: state.pathParameters['id']),
    ),
    GoRoute(
      path: '/settings',
      name: RouteNames.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/login',
      name: RouteNames.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/paths/:slug',
      name: RouteNames.pathDetail,
      builder: (context, state) =>
          _PlaceholderPage('Path: ${state.pathParameters['slug']}'),
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
  const _ScaffoldWithNavShell(
      {required this.child, required this.currentLocation});

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
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: '首页'),
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: '文库'),
          NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined),
              selectedIcon: Icon(Icons.auto_stories),
              label: '故事'),
          NavigationDestination(
              icon: Icon(Icons.psychology_outlined),
              selectedIcon: Icon(Icons.psychology),
              label: 'AI'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: '我的'),
        ],
      ),
    );
  }
}
