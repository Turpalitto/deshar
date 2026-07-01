import 'package:flutter/material.dart';
import '../tokens/app_spacing.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.message = 'Загрузка…'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.lg),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
