import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/loading_indicator.dart';
import 'notes_controller.dart';

class NoteDetailPage extends ConsumerStatefulWidget {
  final String? id;
  const NoteDetailPage({super.key, this.id});

  @override
  ConsumerState<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends ConsumerState<NoteDetailPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _initialized = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      ref.listen(noteDetailProvider(widget.id!), (prev, next) {
        if (next.hasValue && next.value != null && !_initialized) {
          _titleController.text = next.value!.title;
          _contentController.text = next.value!.content;
          _initialized = true;
        }
      });
    }

    final isNew = widget.id == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? '新建笔记' : '编辑笔记'),
        actions: [
          _saving
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _save,
                ),
        ],
      ),
      body: widget.id != null
          ? ref.watch(noteDetailProvider(widget.id!)).when(
                loading: () => const LoadingIndicator(),
                error: (err, _) => Center(child: Text(err.toString())),
                data: (_) => _buildEditor(isNew),
              )
          : _buildEditor(isNew),
    );
  }

  Widget _buildEditor(bool isNew) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: '标题',
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.headlineSmall,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: '开始记录...',
                border: InputBorder.none,
              ),
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入标题')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      await ref.read(notesProvider.notifier).save(
            id: widget.id,
            title: title,
            content: content,
          );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败：$e')),
        );
        setState(() => _saving = false);
      }
    }
  }
}
