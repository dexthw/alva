import 'package:flutter/material.dart';

import '../../../core/utils/animation_utils.dart';
import '../../../data/models/habit.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/animated_count.dart';
import '../../../shared/widgets/streak_flame.dart';
import 'period_views.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    required this.period,
    required this.onToggle,
    required this.onToggleCollapsed,
    this.burstToken = 0,
  });

  final Habit habit;
  final Period period;
  final VoidCallback onToggle;
  final VoidCallback onToggleCollapsed;
  final int burstToken;

  @override
  Widget build(BuildContext context) {
    final int percent = habit.stats(period).percent;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.white08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HabitThumbnail(category: habit.category),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      habit.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        height: 1.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    StreakLine(streak: habit.streak, burstToken: burstToken),
                    const SizedBox(height: 6),
                    PercentChip(percent: percent),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CategoryTag(label: habit.category),
                      CollapseButton(
                        collapsed: habit.daysCollapsed,
                        onTap: onToggleCollapsed,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  CheckButton(
                    completed: habit.isCompletedToday,
                    onTap: onToggle,
                  ),
                ],
              ),
            ],
          ),
          AnimatedSize(
            duration: context.motion(const Duration(milliseconds: 240)),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: habit.daysCollapsed
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: HabitPeriodView(habit: habit, period: period),
                  ),
          ),
        ],
      ),
    );
  }
}

class StreakLine extends StatelessWidget {
  const StreakLine({super.key, required this.streak, this.burstToken = 0});

  final int streak;
  final int burstToken;

  @override
  Widget build(BuildContext context) {
    // FittedBox evita overflow em telas de 360dp sem perder o texto.
    return Align(
      alignment: Alignment.centerLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreakFlame(streak: streak, burstToken: burstToken),
            const SizedBox(width: 4),
            Text(
              '$streak',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 5),
            Container(width: 1, height: 11, color: AppColors.white20),
            const SizedBox(width: 5),
            const Text(
              'dias de sequência',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class PercentChip extends StatelessWidget {
  const PercentChip({super.key, required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final bool done = percent >= 100;

    return AnimatedScale(
      scale: done ? 1.05 : 1,
      duration: context.motion(const Duration(milliseconds: 260)),
      curve: Curves.easeOutBack,
      child: AnimatedContainer(
        duration: context.motion(const Duration(milliseconds: 240)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: done ? AppColors.greenSurface : AppColors.greenBackground,
          borderRadius: BorderRadius.circular(999),
          border: done
              ? Border.all(color: AppColors.greenText.withValues(alpha: 0.35))
              : null,
        ),
        child: AnimatedCount(
          value: percent,
          suffix: '%',
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            height: 1.2,
            color: AppColors.greenText,
          ),
        ),
      ),
    );
  }
}

class CategoryTag extends StatelessWidget {
  const CategoryTag({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white08,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
          height: 1.2,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}

class HabitThumbnail extends StatelessWidget {
  const HabitThumbnail({super.key, required this.category, this.size = 76});

  final String category;
  final double size;

  static ({IconData icon, List<Color> colors}) _styleFor(String category) {
    switch (category) {
      case 'Health':
        return (
          icon: Icons.eco,
          colors: const <Color>[Color(0xFF234031), Color(0xFF0E1512)],
        );
      case 'Estudo':
        return (
          icon: Icons.menu_book,
          colors: const <Color>[Color(0xFF26263A), Color(0xFF0F1015)],
        );
      default:
        return (
          icon: Icons.fitness_center,
          colors: const <Color>[Color(0xFF36393F), Color(0xFF141519)],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ({IconData icon, List<Color> colors}) style = _styleFor(category);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: style.colors,
        ),
        border: Border.all(color: AppColors.white08),
      ),
      child: Center(
        child: Icon(
          style.icon,
          size: size * 0.4,
          color: const Color(0xEBFFFFFF),
        ),
      ),
    );
  }
}

class CheckButton extends StatelessWidget {
  const CheckButton({super.key, required this.completed, required this.onTap});

  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      checked: completed,
      label: 'Concluir hábito',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: context.motion(const Duration(milliseconds: 220)),
          curve: Curves.easeOutCubic,
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: completed ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: completed ? AppColors.accent : AppColors.white10,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: completed ? AppColors.white20 : AppColors.white15,
              ),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: context.motion(const Duration(milliseconds: 200)),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeOut,
                transitionBuilder:
                    (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                child: Icon(
                  Icons.check,
                  key: ValueKey<bool>(completed),
                  size: 21,
                  color: completed ? AppColors.background : AppColors.white25,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CollapseButton extends StatelessWidget {
  const CollapseButton({
    super.key,
    required this.collapsed,
    required this.onTap,
  });

  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: collapsed ? 'Expandir dias' : 'Recolher dias',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: 26,
          height: 26,
          child: AnimatedRotation(
            turns: collapsed ? 0 : 0.5,
            duration: context.motion(const Duration(milliseconds: 220)),
            curve: Curves.easeOutCubic,
            child: const Icon(
              Icons.expand_more,
              size: 18,
              color: AppColors.white25,
            ),
          ),
        ),
      ),
    );
  }
}
