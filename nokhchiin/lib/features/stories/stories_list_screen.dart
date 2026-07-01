import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/content_providers.dart';
import '../../core/providers/providers.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/word_illustration.dart';

class StoriesListScreen extends ConsumerWidget {
  const StoriesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(storiesProvider);
    final progress = ref.watch(progressRepoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Награды — истории')),
      body: stories.when(
        data: (list) => FutureBuilder(
          future: progress.getAllProgress(),
          builder: (context, snap) {
            final hasProgress = (snap.data?.length ?? 0) > 0;
            final items = hasProgress ? list : list.take(1).toList();

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                GlassCard(
                  child: Text(
                    hasProgress
                        ? 'Истории открываются после уроков — награда за прогресс'
                        : 'Пройди первый урок, чтобы открыть истории',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 16),
                ...items.map((s) {
                  final panels = (s['panels'] as List?)?.length ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassCard(
                      onTap: hasProgress ? () => context.push('/story/${s['id']}') : null,
                      child: Row(
                        children: [
                          WordIllustration(
                            category: s['unitId'] as String?,
                            emoji: s['emoji'] as String?,
                            size: 80,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s['titleRu'] as String, style: Theme.of(context).textTheme.titleLarge),
                                Text('$panels сцен · награда', style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          Text(hasProgress ? '📖' : '🔒', style: const TextStyle(fontSize: 24)),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
