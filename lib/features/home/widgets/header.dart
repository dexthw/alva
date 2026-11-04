import 'package:flutter/material.dart';

import '../../../core/utils/animation_utils.dart';
import '../../../core/utils/date_labels.dart';
import '../../../core/theme/app_colors.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.phrase,
    required this.onNewHabit,
  });

  final String phrase;
  final VoidCallback onNewHabit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                formatHeaderDate(DateTime.now()),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            NewHabitButton(onPressed: onNewHabit),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'HOJE',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: AppColors.textPrimary,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: context.motion(const Duration(milliseconds: 320)),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: Text(
            phrase,
            key: ValueKey<String>(phrase),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class NewHabitButton extends StatelessWidget {
  const NewHabitButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Novo hábito',
      child: Material(
        color: AppColors.accent,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: const SizedBox(
            height: 40,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.add, size: 17, color: AppColors.background),
                  SizedBox(width: 5),
                  Text(
                    'Novo',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.background,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
