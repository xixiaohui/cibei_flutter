import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/connectivity_provider.dart';

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);

    if (!isOffline) return const SizedBox.shrink();

    return MaterialBanner(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      content: const Text(
        '离线模式',
        style: TextStyle(fontSize: 14),
      ),
      leading: const Icon(Icons.wifi_off, size: 20),
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      actions: const [SizedBox.shrink()],
    );
  }
}
