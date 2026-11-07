import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/animation_utils.dart';
import '../../../core/utils/date_labels.dart';
import '../../../data/models/habit.dart';

/// Área de dias do card.
///
/// Recolher "puxa os dias para dentro" e expandir "empurra para fora", com
/// escalonamento de 24 ms entre os dias e 400 ms no total. A altura acompanha a
/// animação, então o card encolhe junto.
class HabitPeriodView extends StatefulWidget {
  const HabitPeriodView({
    super.key,
    required this.habit,
    required this.period,
    this.collapsed = false,
  });

  final Habit habit;
  final Period period;
  final bool collapsed;

  @override
  State<HabitPeriodView> createState() => _HabitPeriodViewState();
}

class _HabitPeriodViewState extends State<HabitPeriodView>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 400);

  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: _duration,
    value: widget.collapsed ? 0 : 1,
  );

  @override
  void didUpdateWidget(covariant HabitPeriodView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collapsed == widget.collapsed) {
      return;
    }
    final Duration duration = context.motion(_duration);
    if (widget.collapsed) {
      _reveal.animateBack(
        0,
        duration: duration,
        curve: Curves.easeInOutCubic,
      );
    } else {
      _reveal.duration = duration;
      _reveal.forward();
    }
  }

  @override
  void dispose() {
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.collapsed && _reveal.isDismissed) {
      return const SizedBox(width: double.infinity);
    }

    final Widget content = Padding(
      padding: const EdgeInsets.only(top: 12),
      child: AnimatedSwitcher(
        duration: context.motion(const Duration(milliseconds: 220)),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        layoutBuilder: (Widget? current, List<Widget> previous) => Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[...previous, if (current != null) current],
        ),
        child: switch (widget.period) {
          Period.week => WeekRow(
              key: const ValueKey<String>('week'),
              habit: widget.habit,
              reveal: _reveal,
            ),
          Period.month => MonthGrid(
              key: const ValueKey<String>('month'),
              habit: widget.habit,
              reveal: _reveal,
            ),
          Period.year => YearHeatmap(
              key: const ValueKey<String>('year'),
              habit: widget.habit,
              reveal: _reveal,
            ),
        },
      ),
    );

    return AnimatedBuilder(
      animation: _reveal,
      child: content,
      builder: (BuildContext context, Widget? child) {
        final double reveal = Curves.easeOutCubic.transform(_reveal.value);
        // O frame final da animação não passa pelo build do State, então a
        // remoção precisa acontecer aqui para os dias saírem da árvore.
        if (reveal <= 0.001) {
          return const SizedBox(width: double.infinity);
        }
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: reveal,
            child: Opacity(opacity: reveal, child: child),
          ),
        );
      },
    );
  }
}

/// Revela um dia com atraso proporcional ao índice (24 ms por dia).
class _DayReveal extends StatelessWidget {
  const _DayReveal({
    required this.animation,
    required this.index,
    required this.child,
  });

  final Animation<double> animation;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!animation.isAnimating && animation.value >= 1) {
      return child;
    }
    final Interval interval = Interval(
      (index.clamp(0, 9)) * 0.06,
      1,
      curve: Curves.easeOutCubic,
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (BuildContext context, Widget? cached) {
        final double t = interval.transform(animation.value.clamp(0.0, 1.0));
        return Opacity(
          opacity: t,
          child: Transform.scale(
            scale: 0.82 + 0.18 * t,
            alignment: Alignment.center,
            child: cached,
          ),
        );
      },
    );
  }
}

/// Os 7 dias da semana atual.
class WeekRow extends StatelessWidget {
  const WeekRow({super.key, required this.habit, this.reveal});

  final Habit habit;
  final Animation<double>? reveal;

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
            child: _Revealed(
              reveal: reveal,
              index: i,
              child: WeekDayPill(
                label: weekdayShortNames[i],
                day: DateTime(monday.year, monday.month, monday.day + i).day,
                isToday: i == now.weekday - 1,
                isCompleted: habit.completedDays.contains(
                  DateTime(monday.year, monday.month, monday.day + i),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _Revealed extends StatelessWidget {
  const _Revealed({
    required this.reveal,
    required this.index,
    required this.child,
  });

  final Animation<double>? reveal;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Animation<double>? animation = reveal;
    if (animation == null) {
      return child;
    }
    return _DayReveal(animation: animation, index: index, child: child);
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
  const MonthGrid({super.key, required this.habit, this.reveal});

  final Habit habit;
  final Animation<double>? reveal;

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
                  child: _Revealed(
                    reveal: reveal,
                    index: row * 7 + column,
                    child: _MonthDayCell(
                      day: row * 7 + column - leading + 1,
                      daysInMonth: daysInMonth,
                      year: now.year,
                      month: now.month,
                      today: today,
                      habit: habit,
                    ),
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
  const YearHeatmap({super.key, required this.habit, this.reveal});

  final Habit habit;
  final Animation<double>? reveal;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        for (int month = 1; month <= 12; month++)
          Expanded(
            child: _Revealed(
              reveal: reveal,
              index: month - 1,
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
