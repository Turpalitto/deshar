import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import '../../core/widgets/glass_card.dart';
import '../../domain/entities/learning_entities.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider).value ?? const UserProfileEntity();
    final mastery = ref.watch(languageMasteryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Прогресс')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Сегодня', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                _Row('Слов изучено', '${profile.wordsLearnedToday}'),
                _Row('XP', '${profile.xp}'),
                _Row('Монеты', '${profile.coins}'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Всего', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                _Row('Уровень', '${profile.level}'),
                _Row('Серия', '${profile.streakDays} дн.'),
                _Row('Язык освоен', '${mastery.valueOrNull ?? 0}%'),
                _Row('Уроков', '${profile.lessonsCompletedTotal}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
