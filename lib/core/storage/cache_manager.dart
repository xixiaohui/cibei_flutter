import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'hive_boxes.dart';

class CacheManager {
  static const int maxCacheSizeBytes = 500 * 1024 * 1024; // 500MB

  Future<void> init() async {
    for (final boxName in HiveBoxes.all) {
      await Hive.openBox(boxName);
    }
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
    for (final boxName in HiveBoxes.all) {
      final box = Hive.box(boxName);
      await box.clear();
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

final cacheManagerProvider = Provider<CacheManager>((ref) {
  return CacheManager();
});
