import 'package:flutter/material.dart';

import '../../models/habit.dart';
import '../../theme/app_colors.dart';
import '../../widgets/animated_count.dart';
import '../../widgets/progress_ring.dart';

class HeroProgressCard extends StatelessWidget {
  const HeroProgressCard({
    super.key,
    required this.stats,
    required this.period,
  });

  final PeriodStats stats;
  final Period period;

  String get _label => switch (period) {
    Period.week => 'PROGRESSO DA SEMANA',
    Period.month => 'PROGRESSO DO MÊS',
    Period.year => 'PROGRESSO DO ANO',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 144),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.heroSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.white08),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      AnimatedCount(
                        value: stats.completed,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1,
                          height: 1,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '/${stats.expected}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.8,
                          height: 1,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'concluídos',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ProgressRing(progress: stats.ratio),
        ],
      ),
    );
  }
}
