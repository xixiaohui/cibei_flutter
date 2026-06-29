import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_indicator.dart';
import 'favorites_controller.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('我的收藏')),
      body: favorites.when(
        loading: () => const LoadingIndicator(),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
                icon: Icons.favorite_border,
                title: '暂无收藏',
                subtitle: '浏览内容时点击收藏按钮即可添加');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final fav = items[index];
              return Dismissible(
                key: Key(fav.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Theme.of(context).colorScheme.error,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  try {
                    await ref
                        .read(favoritesProvider.notifier)
                        .remove(fav.id);
                    return true;
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('删除失败：$e')),
                      );
                    }
                    return false;
                  }
                },
                child: ListTile(
                  leading: Icon(_typeIcon(fav.type)),
                  title: Text(fav.title),
                  subtitle: fav.subtitle != null ? Text(fav.subtitle!) : null,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/${fav.type}/${fav.slug}'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _typeIcon(String type) {
    return switch (type) {
      'sutra' => Icons.menu_book,
      'glossary' => Icons.bookmark,
      'story' => Icons.auto_stories,
      'encyclopedia' => Icons.account_balance,
      _ => Icons.favorite,
    };
  }
}
