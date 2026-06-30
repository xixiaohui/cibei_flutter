import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../../core/theme/theme_provider.dart';
import '../history/reading_history_page.dart';
import 'sutra_controller.dart';
import 'widgets/reading_toolbar.dart';

class SutraReadingPage extends ConsumerWidget {
  final String slug;
  const SutraReadingPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(sutraContentControllerProvider(slug));
    ref.listen(sutraContentControllerProvider(slug), (_, next) {
      next.whenOrNull(data: (c) {
        ref.read(readingHistoryRepositoryProvider).addEntry(
              type: 'sutra', slug: slug, title: c.title);
      });
    });
    final fontSize = ref.watch(fontSizeProvider);
    final lineHeight = ref.watch(lineHeightProvider);
    final width = ref.watch(readingWidthProvider);
    final isNight = ref.watch(isNightModeProvider);

    final isDark = isNight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : Colors.transparent;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : null,
      appBar: AppBar(
        title: Text(content.valueOrNull?.title ?? '阅读'),
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : null,
      ),
      body: content.when(
        loading: () => const LoadingIndicator(),
        error: (err, _) => ErrorDisplay(message: err.toString()),
        data: (c) => RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(sutraContentControllerProvider(slug)),
          child: Center(
            child: Container(
              color: bgColor,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * width,
                child: Markdown(
                  data: c.content,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                        fontSize: fontSize,
                        height: lineHeight,
                        color: textColor),
                    h1: TextStyle(
                        fontSize: fontSize + 10,
                        fontWeight: FontWeight.w700,
                        color: textColor),
                    h2: TextStyle(
                        fontSize: fontSize + 6,
                        fontWeight: FontWeight.w600,
                        color: textColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const ReadingToolbar(),
    );
  }
}
