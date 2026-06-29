// lib/features/ai/ai_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/cache_manager.dart';
import 'ai_repository.dart';

final aiRepositoryProvider = Provider((ref) {
  return AiRepository(ref.read(cacheManagerProvider));
});

final chatMessagesProvider =
    StateNotifierProvider<ChatController, AsyncValue<List<AiMessage>>>((ref) {
  return ChatController(ref);
});

class ChatController extends StateNotifier<AsyncValue<List<AiMessage>>> {
  final Ref _ref;

  ChatController(this._ref) : super(const AsyncLoading()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref.read(aiRepositoryProvider).getHistory(),
    );
  }

  Future<void> sendMessage(String content) async {
    final repo = _ref.read(aiRepositoryProvider);
    final userMsg = AiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: content,
    );
    await repo.saveMessage(userMsg);
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, userMsg]);

    // Get AI response
    try {
      final aiMsg = await repo.sendMessage(content);
      await repo.saveMessage(aiMsg);
      state = AsyncData([...state.valueOrNull ?? [], aiMsg]);
    } catch (e) {
      final errorMsg = AiMessage(
        id: 'err_${DateTime.now().millisecondsSinceEpoch}',
        role: 'assistant',
        content: '抱歉，AI 响应失败，请稍后重试。',
      );
      await repo.saveMessage(errorMsg);
      state = AsyncData([...state.valueOrNull ?? [], errorMsg]);
    }
  }
}
