import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../core/animation_utils.dart';
import '../theme/app_colors.dart';

/// Anel de progresso em vidro fosco facetado.
///
/// O corpo ocupa 74% do `size`; halo, régua e partículas usam a margem
/// restante, então nada é cortado no tamanho final.
class ProgressRing extends StatefulWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 112,
    this.facets = 12,
    this.tiltDegrees = 12,
    this.centerLabel,
    this.semanticsLabel = 'Progresso',
  });

  final double progress;
  final double size;
  final int facets;
  final double tiltDegrees;
  final String? centerLabel;
  final String semanticsLabel;

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing> {
  late _RingGeometry _geometry;
  ui.Picture? _staticLayer;

  @override
  void initState() {
    super.initState();
    _rebuildStatic();
  }

  @override
  void didUpdateWidget(covariant ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.size != widget.size || oldWidget.facets != widget.facets) {
      _rebuildStatic();
    }
  }

  void _rebuildStatic() {
    _staticLayer?.dispose();
    _geometry = _RingGeometry(size: widget.size, facets: widget.facets);
    _staticLayer = _geometry.buildStaticLayer();
  }

  @override
  void dispose() {
    _staticLayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double target = widget.progress.isFinite
        ? widget.progress.clamp(0.0, 1.0)
        : 0.0;
    final Matrix4 tilt = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(widget.tiltDegrees * math.pi / 180);

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
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: <Widget>[
                Transform(
                  alignment: Alignment.center,
                  transform: tilt,
                  child: RepaintBoundary(
                    child: CustomPaint(
                      size: Size.square(widget.size),
                      painter: _RingPainter(
                        geometry: _geometry,
                        staticLayer: _staticLayer,
                        progress: value,
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: Padding(
                    padding: EdgeInsets.all(widget.size * 0.11),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        maxLines: 1,
                        textScaler: TextScaler.noScaling,
                        style: TextStyle(
                          fontSize: value >= 0.995 ? 15 : 18,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -0.4,
                          height: 1,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.geometry,
    required this.staticLayer,
    required this.progress,
  });

  final _RingGeometry geometry;
  final ui.Picture? staticLayer;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final ui.Picture? layer = staticLayer;
    if (layer != null) {
      canvas.drawPicture(layer);
    }
    geometry.paintProgress(canvas, progress);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.staticLayer != staticLayer ||
      oldDelegate.geometry != geometry;
}

/// Geometria e tintas do anel. É criada apenas quando o tamanho muda.
class _RingGeometry {
  _RingGeometry({required this.size, required this.facets}) {
    center = Offset(size / 2, size / 2);
    outerRadius = size * 0.74 / 2;
    thickness = outerRadius * 0.36;
    innerRadius = outerRadius - thickness;
    sweep = 2 * math.pi / facets;
    gap = 0.7 * math.pi / 180;

    facetPaths = List<Path>.generate(facets, (int i) {
      final double start = -math.pi / 2 + i * sweep;
      return _facetPath(start + gap, start + sweep - gap);
    });

    facetColors = List<Color>.generate(facets, (int i) {
      final double midDegrees = (i + 0.5) * 360 / facets;
      final Color base = _colorAt(midDegrees);
      final Color shaded = i.isEven
          ? Color.lerp(base, Colors.white, 0.045)!
          : Color.lerp(base, Colors.black, 0.055)!;
      return shaded.withValues(alpha: 0.9);
    });

    trailColors = List<Color>.generate(
      facets,
      (int i) => i.isEven ? AppColors.white06 : AppColors.white08,
    );

    _fill = Paint()..isAntiAlias = true;
    _line = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = AppColors.white15;
    _halo = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    _ruler = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.8;
    _dot = Paint()..isAntiAlias = true;
    _rim = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.ringRimLight.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final double midRadius = (outerRadius + innerRadius) / 2;
    _cap = Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.linear(
        Offset(midRadius - thickness, 0),
        Offset(midRadius + thickness, 0),
        <Color>[AppColors.capStart, AppColors.capEnd],
      );
    _capGlow = Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.radial(
        Offset(midRadius, 0),
        thickness * 0.9,
        <Color>[
          AppColors.capStart.withValues(alpha: 0.5),
          AppColors.capStart.withValues(alpha: 0),
        ],
      );
  }

  final double size;
  final int facets;

  late final Offset center;
  late final double outerRadius;
  late final double innerRadius;
  late final double thickness;
  late final double sweep;
  late final double gap;

  late final List<Path> facetPaths;
  late final List<Color> facetColors;
  late final List<Color> trailColors;

  late final Paint _fill;
  late final Paint _line;
  late final Paint _halo;
  late final Paint _ruler;
  late final Paint _dot;
  late final Paint _rim;
  late final Paint _cap;
  late final Paint _capGlow;

  static const List<Color> _particleColors = <Color>[
    Color(0xFF8FA9E8),
    AppColors.ringLavenderLight,
    AppColors.capEnd,
  ];

  Path _facetPath(double start, double end) {
    final Path path = Path();
    if (end <= start) {
      return path;
    }
    path.addArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      start,
      end - start,
    );
    path.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius),
      end,
      -(end - start),
      false,
    );
    path.close();
    return path;
  }

  /// Cor do sweep fixo no espaço, em graus a partir de 12h.
  Color _colorAt(double degrees) {
    const List<(double, Color)> stops = <(double, Color)>[
      (0, AppColors.ringMint),
      (60, AppColors.ringLavender),
      (110, AppColors.ringLavenderLight),
      (180, AppColors.ringLavenderGray),
      (270, AppColors.ringSlate),
      (330, AppColors.ringPeriwinkle),
      (360, AppColors.ringMint),
    ];
    final double value = degrees % 360;
    for (int i = 0; i < stops.length - 1; i++) {
      final double from = stops[i].$1;
      final double to = stops[i + 1].$1;
      if (value >= from && value <= to) {
        final double t = to == from ? 0 : (value - from) / (to - from);
        return Color.lerp(stops[i].$2, stops[i + 1].$2, t)!;
      }
    }
    return stops.first.$2;
  }

  ui.Picture buildStaticLayer() {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    _paintTrail(canvas);
    _paintHalo(canvas);
    _paintParticles(canvas);
    _paintRimLight(canvas);
    return recorder.endRecording();
  }

  void _paintTrail(Canvas canvas) {
    for (int i = 0; i < facets; i++) {
      _fill.color = trailColors[i];
      canvas.drawPath(facetPaths[i], _fill);
    }
  }

  void _paintHalo(Canvas canvas) {
    for (int i = 0; i < 9; i++) {
      final double t = i / 8;
      _halo.color =
          Color.lerp(const Color(0xFFE9E6FF), AppColors.ringRimLight, t)!
              .withValues(alpha: 0.10 + 0.10 * t);
      canvas.drawCircle(center, outerRadius * (1.05 + 0.07 * t), _halo);
    }

    // Reforço no lado inferior direito.
    for (int i = 0; i < 3; i++) {
      _halo.color = Colors.white.withValues(alpha: 0.14 + i * 0.03);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius * (1.06 + i * 0.025)),
        0.15 * math.pi,
        0.70 * math.pi,
        false,
        _halo,
      );
    }
  }

  void _paintParticles(Canvas canvas) {
    final math.Random rng = math.Random(11);
    for (int i = 0; i < 30; i++) {
      final double angle = rng.nextDouble() * 2 * math.pi;
      final double radius = outerRadius * (1.12 + rng.nextDouble() * 0.16);
      final Color color = _particleColors[rng.nextInt(_particleColors.length)]
          .withValues(alpha: 0.32 + rng.nextDouble() * 0.45);
      _dot.color = color;
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * radius,
        0.6 + rng.nextDouble() * 1.1,
        _dot,
      );
    }
  }

  void _paintRimLight(Canvas canvas) {
    _rim.strokeWidth = 1.2;
    canvas.drawCircle(center, innerRadius - 0.4, _rim);
  }

  void paintProgress(Canvas canvas, double progress) {
    final double clamped = progress.clamp(0.0, 1.0);
    final double endAngle = -math.pi / 2 + clamped * 2 * math.pi;

    for (int i = 0; i < facets; i++) {
      final double start = -math.pi / 2 + i * sweep;
      final double visibleStart = start + gap;
      final double visibleEnd = start + sweep - gap;
      if (endAngle <= visibleStart) {
        break;
      }
      _fill.color = facetColors[i];
      if (endAngle >= visibleEnd) {
        canvas.drawPath(facetPaths[i], _fill);
      } else {
        canvas.drawPath(_facetPath(visibleStart, endAngle), _fill);
      }
    }

    _paintSeparators(canvas);
    _paintRuler(canvas, endAngle);
    _paintCap(canvas, endAngle);
  }

  void _paintSeparators(Canvas canvas) {
    for (int i = 0; i < facets; i++) {
      final double angle = -math.pi / 2 + i * sweep;
      final Offset direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        center + direction * (innerRadius + 0.4),
        center + direction * (outerRadius - 0.4),
        _line,
      );
    }
  }

  void _paintRuler(Canvas canvas, double endAngle) {
    const int ticks = 24;
    const double rulerSweep = 35 * math.pi / 180;
    final double start = endAngle + 0.16;

    for (int i = 0; i < ticks; i++) {
      final double t = i / (ticks - 1);
      final double angle = start + rulerSweep * t;
      final double edge = math.sin(math.pi * t);
      final Offset direction = Offset(math.cos(angle), math.sin(angle));
      _ruler.color = Colors.white.withValues(alpha: 0.10 + 0.18 * edge);
      _ruler.strokeWidth = 0.7;
      canvas.drawLine(
        center + direction * (outerRadius * 1.05),
        center + direction * (outerRadius * 1.05 + 1.6 + 2.2 * edge),
        _ruler,
      );
    }
  }

  void _paintCap(Canvas canvas, double endAngle) {
    final double midRadius = (outerRadius + innerRadius) / 2;
    final Rect body = Rect.fromCenter(
      center: Offset(midRadius, 0),
      width: thickness * 1.06,
      height: thickness * 0.72,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(endAngle);
    canvas.drawCircle(Offset(midRadius, 0), thickness * 0.9, _capGlow);
    canvas.drawRRect(
      RRect.fromRectAndRadius(body, Radius.circular(thickness * 0.36)),
      _cap,
    );
    canvas.restore();
  }
}
