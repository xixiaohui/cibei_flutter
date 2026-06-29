import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/story.dart';
import '../../../shared/components/story_card.dart';

class StoryCarousel extends StatelessWidget {
  final List<Story> stories;
  const StoryCarousel({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) return const SizedBox.shrink();
    return Column(
      children: stories
          .map((story) => StoryCard(
                story: story,
                onTap: () => context.push('/story/${story.slug}'),
              ))
          .toList(),
    );
  }
}
