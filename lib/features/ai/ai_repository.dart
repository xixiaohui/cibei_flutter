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

  AiMessage({
    required this.id,
    required this.role,
    required this.content,
    this.references = const [],
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role,
        'content': content,
        'references': references,
        'timestamp': timestamp.toIso8601String(),
      };

  factory AiMessage.fromJson(Map<String, dynamic> json) => AiMessage(
        id: json['id'] as String,
        role: json['role'] as String,
        content: json['content'] as String,
        references: (json['references'] as List?)?.cast<String>() ?? [],
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

class AiRepository {
  final CacheManager _cache;

  AiRepository(this._cache);

  Future<List<AiMessage>> getHistory() async {
    final data = _cache.get<String>(HiveBoxes.chatHistory, 'messages');
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.map((j) => AiMessage.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> saveMessage(AiMessage message) async {
    final history = await getHistory();
    history.add(message);
    await _cache.put(
      HiveBoxes.chatHistory,
      'messages',
      jsonEncode(history.map((m) => m.toJson()).toList()),
    );
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
