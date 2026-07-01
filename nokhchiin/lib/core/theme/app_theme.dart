import 'package:flutter/material.dart';
import '../../domain/entities/enums.dart';
import '../design/theme/nokhchiin_theme.dart';

/// Обратная совместимость — делегирует в NokhchiinTheme.
abstract final class AppTheme {
  static ThemeData theme({AppMode mode = AppMode.kids, KidsAgeGroup age = KidsAgeGroup.age6to9}) =>
      NokhchiinTheme.light(mode: mode, age: age);
}
