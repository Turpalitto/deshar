import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/tokens/app_spacing.dart';
import '../../core/design/widgets/app_card.dart';
import '../../core/design/widgets/app_scaffold.dart';
import '../../core/design/widgets/error_state.dart';
import '../../core/design/widgets/loading_state.dart';
import '../../core/design/widgets/progress_ring.dart';
import '../../core/providers/providers.dart';
import '../../core/widgets/mastery_progress_bar.dart';
import '../../domain/constants/subscription_limits.dart';

class LearningPathScreen extends ConsumerWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final units = ref.watch(learningUnitsProvider);

    return AppScaffold(
      title: 'Путь обучения',
      body: units.when(
        data: (list) => ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: list.length,
          itemBuilder: (context, i) {
            final u = list[i];
            final isLast = i == list.length - 1;
            final isPremiumGate = !u.isUnlocked && u.order > SubscriptionLimits.freeUnitMaxOrder;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ProgressRing(
                      percent: u.masteryPercent,
                      size: 44,
                      strokeWidth: 4,
                      center: Text(
                        u.isUnlocked ? '${u.order}' : '🔒',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 72,
                        color: Theme.of(context).dividerColor,
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                    child: AppCard(
                      onTap: () {
                        if (u.isUnlocked) {
                          context.push('/unit/${u.id}');
                        } else if (isPremiumGate) {
                          context.push('/paywall?return=/path');
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.titleCe, style: Theme.of(context).textTheme.labelLarge),
                          Text(u.titleRu, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: AppSpacing.sm),
                          MasteryProgressBar(percent: u.masteryPercent),
                          Text(
                            isPremiumGate
                                ? 'Premium · ${u.masteryPercent}% освоено'
                                : '${u.masteryPercent}% · нужно ${u.requiredMastery}% для следующей',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        loading: () => const LoadingState(message: 'Строим путь…'),
        error: (e, _) => ErrorState(message: '$e'),
      ),
    );
  }
}
