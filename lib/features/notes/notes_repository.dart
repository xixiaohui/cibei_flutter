import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String? sourceType; // sutra, glossary, story
  final String? sourceSlug;
  final bool isHighlight;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.sourceType,
    this.sourceSlug,
    this.isHighlight = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? sourceType,
    String? sourceSlug,
    bool? isHighlight,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      sourceType: sourceType ?? this.sourceType,
      sourceSlug: sourceSlug ?? this.sourceSlug,
      isHighlight: isHighlight ?? this.isHighlight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'sourceType': sourceType,
      'sourceSlug': sourceSlug,
      'isHighlight': isHighlight,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      sourceType: json['sourceType'] as String?,
      sourceSlug: json['sourceSlug'] as String?,
      isHighlight: json['isHighlight'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class NotesRepository {
  final CacheManager _cache;

  NotesRepository(this._cache);

  List<Note> getAllNotes() {
    final rawList = _cache.getAll<Map>(HiveBoxes.notes);
    return rawList
        .map((m) => Note.fromJson(Map<String, dynamic>.from(m)))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Note? getNote(String id) {
    final raw = _cache.get<Map>(HiveBoxes.notes, id);
    if (raw == null) return null;
    return Note.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<void> saveNote(Note note) async {
    await _cache.put(HiveBoxes.notes, note.id, note.toJson());
  }

  Future<void> deleteNote(String id) async {
    await _cache.delete(HiveBoxes.notes, id);
  }

  List<Note> searchNotes(String query) {
    final all = getAllNotes();
    final lower = query.toLowerCase();
    return all.where((note) {
      return note.title.toLowerCase().contains(lower) ||
          note.content.toLowerCase().contains(lower);
    }).toList();
  }
}
