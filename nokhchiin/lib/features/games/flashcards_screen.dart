import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/providers/providers.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/word_illustration.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/word_entity.dart';

final _rng = Random();

/// Главный экран обучения — иллюстрация доминирует, не словарь.
class FlashcardsScreen extends ConsumerStatefulWidget {
  const FlashcardsScreen({super.key, required this.unitId});
  final String unitId;

  @override
  ConsumerState<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends ConsumerState<FlashcardsScreen> {
  List<WordEntity> _words = [];
  int _index = 0;
  bool _showTranslation = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    var words = await ref.read(dictionaryRepoProvider).getWordsByCategory(widget.unitId);
    if (words.isEmpty) {
      words = (await ref.read(dictionaryRepoProvider).getAllWords()).take(10).toList();
    }
    words.shuffle(_rng);
    if (mounted) setState(() => _words = words.take(8).toList());
  }

  Future<void> _known(bool yes) async {
    final w = _words[_index];
    await ref.read(reviewWordUseCaseProvider)(w.id, yes ? 5 : 2);
    if (yes) await ref.read(userProfileProvider.notifier).recordWordLearned();

    if (_index < _words.length - 1) {
      setState(() {
        _index++;
        _showTranslation = false;
      });
    } else {
      await ref.read(userProfileProvider.notifier).addXp(25, 5);
      if (mounted) {
        _showReward();
      }
    }
  }

  void _showReward() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Урок пройден! 🎉'),
        content: const Text('+25 XP · +5 монет'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: const Text('Отлично'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_words.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final w = _words[_index];
    final isKids = ref.watch(userProfileProvider).value?.mode == AppMode.kids;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('${_index + 1} / ${_words.length}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(isKids ? 20 : 16),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showTranslation = !_showTranslation),
                child: GlassCard(
                  borderRadius: isKids ? 36 : 28,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: WordIllustration(
                            category: widget.unitId,
                            emoji: w.emoji,
                            size: isKids ? 220 : 200,
                          ).animate(key: ValueKey(w.id)).fadeIn().scale(begin: const Offset(0.92, 0.92)),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F0FE),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.unitId,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                w.chechen,
                                style: TextStyle(
                                  fontSize: isKids ? 40 : 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_showTranslation) ...[
                                const SizedBox(height: 12),
                                Text(
                                  w.russian,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: const Color(0xFF0D904F),
                                        fontWeight: FontWeight.w800,
                                      ),
                                  textAlign: TextAlign.center,
                                ).animate().fadeIn().slideY(begin: 0.1),
                              ] else
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    'Нажми, чтобы увидеть перевод',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: isKids ? 20 : 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => _known(false),
                    child: const Text('Ещё учу'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: isKids ? 20 : 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => _known(true),
                    child: const Text('Знаю ✓'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
