import 'package:flutter/material.dart';

import '../../../core/utils/animation_utils.dart';
import '../../../core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.expanded,
    required this.canExpand,
    required this.onToggle,
  });

  final String title;
  final bool expanded;
  final bool canExpand;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (canExpand)
          Semantics(
            button: true,
            label: expanded ? 'Ver menos hábitos' : 'Ver todos os hábitos',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AnimatedSwitcher(
                      duration: context.motion(const Duration(milliseconds: 180)),
                      child: Text(
                        expanded ? 'Ver menos' : 'Ver todos',
                        key: ValueKey<bool>(expanded),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    AnimatedRotation(
                      turns: expanded ? 0.25 : 0,
                      duration: context.motion(const Duration(milliseconds: 220)),
                      curve: Curves.easeOutCubic,
                      child: const Icon(
                        Icons.chevron_right,
                        size: 17,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
