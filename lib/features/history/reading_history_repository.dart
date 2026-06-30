import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';

class ReadingHistoryEntry {
  final String type;
  final String slug;
  final String title;
  final DateTime timestamp;

  const ReadingHistoryEntry({
    required this.type,
    required this.slug,
    required this.title,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'slug': slug,
        'title': title,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ReadingHistoryEntry.fromJson(Map<String, dynamic> json) =>
      ReadingHistoryEntry(
        type: json['type'] as String,
        slug: json['slug'] as String,
        title: json['title'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

class ReadingHistoryRepository {
  final CacheManager _cache;

  ReadingHistoryRepository(this._cache);

  List<ReadingHistoryEntry> getAll() {
    final raw = _cache.getAll<Map>(HiveBoxes.readingHistory);
    return raw
        .map((m) => ReadingHistoryEntry.fromJson(Map<String, dynamic>.from(m)))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> addEntry({
    required String type,
    required String slug,
    required String title,
  }) async {
    // Remove existing entry for same type+slug (dedup)
    final all = getAll();
    all.removeWhere((e) => e.type == type && e.slug == slug);

    final entry = ReadingHistoryEntry(
      type: type,
      slug: slug,
      title: title,
      timestamp: DateTime.now(),
    );
    all.insert(0, entry);

    // Keep max 200 entries
    if (all.length > 200) {
      all.removeRange(200, all.length);
    }

    final map = <String, Map<String, dynamic>>{};
    for (int i = 0; i < all.length; i++) {
      map['$i'] = all[i].toJson();
    }

    await _cache.clear(HiveBoxes.readingHistory);
    await _cache.putAll(HiveBoxes.readingHistory, map);
  }

  Future<void> clearAll() async {
    await _cache.clear(HiveBoxes.readingHistory);
  }

  int getCount() {
    return _cache.getAll<Map>(HiveBoxes.readingHistory).length;
  }
}
