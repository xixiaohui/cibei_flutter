import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'search_controller.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results =
        _query.isNotEmpty ? ref.watch(searchResultsProvider(_query)) : null;
    final recent = ref.watch(recentSearchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
              hintText: '搜索经典、词典、百科、故事...', border: InputBorder.none),
          onSubmitted: (v) => setState(() => _query = v.trim()),
          textInputAction: TextInputAction.search,
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: _query.isEmpty
          ? recent.when(
              data: (items) => ListView(
                children: [
                  if (items.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('最近搜索',
                              style: Theme.of(context).textTheme.labelMedium),
                          TextButton(
                            onPressed: () => ref
                                .read(searchRepositoryProvider)
                                .clearRecentSearches()
                                .then((_) =>
                                    ref.invalidate(recentSearchesProvider)),
                            child: const Text('清除'),
                          ),
                        ],
                      ),
                    ),
                    ...items.map(
                      (q) => ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(q),
                        onTap: () {
                          _controller.text = q;
                          setState(() => _query = q);
                        },
                      ),
                    ),
                  ],
                ],
              ),
              loading: () =>
                  const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              error: (_, __) => const SizedBox.shrink(),
            )
          : results?.when(
                loading: () => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2)),
                error: (e, _) => Center(child: Text(e.toString())),
                data: (resp) => resp.results.isEmpty
                    ? const Center(child: Text('未找到相关结果'))
                    : ListView.builder(
                        itemCount: resp.results.length,
                        itemBuilder: (context, index) {
                          final r = resp.results[index];
                          return ListTile(
                            leading: Icon(_typeIcon(r.type)),
                            title: Text(r.title),
                            subtitle: Text(r.excerpt,
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                            trailing: Text(r.type,
                                style: Theme.of(context).textTheme.labelMedium),
                            onTap: () => context.push('/${r.type}/${r.slug}'),
                          );
                        },
                      ),
              ) ??
              const SizedBox.shrink(),
    );
  }

  IconData _typeIcon(String type) {
    return switch (type) {
      'sutra' => Icons.menu_book,
      'glossary' => Icons.bookmark,
      'story' => Icons.auto_stories,
      'encyclopedia' => Icons.account_balance,
      _ => Icons.search,
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
