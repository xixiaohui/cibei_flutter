import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String _cacheSize = '计算中...';

  @override
  void initState() {
    super.initState();
    _updateCacheSize();
  }

  Future<void> _updateCacheSize() async {
    int totalBytes = 0;
    for (final boxName in HiveBoxes.all) {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        totalBytes += await _boxSize(box);
      }
    }
    if (mounted) {
      setState(() {
        if (totalBytes < 1024) {
          _cacheSize = '${totalBytes} B';
        } else if (totalBytes < 1024 * 1024) {
          _cacheSize = '${(totalBytes / 1024).toStringAsFixed(1)} KB';
        } else {
          _cacheSize = '${(totalBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
        }
      });
    }
  }

  Future<int> _boxSize(Box box) async {
    int size = 0;
    for (final key in box.keys) {
      final value = box.get(key);
      if (value is String) {
        size += value.length;
      } else if (value is List) {
        size += value.length * 8; // approximate
      } else {
        size += 200; // rough estimate for Map/other
      }
    }
    return size;
  }

  Future<void> _clearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('清除缓存'),
        content: Text('当前缓存大小: $_cacheSize\n\n确定要清除所有缓存数据吗？（不会删除笔记和收藏）'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    // Keep notes, favorites, reading history, settings
    const keepBoxes = {
      HiveBoxes.notes,
      HiveBoxes.readingHistory,
      HiveBoxes.userSettings,
    };

    for (final boxName in HiveBoxes.all) {
      if (!keepBoxes.contains(boxName) && Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        await box.clear();
      }
    }

    _updateCacheSize();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('缓存已清除'), duration: Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final lineHeight = ref.watch(lineHeightProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          const _SectionHeader('外观'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('深色模式', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('选择应用的主题模式',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color)),
                const SizedBox(height: 12),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                        value: ThemeMode.system, label: Text('跟随系统')),
                    ButtonSegment(
                        value: ThemeMode.light, label: Text('浅色')),
                    ButtonSegment(
                        value: ThemeMode.dark, label: Text('深色')),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (v) =>
                      ref.read(themeModeProvider.notifier).state = v.first,
                ),
              ],
            ),
          ),
          const _SectionHeader('阅读'),
          ListTile(
            title: const Text('字体大小'),
            trailing: Text('${fontSize.toInt()}pt'),
            onTap: () => _showFontSizeDialog(context, ref),
          ),
          ListTile(
            title: const Text('行间距'),
            trailing: Text(lineHeight.toStringAsFixed(1)),
            onTap: () => _showLineHeightDialog(context, ref),
          ),
          const _SectionHeader('数据'),
          ListTile(
            title: const Text('清除缓存'),
            subtitle: Text('当前: $_cacheSize'),
            onTap: _clearCache,
          ),
          ListTile(
              title: const Text('离线内容'),
              trailing: Text('已缓存 $_cacheSize')),
          const _SectionHeader('关于'),
          ListTile(title: const Text('版本'), trailing: const Text('1.0.0')),
          ListTile(
            title: const Text('Cibei Space'),
            subtitle: const Text('https://cibei.space'),
            trailing: const Icon(Icons.open_in_new, size: 16),
            onTap: () async {
              await launchUrl(Uri.parse('https://cibei.space'),
                  mode: LaunchMode.externalApplication);
            },
          ),
        ],
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context, WidgetRef ref) {
    final current = ref.read(fontSizeProvider);
    final options = [14.0, 16.0, 18.0, 20.0, 22.0, 24.0, 26.0, 28.0];
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('选择字体大小'),
        children: options
            .map((s) => RadioListTile<double>(
                  title: Text('${s.toInt()}pt'),
                  value: s,
                  groupValue: current,
                  onChanged: (v) {
                    ref.read(fontSizeProvider.notifier).state = v!;
                    Navigator.pop(ctx);
                  },
                ))
            .toList(),
      ),
    );
  }

  void _showLineHeightDialog(BuildContext context, WidgetRef ref) {
    final current = ref.read(lineHeightProvider);
    final options = [1.4, 1.6, 1.8, 2.0, 2.2, 2.5, 2.8];
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('选择行间距'),
        children: options
            .map((h) => RadioListTile<double>(
                  title: Text(h.toStringAsFixed(1)),
                  value: h,
                  groupValue: current,
                  onChanged: (v) {
                    ref.read(lineHeightProvider.notifier).state = v!;
                    Navigator.pop(ctx);
                  },
                ))
            .toList(),
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
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(fontSize: 13)),
    );
  }
}
