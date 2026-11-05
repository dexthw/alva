import 'package:flutter/material.dart';

import '../../../core/utils/animation_utils.dart';
import '../../../core/utils/date_labels.dart';
import '../../../data/models/habit.dart';
import '../../../core/theme/app_colors.dart';

/// Alterna entre os três modos de exibição de dias do card.
class HabitPeriodView extends StatelessWidget {
  const HabitPeriodView({super.key, required this.habit, required this.period});

  final Habit habit;
  final Period period;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: context.motion(const Duration(milliseconds: 220)),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      layoutBuilder: (Widget? current, List<Widget> previous) => Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[...previous, if (current != null) current],
      ),
      child: switch (period) {
        Period.week => WeekRow(
            key: const ValueKey<String>('week'),
            habit: habit,
          ),
        Period.month => MonthGrid(
            key: const ValueKey<String>('month'),
            habit: habit,
          ),
        Period.year => YearHeatmap(
            key: const ValueKey<String>('year'),
            habit: habit,
          ),
      },
    );
  }
}

/// Os 7 dias da semana atual.
class WeekRow extends StatelessWidget {
  const WeekRow({super.key, required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime today = Habit.dayKey(now);
    final DateTime monday = DateTime(
      today.year,
      today.month,
      today.day - (now.weekday - 1),
    );

    return Row(
      children: <Widget>[
        for (int i = 0; i < 7; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 5),
          Expanded(
            child: WeekDayPill(
              label: weekdayShortNames[i],
              day: DateTime(monday.year, monday.month, monday.day + i).day,
              isToday: i == now.weekday - 1,
              isCompleted: habit.completedDays.contains(
                DateTime(monday.year, monday.month, monday.day + i),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class WeekDayPill extends StatelessWidget {
  const WeekDayPill({
    super.key,
    required this.label,
    required this.day,
    required this.isToday,
    required this.isCompleted,
  });

  final String label;
  final int day;
  final bool isToday;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color foreground;
    final Color border;

    if (isToday) {
      background = AppColors.accent;
      foreground = AppColors.background;
      border = AppColors.accent;
    } else if (isCompleted) {
      background = AppColors.white12;
      foreground = AppColors.textPrimary;
      border = AppColors.white12;
    } else {
      background = Colors.transparent;
      foreground = AppColors.textSecondary;
      border = AppColors.white10;
    }

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              height: 1.1,
              color: foreground,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$day',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              height: 1.1,
              color: foreground,
            ),
          ),
          if (isCompleted && !isToday) ...<Widget>[
            const SizedBox(height: 2),
            Container(
              width: 3,
              height: 3,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Grade compacta do mês atual.
class MonthGrid extends StatelessWidget {
  const MonthGrid({super.key, required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime today = Habit.dayKey(now);
    final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final int leading = DateTime(now.year, now.month).weekday - 1;
    final int rows = ((leading + daysInMonth) / 7).ceil();

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            for (final String label in weekdayShortNames)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (int row = 0; row < rows; row++)
          Row(
            children: <Widget>[
              for (int column = 0; column < 7; column++)
                Expanded(
                  child: _MonthDayCell(
                    day: row * 7 + column - leading + 1,
                    daysInMonth: daysInMonth,
                    year: now.year,
                    month: now.month,
                    today: today,
                    habit: habit,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _MonthDayCell extends StatelessWidget {
  const _MonthDayCell({
    required this.day,
    required this.daysInMonth,
    required this.year,
    required this.month,
    required this.today,
    required this.habit,
  });

  final int day;
  final int daysInMonth;
  final int year;
  final int month;
  final DateTime today;
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    if (day < 1 || day > daysInMonth) {
      return const SizedBox(height: 22);
    }

    final DateTime date = DateTime(year, month, day);
    final bool completed = habit.completedDays.contains(date);
    final bool isToday = date == today;
    final bool isFuture = date.isAfter(today);

    return Container(
      height: 22,
      margin: const EdgeInsets.all(1),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: completed
            ? AppColors.accent
            : (isFuture ? Colors.transparent : AppColors.white06),
        borderRadius: BorderRadius.circular(6),
        border: isToday ? Border.all(color: AppColors.white25) : null,
      ),
      child: Text(
        '$day',
        style: TextStyle(
          fontSize: 9.5,
          height: 1,
          fontWeight: FontWeight.w500,
          color: completed
              ? AppColors.background
              : (isFuture ? AppColors.white25 : AppColors.textTertiary),
        ),
      ),
    );
  }
}

/// Mapa de calor compacto dos 12 meses do ano.
class YearHeatmap extends StatelessWidget {
  const YearHeatmap({super.key, required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        for (int month = 1; month <= 12; month++)
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  monthInitials[month - 1],
                  style: TextStyle(
                    fontSize: 8.5,
                    height: 1.1,
                    fontWeight: FontWeight.w500,
                    color: month == now.month
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                _YearMonthCell(
                  habit: habit,
                  year: now.year,
                  month: month,
                  now: now,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _YearMonthCell extends StatelessWidget {
  const _YearMonthCell({
    required this.habit,
    required this.year,
    required this.month,
    required this.now,
  });

  final Habit habit;
  final int year;
  final int month;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final double ratio;
    if (month > now.month) {
      ratio = 0;
    } else {
      final int days =
          month == now.month ? now.day : DateTime(year, month + 1, 0).day;
      final int done = habit.completedDays
          .where((DateTime day) => day.year == year && day.month == month)
          .length;
      ratio = days == 0 ? 0 : (done / days).clamp(0.0, 1.0);
    }

    final Color color;
    if (ratio <= 0) {
      color = AppColors.white06;
    } else if (ratio < 0.34) {
      color = AppColors.white15;
    } else if (ratio < 0.67) {
      color = AppColors.white25;
    } else if (ratio < 0.99) {
      color = AppColors.white40;
    } else {
      color = AppColors.accent;
    }

    return Container(
      height: 18,
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: month == now.month
            ? Border.all(color: AppColors.white25, width: 0.8)
            : null,
      ),
    );
  }
}
