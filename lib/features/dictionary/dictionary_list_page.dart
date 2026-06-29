import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../../shared/models/glossary_term.dart';
import 'dictionary_controller.dart';

class DictionaryListPage extends ConsumerStatefulWidget {
  const DictionaryListPage({super.key});

  @override
  ConsumerState<DictionaryListPage> createState() =>
      _DictionaryListPageState();
}

class _DictionaryListPageState extends ConsumerState<DictionaryListPage> {
  String? _selectedLetter;
  final _scrollController = ScrollController();

  static const _letters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(dictionaryListControllerProvider(_selectedLetter).notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dictionaryListControllerProvider(_selectedLetter));

    return Scaffold(
      appBar: AppBar(title: const Text('佛学辞典')),
      body: Column(
        children: [
          // Letter filter
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _letters.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final letter = isAll ? null : _letters[index - 1];
                final isSelected = _selectedLetter == letter;
                return FilterChip(
                  label: Text(isAll ? '全部' : letter!),
                  selected: isSelected,
                  onSelected: (_) {
                    _scrollController.jumpTo(0);
                    setState(() => _selectedLetter = letter);
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: state.when(
              loading: () => const LoadingIndicator(),
              error: (err, _) => ErrorDisplay(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(
                      dictionaryListControllerProvider(_selectedLetter))),
              data: (data) => RefreshIndicator(
                onRefresh: () async => ref.invalidate(
                    dictionaryListControllerProvider(_selectedLetter)),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 32),
                  itemCount:
                      data.terms.length + (data.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= data.terms.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child:
                                CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    final term = data.terms[index];
                    return _GlossaryCard(
                        term: term,
                        onTap: () =>
                            context.push('/glossary/${term.slug}'));
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

class _GlossaryCard extends StatelessWidget {
  final GlossaryTerm term;
  final VoidCallback? onTap;
  const _GlossaryCard({required this.term, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(term.term,
                  style: Theme.of(context).textTheme.headlineMedium),
              if (term.termEn != null || term.termSanskrit != null) ...[
                const SizedBox(height: 4),
                Text(
                  [term.termEn, term.termSanskrit]
                      .whereType<String>()
                      .join(' / '),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
              if (term.definition.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  term.definition,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
