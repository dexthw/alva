import 'package:flutter/material.dart';

import '../../../core/utils/animation_utils.dart';
import '../../../data/models/habit.dart';
import '../../../core/theme/app_colors.dart';

class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Period value;
  final ValueChanged<Period> onChanged;

  @override
  Widget build(BuildContext context) {
    const List<Period> options = Period.values;
    final int selectedIndex =
        options.indexOf(value).clamp(0, options.length - 1);

    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.white08),
      ),
      child: Stack(
        children: <Widget>[
          AnimatedAlign(
            alignment: Alignment(
              -1.0 + selectedIndex * (2 / (options.length - 1)),
              0,
            ),
            duration: context.motion(const Duration(milliseconds: 280)),
            curve: Curves.easeOutCubic,
            child: FractionallySizedBox(
              widthFactor: 1 / options.length,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.heroSurface,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              for (int i = 0; i < options.length; i++)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: i == selectedIndex,
                    label: options[i].label,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(options[i]),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: context.motion(
                            const Duration(milliseconds: 220),
                          ),
                          curve: Curves.easeOut,
                          style: DefaultTextStyle.of(context).style.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: i == selectedIndex
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                              ),
                          child: Text(options[i].label),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
