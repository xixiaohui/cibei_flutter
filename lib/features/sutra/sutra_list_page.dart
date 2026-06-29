import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../../shared/components/sutra_card.dart';
import 'sutra_controller.dart';

class SutraListPage extends ConsumerStatefulWidget {
  const SutraListPage({super.key});

  @override
  ConsumerState<SutraListPage> createState() => _SutraListPageState();
}

class _SutraListPageState extends ConsumerState<SutraListPage> {
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
          .read(sutraListControllerProvider(_selectedCategory).notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sutraListControllerProvider(_selectedCategory));
    final categories = ref.watch(sutraCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('经典文库')),
      body: Column(
        children: [
          // Category filter
          categories.when(
            data: (cats) => SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cats.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isAll = index == 0;
                  final cat = isAll ? null : cats[index - 1];
                  final isSelected = _selectedCategory == cat;
                  return FilterChip(
                    label: Text(isAll ? '全部' : cat!),
                    selected: isSelected,
                    onSelected: (_) {
                      _scrollController.jumpTo(0);
                      setState(() => _selectedCategory = cat);
                    },
                  );
                },
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(height: 1),
          Expanded(
            child: state.when(
              loading: () => const LoadingIndicator(),
              error: (err, _) => ErrorDisplay(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(
                      sutraListControllerProvider(_selectedCategory))),
              data: (data) => RefreshIndicator(
                onRefresh: () async => ref.invalidate(
                    sutraListControllerProvider(_selectedCategory)),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 32),
                  itemCount:
                      data.sutras.length + (data.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= data.sutras.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child:
                            Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    final sutra = data.sutras[index];
                    return SutraCard(
                        sutra: sutra,
                        onTap: () => context.push('/sutra/${sutra.slug}'));
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
