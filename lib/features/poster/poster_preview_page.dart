import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import '../../core/api/poster_repository.dart';

/// Poster preview page — downloads and displays a share poster,
/// with options to share via WeChat or save to gallery.
class PosterPreviewPage extends ConsumerStatefulWidget {
  final String type;
  final String slug;
  final String title;

  const PosterPreviewPage({
    super.key,
    required this.type,
    required this.slug,
    required this.title,
  });

  @override
  ConsumerState<PosterPreviewPage> createState() => _PosterPreviewPageState();
}

class _PosterPreviewPageState extends ConsumerState<PosterPreviewPage> {
  late final Future<String> _posterFuture;
  bool _isSharing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _posterFuture = _download();
  }

  Future<String> _download() {
    return ref
        .read(posterRepositoryProvider)
        .downloadPoster(widget.type, widget.slug);
  }

  Future<void> _shareToWechat() async {
    setState(() => _isSharing = true);
    try {
      final path = await _posterFuture;
      await Share.shareXFiles(
        [XFile(path)],
        subject: widget.title,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('分享失败: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _saveToGallery() async {
    setState(() => _isSaving = true);
    try {
      final path = await _posterFuture;
      await Gal.putImage(path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('已保存到相册'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } on GalException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: ${e.type.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        surfaceTintColor: Colors.transparent,
      ),
      body: FutureBuilder<String>(
        future: _posterFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white70),
                  SizedBox(height: 16),
                  Text('正在生成海报...',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: Colors.white38),
                  const SizedBox(height: 16),
                  Text('生成海报失败: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(
                          () => _posterFuture = _download());
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }

          final path = snapshot.data!;
          return InteractiveViewer(
            maxScale: 3.0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Image.file(
                  File(path),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isSaving ? null : _saveToGallery,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: Text(_isSaving ? '保存中...' : '保存相册'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _isSharing ? null : _shareToWechat,
                  icon: _isSharing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.wechat),
                  label: Text(_isSharing ? '分享中...' : '分享微信'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF07C160),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
