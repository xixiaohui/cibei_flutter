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
  static String pathSteps(String pathId) => '/api/paths/$pathId/steps';

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
