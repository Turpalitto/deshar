import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/providers/providers.dart';
import '../../core/providers/content_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/word_illustration.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/learning_entities.dart';

/// Главный экран прогресса — не меню, а «приключение сегодня».
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider).value ?? const UserProfileEntity();
    final isKids = profile.mode == AppMode.kids;
    final mastery = ref.watch(languageMasteryProvider);
    final continueUnit = ref.watch(continueUnitProvider);
    final due = ref.watch(dueWordsProvider);
    final worlds = ref.watch(worldsProvider);
    final pad = isKids ? 24.0 : 20.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isKids
                ? [const Color(0xFFE8F4FD), const Color(0xFFFFF8F0)]
                : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(pad, 12, pad, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      _StatChip(icon: '🔥', value: '${profile.streakDays}', label: 'серия'),
                      const SizedBox(width: 8),
                      _StatChip(icon: '⭐', value: '${profile.xp}', label: 'XP'),
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: '❤️',
                        value: '${mastery.valueOrNull ?? 0}%',
                        label: 'язык',
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => context.push('/profile'),
                        icon: const Icon(Icons.person_rounded),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(pad),
                sliver: SliverToBoxAdapter(
                  child: continueUnit.when(
                    data: (unit) => _ContinueHero(
                      unit: unit,
                      isKids: isKids,
                      coins: profile.coins,
                      onTap: unit != null
                          ? () => context.push('/flashcards/${unit.id}')
                          : () => context.push('/worlds'),
                    ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.08),
                    loading: () => const SizedBox(height: 120),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: pad),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: _GoalCard(
                          wordsToday: profile.wordsLearnedToday,
                          goal: profile.dailyGoalWords,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _WeekCard(weeklyXp: profile.weeklyXp),
                      ),
                    ],
                  ).animate().fadeIn(delay: 120.ms),
                ),
              ),
              if (!profile.dailyGiftClaimed)
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(pad, 16, pad, 0),
                  sliver: SliverToBoxAdapter(
                    child: GlassCard(
                      onTap: () => ref.read(userProfileProvider.notifier).claimDailyGift(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        children: [
                          const Text('🎁', style: TextStyle(fontSize: 32)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Ежедневный подарок',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(pad, 24, pad, 8),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('🌍 Миры', style: Theme.of(context).textTheme.headlineMedium),
                      TextButton(
                        onPressed: () => context.push('/worlds'),
                        child: const Text('Все'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: isKids ? 148 : 130,
                  child: worlds.when(
                    data: (list) => ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: pad),
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final w = list[i];
                        final unlocked = profile.isPremium ||
                            profile.unlockedWorlds.contains(w['id']) ||
                            profile.coins >= (w['unlockStars'] as int? ?? 0);
                        return _WorldChip(
                          world: w,
                          unlocked: unlocked,
                          isActive: w['id'] == profile.currentWorldId,
                          onTap: unlocked
                              ? () {
                                  ref.read(userProfileProvider.notifier).setCurrentWorld(w['id'] as String);
                                  final units = (w['units'] as List).cast<String>();
                                  if (units.isNotEmpty) context.push('/unit/${units.first}');
                                }
                              : null,
                        );
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('$e')),
                  ),
                ),
              ),
              if (due.valueOrNull?.isNotEmpty == true)
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(pad, 20, pad, 0),
                  sliver: SliverToBoxAdapter(
                    child: GlassCard(
                      onTap: () => context.push('/review'),
                      child: Row(
                        children: [
                          const Text('🔄', style: TextStyle(fontSize: 28)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Повторить ${due.value!.length} слов',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const Icon(Icons.play_arrow_rounded, size: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(pad, 20, pad, 32),
                sliver: SliverToBoxAdapter(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (!isKids) _NavChip('📖 Словарь', () => context.push('/dictionary')),
                      _NavChip('📚 Коллекции', () => context.push('/collections')),
                      _NavChip('📖 Истории', () => context.push('/stories')),
                      _NavChip('📈 Прогресс', () => context.push('/progress')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.value, required this.label});
  final String icon, value, label;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: 16,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContinueHero extends StatelessWidget {
  const _ContinueHero({
    required this.unit,
    required this.isKids,
    required this.coins,
    required this.onTap,
  });

  final LearningUnitEntity? unit;
  final bool isKids;
  final int coins;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = unit?.titleRu ?? 'Начать путь';
    final ce = unit?.titleCe ?? 'Маршалла';
    final pct = unit?.masteryPercent ?? 0;

    return Material(
      borderRadius: BorderRadius.circular(isKids ? 32 : 24),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isKids ? 32 : 24),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isKids ? 32 : 24),
            gradient: const LinearGradient(
              colors: [Color(0xFF1A73E8), Color(0xFF1557B0)],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isKids ? 28 : 22),
            child: Row(
              children: [
                if (unit != null)
                  WordIllustration(category: unit!.id, emoji: null, size: isKids ? 72 : 64),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Продолжить',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white70),
                      ),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      Text(ce, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: pct / 100,
                          minHeight: 8,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.wordsToday, required this.goal});
  final int wordsToday, goal;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🎯', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          Text('Цель дня', style: Theme.of(context).textTheme.labelLarge),
          Text(
            '$wordsToday / $goal слов',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _WeekCard extends StatelessWidget {
  const _WeekCard({required this.weeklyXp});
  final List<int> weeklyXp;

  @override
  Widget build(BuildContext context) {
    final data = weeklyXp.length == 7 ? weeklyXp : List.filled(7, 0);
    final max = data.reduce((a, b) => a > b ? a : b).clamp(1, 9999);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📈', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          Text('Неделя', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final h = (data[i] / max * 28).clamp(4.0, 28.0);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      height: h,
                      decoration: BoxDecoration(
                        color: i == 6 ? AppColors.primary : AppColors.primary.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorldChip extends StatelessWidget {
  const _WorldChip({
    required this.world,
    required this.unlocked,
    required this.isActive,
    this.onTap,
  });

  final Map<String, dynamic> world;
  final bool unlocked, isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final gradient = (world['gradient'] as List).cast<String>();
    return Opacity(
      opacity: unlocked ? 1 : 0.45,
      child: Material(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            width: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient.map((h) => Color(int.parse(h.replaceFirst('#', '0xFF')))).toList(),
              ),
              border: isActive ? Border.all(color: AppColors.primary, width: 3) : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(world['emoji'] as String? ?? '🌍', style: const TextStyle(fontSize: 32)),
                  const Spacer(),
                  Text(
                    world['titleRu'] as String,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                  Text(unlocked ? '▶' : '🔒', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavChip extends StatelessWidget {
  const _NavChip(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Colors.white.withValues(alpha: 0.85),
    );
  }
}
