import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A button that navigates to the poster preview page,
/// where users can preview, share (WeChat), or save the poster.
///
/// [type] — poster content type: 'sutra', 'dictionary', 'encyclopedia', 'story'
/// [slug] — content identifier
/// [title] — content title
class SharePosterButton extends StatelessWidget {
  final String type;
  final String slug;
  final String title;

  const SharePosterButton({
    super.key,
    required this.type,
    required this.slug,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      tooltip: '分享海报',
      onPressed: () {
        context.push(
          '/poster/$type/$slug',
          extra: title,
        );
      },
    );
  }
}
