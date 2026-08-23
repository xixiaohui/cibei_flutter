import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../shared/models/story.dart';
import '../../core/widgets/responsive.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback? onTap;
  const StoryCard({super.key, required this.story, this.onTap});

  @override
  Widget build(BuildContext context) {
    // iPad 等大屏上图片更高,内容更舒展
    final imageHeight = Responsive.isTablet(context) ? 220.0 : 160.0;
    return Semantics(
      label: '故事: ${story.title}',
      button: true,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (story.imageUrl != null)
                CachedNetworkImage(
                  imageUrl: story.imageUrl!,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => SizedBox(
                      height: imageHeight,
                      child:
                          Center(child: CircularProgressIndicator(strokeWidth: 2))),
                  errorWidget: (_, __, ___) => SizedBox(
                      height: imageHeight,
                      child: Center(child: Icon(Icons.image_outlined))),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC9A24A).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(story.category,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFFC9A24A))),
                        ),
                        if (story.sourceSutra != null) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              story.sourceSutra!,
                              style: Theme.of(context).textTheme.labelMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(story.title,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      story.summary,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
