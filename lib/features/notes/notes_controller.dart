import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/cache_manager.dart';
import 'notes_repository.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository(ref.read(cacheManagerProvider));
});

final notesProvider =
    AsyncNotifierProvider<NotesController, List<Note>>(NotesController.new);

final noteDetailProvider = FutureProvider.family<Note?, String>((ref, id) {
  return ref.read(notesRepositoryProvider).getNote(id);
});

class NotesController extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() async {
    return ref.read(notesRepositoryProvider).getAllNotes();
  }

  Future<void> save({
    String? id,
    required String title,
    required String content,
    String? sourceType,
    String? sourceSlug,
    bool isHighlight = false,
  }) async {
    final repository = ref.read(notesRepositoryProvider);
    final now = DateTime.now();

    final Note? existing =
        id != null ? repository.getNote(id) : null;

    final note = Note(
      id: id ?? 'note_${now.millisecondsSinceEpoch}',
      title: title,
      content: content,
      sourceType: sourceType ?? existing?.sourceType,
      sourceSlug: sourceSlug ?? existing?.sourceSlug,
      isHighlight: isHighlight,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    await repository.saveNote(note);
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    await ref.read(notesRepositoryProvider).deleteNote(id);
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
