import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/providers/content_providers.dart';
import '../../core/providers/providers.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/mastery_progress_bar.dart';
import '../../domain/entities/learning_entities.dart';

/// Карта миров — основная навигация приключения.
class WorldsMapScreen extends ConsumerWidget {
  const WorldsMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worlds = ref.watch(worldsProvider);
    final profile = ref.watch(userProfileProvider).value;
    final units = ref.watch(learningUnitsProvider);
    final coins = profile?.coins ?? 0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F4FD), Color(0xFFFFF8F0)],
          ),
        ),
        child: SafeArea(
          child: worlds.when(
            data: (list) => CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  title: const Text('Миры'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Center(child: Text('🪙 $coins', style: const TextStyle(fontWeight: FontWeight.w800))),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.92,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final w = list[i];
                        final unlocked = profile?.isPremium == true ||
                            coins >= (w['unlockStars'] as int? ?? 0) ||
                            (w['unlockStars'] as int? ?? 0) == 0;
                        final gradient = (w['gradient'] as List).cast<String>();
                        final pct = _worldProgress(w, units.valueOrNull ?? []);

                        return Material(
                          borderRadius: BorderRadius.circular(24),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: unlocked
                                ? () {
                                    ref.read(userProfileProvider.notifier).setCurrentWorld(w['id'] as String);
                                    final unitIds = (w['units'] as List).cast<String>();
                                    if (unitIds.isNotEmpty) context.push('/unit/${unitIds.first}');
                                  }
                                : null,
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: gradient
                                      .map((h) => Color(int.parse(h.replaceFirst('#', '0xFF'))))
                                      .toList(),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(w['emoji'] as String? ?? '🌍', style: const TextStyle(fontSize: 44)),
                                        const Spacer(),
                                        Text(
                                          w['titleRu'] as String,
                                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                                        ),
                                        Text(w['titleCe'] as String, style: const TextStyle(fontSize: 12)),
                                        const SizedBox(height: 8),
                                        MasteryProgressBar(percent: pct),
                                        Text('$pct%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                  if (!unlocked)
                                    Container(color: Colors.black26, child: const Center(child: Text('🔒', style: TextStyle(fontSize: 32)))),
                                ],
                              ),
                            ),
                          ),
                        ).animate(delay: (i * 50).ms).fadeIn().scale(begin: const Offset(0.95, 0.95));
                      },
                      childCount: list.length,
                    ),
                  ),
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
          ),
        ),
      ),
    );
  }

  int _worldProgress(Map<String, dynamic> world, List<LearningUnitEntity> units) {
    final ids = (world['units'] as List?)?.cast<String>() ?? [];
    if (ids.isEmpty || units.isEmpty) return 0;
    var sum = 0;
    var n = 0;
    for (final id in ids) {
      for (final u in units) {
        if (u.id == id) {
          sum += u.masteryPercent;
          n++;
        }
      }
    }
    return n == 0 ? 0 : (sum / n).round();
  }
}
