import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/utils/animation_utils.dart';
import '../../core/theme/app_colors.dart';

/// Chama da sequência.
///
/// Com sequência maior que zero pulsa discretamente; ao concluir o hábito do
/// dia (`burstToken` novo) dá uma explosão curta. Com sequência zero fica
/// estática e apagada.
class StreakFlame extends StatefulWidget {
  const StreakFlame({
    super.key,
    required this.streak,
    this.burstToken = 0,
    this.size = 15,
  });

  final int streak;
  final int burstToken;
  final double size;

  @override
  State<StreakFlame> createState() => _StreakFlameState();
}

class _StreakFlameState extends State<StreakFlame>
    with TickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );
  late final AnimationController _burst = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) {
      return;
    }
    _started = true;
    if (!context.animationsDisabled && widget.streak > 0) {
      _pulse.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant StreakFlame oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool disabled = context.animationsDisabled;
    if (widget.streak <= 0) {
      _pulse.stop();
    } else if (!disabled && !_pulse.isAnimating) {
      _pulse.repeat();
    }
    if (widget.burstToken != oldWidget.burstToken && !disabled) {
      _burst.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    _burst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool active = widget.streak > 0;
    final double box = widget.size * 1.35;

    if (!active) {
      return SizedBox(
        width: box,
        height: box,
        child: Icon(
          Icons.local_fire_department,
          size: widget.size,
          color: AppColors.flameDim,
        ),
      );
    }

    return SizedBox(
      width: box,
      height: box,
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[_pulse, _burst]),
        builder: (BuildContext context, Widget? child) {
          final double pulse = math.sin(2 * math.pi * _pulse.value);
          final double burst = _burst.value;
          final double burstScale = 1 + 0.42 * math.sin(math.pi * burst);
          final double scale = (1 + 0.055 * pulse) * burstScale;
          final double rotation = 0.07 * math.sin(2 * math.pi * _pulse.value + 0.8);
          final double glow = 0.34 + 0.12 * pulse;

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: box,
                height: box,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.flame.withValues(
                        alpha: (glow * (1 - burst)).clamp(0.0, 1.0),
                      ),
                      blurRadius: 11,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              if (burst > 0 && burst < 1)
                Container(
                  width: widget.size * (1.2 + 1.6 * burst),
                  height: widget.size * (1.2 + 1.6 * burst),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.flame.withValues(alpha: 1 - burst),
                      width: 1.2,
                    ),
                  ),
                ),
              Transform.rotate(
                angle: rotation,
                child: Transform.scale(
                  scale: scale,
                  child: Icon(
                    Icons.local_fire_department,
                    size: widget.size,
                    color: AppColors.flame,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
