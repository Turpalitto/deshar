import 'package:flutter/material.dart';
import '../tokens/app_shadows.dart';
import '../tokens/app_spacing.dart';
import '../theme/nokhchiin_theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.gradient,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final skin = NokhchiinSkin.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final content = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );

    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(skin.cardRadius),
      gradient: gradient,
      color: gradient == null ? Theme.of(context).cardTheme.color : null,
      boxShadow: AppShadows.card(isDark),
      border: Border.all(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
      ),
    );

    if (onTap == null) {
      return DecoratedBox(decoration: decoration, child: content);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(skin.cardRadius),
        child: Ink(decoration: decoration, child: content),
      ),
    );
  }
}
