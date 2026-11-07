import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/animation_utils.dart';

/// Anel de progresso do dia.
///
/// Círculo fechado e sem divisões: trilha em vidro cinza, arco contínuo em
/// gradiente, cápsula rosa na ponta e brilho pulsante. O corpo ocupa 74% do
/// `size`; halo, régua e cápsula usam a margem restante, então nada é cortado
/// em 112dp.
class ProgressRing extends StatefulWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 112,
    this.centerLabel,
    this.semanticsLabel = 'Progresso',
  });

  final double progress;
  final double size;
  final String? centerLabel;
  final String semanticsLabel;

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  static const Duration _pulsePeriod = Duration(milliseconds: 2200);

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: _pulsePeriod,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) {
      return;
    }
    _started = true;
    if (!context.animationsDisabled) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double target =
        widget.progress.isFinite ? widget.progress.clamp(0.0, 1.0) : 0.0;
    final bool still = context.animationsDisabled;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: target),
        duration: context.motion(const Duration(milliseconds: 600)),
        curve: Curves.easeOutCubic,
        builder: (BuildContext context, double value, Widget? child) {
          final int percent = (value * 100).round();
          final String label = widget.centerLabel ?? '$percent%';

          return Semantics(
            label: widget.semanticsLabel,
            value: '$percent%',
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (BuildContext context, Widget? child) {
                // Com animações desligadas, o brilho fica no meio do ciclo.
                final double pulse = still ? 0.5 : _pulse.value;
                return Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    RepaintBoundary(
                      child: CustomPaint(
                        size: Size.square(widget.size),
                        painter: _RingPainter(progress: value, pulse: pulse),
                      ),
                    ),
                    IgnorePointer(
                      child: Padding(
                        padding: EdgeInsets.all(widget.size * 0.28),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            label,
                            maxLines: 1,
                            textScaler: TextScaler.noScaling,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              letterSpacing: -0.6,
                              height: 1,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.progress, required this.pulse});

  final double progress;

  /// Fase do brilho, de 0 (mínimo) a 1 (máximo).
  final double pulse;

  static const List<Color> _arcColors = <Color>[
    AppColors.ringArcMint,
    AppColors.ringArcLavender,
    AppColors.ringArcViolet,
    AppColors.ringArcSlate,
    AppColors.ringArcMint,
  ];
  static const List<double> _stops = <double>[0, 0.28, 0.55, 0.78, 1];

  Path _arcPath(
    Offset center,
    double outer,
    double inner,
    double start,
    double end,
  ) {
    final Path path = Path();
    if (end <= start) {
      return path;
    }
    path.addArc(
      Rect.fromCircle(center: center, radius: outer),
      start,
      end - start,
    );
    path.arcTo(
      Rect.fromCircle(center: center, radius: inner),
      end,
      start - end,
      false,
    );
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double outer = size.width * 0.74 / 2;
    final double thick = outer * 0.30;
    final double inner = outer - thick;
    final double mid = (outer + inner) / 2;
    const double start = -math.pi / 2;
    final double clamped = progress.clamp(0.0, 1.0);
    final double end = start + clamped * 2 * math.pi;

    _paintHalo(canvas, center, outer);
    _paintTrack(canvas, center, mid, thick);
    if (clamped > 0.003) {
      _paintArc(canvas, center, outer, inner, thick, start, end);
    }
    _paintRuler(canvas, center, outer, end);
    _paintCap(canvas, center, mid, thick, end);
  }

  void _paintHalo(Canvas canvas, Offset center, double outer) {
    final Paint halo = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = Colors.white.withValues(alpha: 0.075);
    for (int i = 0; i < 8; i++) {
      canvas.drawCircle(center, outer * (1.07 + 0.035 * i), halo);
    }
  }

  void _paintTrack(Canvas canvas, Offset center, double mid, double thick) {
    final Rect rect = Rect.fromCircle(center: center, radius: mid);
    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = thick
        ..color = AppColors.ringTrack.withValues(alpha: 0.42),
    );
    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.white.withValues(alpha: 0.10),
    );
  }

  void _paintArc(
    Canvas canvas,
    Offset center,
    double outer,
    double inner,
    double thick,
    double start,
    double end,
  ) {
    final bool full = progress >= 0.999;
    final double radius = (outer + inner) / 2;
    final double glowAlpha = 0.26 + 0.34 * pulse;
    final double glowBlur = thick * (0.30 + 0.45 * pulse);

    final List<Color> glowColors = _arcColors
        .map((Color color) => color.withValues(alpha: glowAlpha))
        .toList();

    Paint glow() => Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.sweep(
        center,
        glowColors,
        _stops,
        TileMode.clamp,
        start,
        start + 2 * math.pi,
      )
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowBlur);

    Paint body() => Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.sweep(
        center,
        _arcColors,
        _stops,
        TileMode.clamp,
        start,
        start + 2 * math.pi,
      );

    final Paint rim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.20);

    if (full) {
      // Um path de 2π fecharia o disco; em 100% o anel é um stroke circular.
      canvas.drawCircle(
        center,
        radius,
        glow()
          ..style = PaintingStyle.stroke
          ..strokeWidth = thick,
      );
      canvas.drawCircle(
        center,
        radius,
        body()
          ..style = PaintingStyle.stroke
          ..strokeWidth = thick,
      );
      canvas.drawCircle(center, radius, rim);
      return;
    }

    final Path arc = _arcPath(center, outer, inner, start, end);
    canvas.drawPath(arc, glow());
    canvas.drawPath(arc, body());
    canvas.drawPath(arc, rim);
  }

  void _paintRuler(Canvas canvas, Offset center, double outer, double end) {
    const int ticks = 16;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.9
      ..color = Colors.white.withValues(alpha: 0.38);
    final double base = outer * 1.10;

    for (int i = 0; i < ticks; i++) {
      final double t = i / (ticks - 1);
      final double angle = end + 0.12 + (32 * math.pi / 180) * t;
      final Offset direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        center + direction * base,
        center + direction * (base + 1.8 + 2.7 * math.sin(math.pi * t)),
        paint,
      );
    }
  }

  void _paintCap(
    Canvas canvas,
    Offset center,
    double mid,
    double thick,
    double end,
  ) {
    final double capRadial = thick * 1.02;
    final double capTangential = thick * 1.42;
    final Offset capCenter = Offset(mid, 0);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(end);

    canvas.drawCircle(
      capCenter,
      thick * 1.2,
      Paint()
        ..shader = ui.Gradient.radial(capCenter, thick * 1.2, <Color>[
          AppColors.ringCapHalo.withValues(alpha: 0.32 + 0.30 * pulse),
          AppColors.ringCapHalo.withValues(alpha: 0),
        ]),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: capCenter,
          width: capRadial,
          height: capTangential,
        ),
        Radius.circular(capRadial * 0.51),
      ),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(capCenter.dx, -thick * 0.8),
          Offset(capCenter.dx, thick * 0.8),
          <Color>[AppColors.ringCapLight, AppColors.ringCapRose],
        ),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.pulse != pulse;
}
