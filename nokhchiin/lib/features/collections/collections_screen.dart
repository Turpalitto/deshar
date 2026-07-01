import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/content_providers.dart';
import '../../core/providers/providers.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/mastery_progress_bar.dart';

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider);
    final progress = ref.watch(progressRepoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Коллекции')),
      body: collections.when(
        data: (list) => FutureBuilder(
          future: progress.getAllProgress(),
          builder: (context, snap) {
            final all = snap.data ?? {};
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Собери 100%', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                ...list.map((col) {
                  final cat = col['category'] as String? ?? '';
                  final total = col['totalCards'] as int? ?? 10;
                  final owned = all.values.where((p) => p.mastery.value >= 3).length.clamp(0, total);
                  final pct = total > 0 ? (owned / total * 100).round() : 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: GlassCard(
                      child: Row(
                        children: [
                          Text(col['icon'] as String? ?? '📘', style: const TextStyle(fontSize: 40)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(col['titleRu'] as String, style: Theme.of(context).textTheme.titleLarge),
                                Text('$owned / $total', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                                const SizedBox(height: 8),
                                MasteryProgressBar(percent: pct),
                              ],
                            ),
                          ),
                          if (pct >= 100) const Text('✨', style: TextStyle(fontSize: 28)),
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
