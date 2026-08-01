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
    final systemIsDark = Theme.of(context).brightness == Brightness.dark;

    // 夜间模式 = 手动切换 或 系统暗色模式
    final isDark = isNight || systemIsDark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : Colors.transparent;
    final surfaceColor = isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100;
    final hintColor = isDark ? Colors.white70 : Colors.black54;

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
                  styleSheet: _buildMarkdownStyle(
                    isDark: isDark,
                    fontSize: fontSize,
                    lineHeight: lineHeight,
                    textColor: textColor,
                    surfaceColor: surfaceColor,
                    hintColor: hintColor,
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

MarkdownStyleSheet _buildMarkdownStyle({
  required bool isDark,
  required double fontSize,
  required double lineHeight,
  required Color textColor,
  required Color surfaceColor,
  required Color hintColor,
}) {
  final pStyle = TextStyle(fontSize: fontSize, height: lineHeight, color: textColor);
  final h1Style = TextStyle(fontSize: fontSize + 10, fontWeight: FontWeight.w700, color: textColor);
  final h2Style = TextStyle(fontSize: fontSize + 6, fontWeight: FontWeight.w600, color: textColor);
  final h3Style = TextStyle(fontSize: fontSize + 4, fontWeight: FontWeight.w600, color: textColor);
  final h4Style = TextStyle(fontSize: fontSize + 2, fontWeight: FontWeight.w600, color: textColor);
  final h5Style = TextStyle(fontSize: fontSize + 1, fontWeight: FontWeight.w600, color: textColor);
  final h6Style = TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600, color: textColor);
  final codeStyle = TextStyle(
    fontSize: fontSize * 0.9,
    fontFamily: 'monospace',
    color: textColor,
    backgroundColor: surfaceColor,
  );

  return MarkdownStyleSheet(
    p: pStyle,
    h1: h1Style,
    h2: h2Style,
    h3: h3Style,
    h4: h4Style,
    h5: h5Style,
    h6: h6Style,
    em: const TextStyle(fontStyle: FontStyle.italic),
    strong: const TextStyle(fontWeight: FontWeight.bold),
    del: const TextStyle(decoration: TextDecoration.lineThrough),
    a: const TextStyle(color: Color(0xFFC9A24A)),
    code: codeStyle,
    blockquote: TextStyle(fontSize: fontSize, height: lineHeight, color: hintColor),
    blockquoteDecoration: BoxDecoration(
      color: surfaceColor,
      border: const Border(left: BorderSide(color: Color(0xFFC9A24A), width: 3)),
      borderRadius: BorderRadius.circular(4),
    ),
    blockquotePadding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
    codeblockDecoration: BoxDecoration(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(6),
    ),
    codeblockPadding: const EdgeInsets.all(12),
    blockSpacing: 8.0,
    listIndent: 24.0,
    listBullet: pStyle,
    horizontalRuleDecoration: BoxDecoration(
      border: Border(top: BorderSide(color: isDark ? Colors.white24 : Colors.black12)),
    ),
    tableBorder: TableBorder.all(color: isDark ? Colors.white24 : Colors.black12),
    tableHead: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600, color: textColor),
    tableBody: pStyle,
    tableHeadAlign: TextAlign.center,
    tablePadding: const EdgeInsets.only(bottom: 8),
    tableColumnWidth: const FlexColumnWidth(),
    tableCellsPadding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
    tableCellsDecoration: BoxDecoration(
      color: surfaceColor,
    ),
  );
}
