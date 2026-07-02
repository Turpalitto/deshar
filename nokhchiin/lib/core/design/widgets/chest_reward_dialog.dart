import 'package:flutter/material.dart';

import '../app_icons.dart';
import 'app_button.dart';
import 'app_icon_image.dart';

Future<void> showChestRewardDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconImage(asset: AppIcons.rewardChest, size: 28),
          SizedBox(width: 10),
          Text('Сундук!'),
        ],
      ),
      content: const Text('+25 монет · +30 XP'),
      actions: [
        AppButton(
          label: 'Забрать',
          expanded: false,
          onPressed: () => Navigator.pop(ctx),
        ),
      ],
    ),
  );
}
