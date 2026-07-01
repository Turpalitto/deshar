import 'package:flutter/material.dart';
import '../tokens/app_radii.dart';
import '../tokens/app_spacing.dart';
import '../theme/nokhchiin_theme.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.onTap,
    this.selected = false,
    this.emoji,
  });

  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    final skin = NokhchiinSkin.of(context);
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: selected ? cs.primary.withValues(alpha: 0.15) : cs.surface,
      borderRadius: BorderRadius.circular(AppRadii.chip(skin.isKids)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip(skin.isKids)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (emoji != null) ...[
                Text(emoji!, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? cs.primary : cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
