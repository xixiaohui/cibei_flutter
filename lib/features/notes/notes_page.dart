import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_indicator.dart';
import 'notes_controller.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的笔记'),
      ),
      body: Column(
        children: [
          _SearchBar(
            onChanged: (query) {
              setState(() => _searchQuery = query);
            },
          ),
          Expanded(
            child: notesAsync.when(
              loading: () => const LoadingIndicator(),
              error: (err, _) => Center(child: Text(err.toString())),
              data: (notes) {
                final filteredNotes = _searchQuery.isEmpty
                    ? notes
                    : notes
                        .where((n) =>
                            n.title
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()) ||
                            n.content
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()))
                        .toList();
                if (filteredNotes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.note_outlined,
                            size: 64,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        Text(_searchQuery.isEmpty ? '暂无笔记' : '未找到匹配的笔记',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        Text(
                            _searchQuery.isEmpty ? '点击右下角按钮创建你的第一条笔记' : '尝试其他关键词搜索',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
                    final snippet = note.content.length > 80
                        ? '${note.content.substring(0, 80)}...'
                        : note.content;
                    final dateStr =
                        '${note.updatedAt.year}-${note.updatedAt.month.toString().padLeft(2, '0')}-${note.updatedAt.day.toString().padLeft(2, '0')}';

                    return Dismissible(
                      key: Key(note.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Theme.of(context).colorScheme.error,
                        child:
                            const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        try {
                          await ref
                              .read(notesProvider.notifier)
                              .delete(note.id);
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
                        leading: _SourceIcon(sourceType: note.sourceType),
                        title: Text(note.title,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (snippet.isNotEmpty)
                              Text(snippet,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(dateStr,
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/note/${note.id}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/note/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.onChanged});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _controller = TextEditingController();
  bool _showClear = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: '搜索笔记...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _showClear
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                    setState(() => _showClear = false);
                  },
                )
              : null,
          filled: true,
          fillColor: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (value) {
          setState(() => _showClear = value.isNotEmpty);
          widget.onChanged(value);
        },
      ),
    );
  }
}

class _SourceIcon extends StatelessWidget {
  final String? sourceType;
  const _SourceIcon({this.sourceType});

  @override
  Widget build(BuildContext context) {
    return Icon(switch (sourceType) {
      'sutra' => Icons.menu_book,
      'glossary' => Icons.bookmark,
      'story' => Icons.auto_stories,
      _ => Icons.note,
    });
  }
}
