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
