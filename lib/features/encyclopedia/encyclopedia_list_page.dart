import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../../shared/models/encyclopedia_entry.dart';
import 'encyclopedia_controller.dart';

class EncyclopediaListPage extends ConsumerStatefulWidget {
  const EncyclopediaListPage({super.key});

  @override
  ConsumerState<EncyclopediaListPage> createState() =>
      _EncyclopediaListPageState();
}

class _EncyclopediaListPageState extends ConsumerState<EncyclopediaListPage> {
  String? _selectedCategory;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(encyclopediaListControllerProvider(_selectedCategory).notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(encyclopediaListControllerProvider(_selectedCategory));
    final categoriesAsync = ref.watch(encyclopediaCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('佛学百科')),
      body: Column(
        children: [
          // Category filter
          SizedBox(
            height: 44,
            child: categoriesAsync.when(
              loading: () => const Center(
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))),
              error: (_, __) => const SizedBox.shrink(),
              data: (categories) => ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isAll = index == 0;
                  final category = isAll ? null : categories[index - 1];
                  final isSelected = _selectedCategory == category;
                  return FilterChip(
                    label: Text(isAll ? '全部' : category!),
                    selected: isSelected,
                    onSelected: (_) {
                      _scrollController.jumpTo(0);
                      setState(() => _selectedCategory = category);
                    },
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: state.when(
              loading: () => const LoadingIndicator(),
              error: (err, _) => ErrorDisplay(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(
                      encyclopediaListControllerProvider(_selectedCategory))),
              data: (data) => RefreshIndicator(
                onRefresh: () async => ref.invalidate(
                    encyclopediaListControllerProvider(_selectedCategory)),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 32),
                  itemCount:
                      data.entries.length + (data.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= data.entries.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child:
                                CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    final entry = data.entries[index];
                    return _EncyclopediaCard(
                        entry: entry,
                        onTap: () =>
                            context.push('/encyclopedia/${entry.slug}'));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _EncyclopediaCard extends StatelessWidget {
  final EncyclopediaEntry entry;
  final VoidCallback? onTap;
  const _EncyclopediaCard({required this.entry, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '百科: ${entry.title}',
      button: true,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (entry.category != null) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      entry.category!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(entry.title,
                    style: Theme.of(context).textTheme.headlineMedium),
                if (entry.content.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    entry.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
