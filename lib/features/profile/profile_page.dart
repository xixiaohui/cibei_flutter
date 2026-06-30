import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: user.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (_, __) => const Center(child: Text('加载失败')),
        data: (u) {
          if (u == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline,
                      size: 80,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text('登录以同步数据'),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => context.push('/login'),
                    child: const Text('登录 / 注册'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(currentUserProvider),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      u.image != null ? NetworkImage(u.image!) : null,
                  child: u.image == null ? Text(u.name?[0] ?? '?') : null,
                ),
                const SizedBox(height: 12),
                Text(u.name ?? u.email,
                    style: Theme.of(context).textTheme.headlineMedium),
                const Divider(height: 32),
                _menuItem(context, '我的收藏', Icons.favorite_border,
                    () => context.push('/favorites')),
                _menuItem(context, '我的笔记', Icons.edit_note,
                    () => context.push('/notes')),
                _menuItem(context, '阅读历史', Icons.history,
                    () => context.push('/history')),
                _menuItem(context, '学习统计', Icons.bar_chart,
                    () => context.push('/stats')),
                _menuItem(context, '设置', Icons.settings_outlined,
                    () => context.push('/settings')),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () async {
                    try {
                      await ref.read(authRepositoryProvider).signOut();
                    } catch (_) {
                      // Ignore — signOut clears cookies regardless of server response
                    }
                    ref.invalidate(sessionProvider);
                  },
                  child: const Text('退出登录'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, IconData icon,
      VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
