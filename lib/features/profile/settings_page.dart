import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          const _SectionHeader('外观'),
          ListTile(
            title: const Text('深色模式'),
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                    value: ThemeMode.system, label: Text('跟随系统')),
                ButtonSegment(value: ThemeMode.light, label: Text('浅色')),
                ButtonSegment(value: ThemeMode.dark, label: Text('深色')),
              ],
              selected: {themeMode},
              onSelectionChanged: (v) =>
                  ref.read(themeModeProvider.notifier).state = v.first,
            ),
          ),
          const _SectionHeader('阅读'),
          ListTile(
              title: const Text('字体大小'), trailing: const Text('默认')),
          ListTile(title: const Text('行间距'), trailing: const Text('1.8')),
          const _SectionHeader('数据'),
          ListTile(title: const Text('清除缓存'), onTap: () {}),
          ListTile(
              title: const Text('离线内容'),
              trailing: const Text('已缓存 0MB')),
          const _SectionHeader('关于'),
          ListTile(title: const Text('版本'), trailing: const Text('1.0.0')),
          ListTile(
            title: const Text('Cibei Space'),
            subtitle: const Text('https://cibei.space'),
          ),
        ],
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
