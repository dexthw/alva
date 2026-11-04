import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/utils/animation_utils.dart';
import '../../core/theme/app_colors.dart';

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
    this.tiltDegrees = 30,
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
      ..setEntry(3, 2, 0.0008)
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
                    padding: EdgeInsets.all(widget.size * 0.2),
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

/// Geometria, tintas e camada estática do anel.
class _RingGeometry {
  _RingGeometry({required this.size, required this.facets}) {
    center = Offset(size / 2, size / 2);
    outerRadius = size * 0.74 / 2;
    thickness = outerRadius * 0.36;
    innerRadius = outerRadius - thickness;
    midRadius = (outerRadius + innerRadius) / 2;
    sweep = 2 * math.pi / facets;
    gap = 0.55 * math.pi / 180;

    facetPaths = List<Path>.generate(facets, (int i) {
      final double start = -math.pi / 2 + i * sweep;
      return _facetPath(start + gap, start + sweep - gap);
    });

    facetPaints = List<Paint>.generate(
      facets,
      (int i) => _facetPaint(i, filled: true),
    );
    facetStrokes = List<Paint>.generate(
      facets,
      (int i) => _facetStroke(i, filled: true),
    );
    trailPaints = List<Paint>.generate(
      facets,
      (int i) => _facetPaint(i, filled: false),
    );
    trailStrokes = List<Paint>.generate(
      facets,
      (int i) => _facetStroke(i, filled: false),
    );

    _bevel = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7
      ..color = Colors.white.withValues(alpha: 0.08);
    _trailBevel = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..color = Colors.white.withValues(alpha: 0.04);
    _halo = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.45;
    _ruler = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.6;
    _dot = Paint()..isAntiAlias = true;
    _rim = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.ringRimLight.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.6);

    _cap = Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.linear(
        Offset(midRadius, -thickness * 0.7),
        Offset(midRadius, thickness * 0.7),
        <Color>[const Color(0xFFFFF2F7), const Color(0xFFEFB8D1)],
      );
    _capHighlight = Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.radial(
        Offset.zero,
        thickness * 0.36,
        <Color>[
          Colors.white.withValues(alpha: 0.26),
          Colors.white.withValues(alpha: 0),
        ],
      );
    _capGlow = Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.radial(
        Offset(midRadius, 0),
        thickness * 0.9,
        <Color>[
          AppColors.capStart.withValues(alpha: 0.34),
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
  late final double midRadius;
  late final double sweep;
  late final double gap;

  late final List<Path> facetPaths;
  late final List<Paint> facetPaints;
  late final List<Paint> facetStrokes;
  late final List<Paint> trailPaints;
  late final List<Paint> trailStrokes;

  late final Paint _bevel;
  late final Paint _trailBevel;
  late final Paint _halo;
  late final Paint _ruler;
  late final Paint _dot;
  late final Paint _rim;
  late final Paint _cap;
  late final Paint _capGlow;
  late final Paint _capHighlight;

  static const List<Color> _particleColors = <Color>[
    Color(0xFF8FA9E8),
    AppColors.ringLavenderLight,
    AppColors.capEnd,
  ];

  static const Color _trailBase = Color(0xFF5A6489);

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

  Paint _facetPaint(int index, {required bool filled}) {
    final double midDegrees = (index + 0.5) * 360 / facets;
    final double midAngle = -math.pi / 2 + (index + 0.5) * sweep;
    final Offset direction = Offset(math.cos(midAngle), math.sin(midAngle));
    Color base = filled ? _colorAt(midDegrees) : _trailBase;
    // Luminosidade alternada de ±3% entre facetas vizinhas.
    base = index.isEven
        ? Color.lerp(base, Colors.white, 0.03)!
        : Color.lerp(base, Colors.black, 0.03)!;

    final Color inner = Color.lerp(base, Colors.black, filled ? 0.14 : 0.22)!;
    final Color outer = Color.lerp(base, Colors.white, filled ? 0.14 : 0.06)!;

    return Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.linear(
        center + direction * innerRadius,
        center + direction * outerRadius,
        <Color>[
          inner.withValues(alpha: filled ? 0.94 : 0.66),
          outer.withValues(alpha: filled ? 0.97 : 0.50),
        ],
      );
  }

  Paint _facetStroke(int index, {required bool filled}) {
    final double midDegrees = (index + 0.5) * 360 / facets;
    final Color base = filled ? _colorAt(midDegrees) : _trailBase;
    return Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeJoin = StrokeJoin.round
      ..color = filled
          ? Color.lerp(base, Colors.white, 0.04)!.withValues(alpha: 0.85)
          : base.withValues(alpha: 0.5);
  }

  ui.Picture buildStaticLayer() {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    _paintTrail(canvas);
    _paintRimLight(canvas);
    _paintHalo(canvas);
    _paintParticles(canvas);
    return recorder.endRecording();
  }

  void _paintTrail(Canvas canvas) {
    for (int i = 0; i < facets; i++) {
      canvas.drawPath(facetPaths[i], trailPaints[i]);
      canvas.drawPath(facetPaths[i], trailStrokes[i]);
      canvas.drawPath(facetPaths[i], _trailBevel);
    }
  }

  void _paintRimLight(Canvas canvas) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius - 0.4),
      -2.6,
      3.0,
      false,
      _rim,
    );
  }

  void _paintHalo(Canvas canvas) {
    for (int i = 0; i < 10; i++) {
      final double t = i / 9;
      _halo.color =
          Color.lerp(const Color(0xFFF2F0FF), AppColors.ringRimLight, t)!
              .withValues(alpha: 0.06 + 0.10 * t);
      canvas.drawCircle(center, outerRadius * (1.035 + 0.09 * t), _halo);
    }

    // Reforço discreto no lado inferior direito.
    for (int i = 0; i < 2; i++) {
      _halo.color = Colors.white.withValues(alpha: 0.12 + i * 0.03);
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: outerRadius * (1.06 + i * 0.03),
        ),
        0.2 * math.pi,
        0.7 * math.pi,
        false,
        _halo,
      );
    }
  }

  void _paintParticles(Canvas canvas) {
    final math.Random rng = math.Random(7);
    for (int i = 0; i < 20; i++) {
      final double angle = rng.nextDouble() * 2 * math.pi;
      final double radius = outerRadius * (1.14 + rng.nextDouble() * 0.13);
      final Color color = _particleColors[rng.nextInt(_particleColors.length)]
          .withValues(alpha: 0.22 + rng.nextDouble() * 0.45);
      _dot.color = color;
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * radius,
        0.45 + rng.nextDouble() * 0.9,
        _dot,
      );
    }
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
      if (endAngle >= visibleEnd) {
        canvas.drawPath(facetPaths[i], facetPaints[i]);
        canvas.drawPath(facetPaths[i], facetStrokes[i]);
        canvas.drawPath(facetPaths[i], _bevel);
      } else {
        final Path partial = _facetPath(visibleStart, endAngle);
        canvas.drawPath(partial, facetPaints[i]);
        canvas.drawPath(partial, facetStrokes[i]);
        canvas.drawPath(partial, _bevel);
      }
    }

    _paintRuler(canvas, endAngle);
    _paintCap(canvas, endAngle);
  }

  void _paintRuler(Canvas canvas, double endAngle) {
    const int ticks = 20;
    const double rulerSweep = 34 * math.pi / 180;
    final double start = endAngle + 0.12;
    final double base = outerRadius * 1.085;

    for (int i = 0; i < ticks; i++) {
      final double t = i / (ticks - 1);
      final double angle = start + rulerSweep * t;
      final double edge = math.sin(math.pi * t);
      final Offset direction = Offset(math.cos(angle), math.sin(angle));
      _ruler.color = Colors.white.withValues(alpha: 0.07 + 0.13 * edge);
      canvas.drawLine(
        center + direction * base,
        center + direction * (base + 1.8 + 2.2 * edge),
        _ruler,
      );
    }
  }

  void _paintCap(Canvas canvas, double endAngle) {
    final double capRadial = thickness * 1.02;
    final double capTangential = thickness * 1.38;
    final double capCenterRadius = midRadius;
    final Rect body = Rect.fromCenter(
      center: Offset(capCenterRadius, 0),
      width: capRadial,
      height: capTangential,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(endAngle);
    canvas.drawCircle(Offset(capCenterRadius, 0), thickness * 0.95, _capGlow);
    canvas.drawRRect(
      RRect.fromRectAndRadius(body, Radius.circular(capRadial * 0.5)),
      _cap,
    );
    canvas.save();
    canvas.translate(
      capCenterRadius - thickness * 0.12,
      -capTangential * 0.2,
    );
    canvas.drawCircle(Offset.zero, thickness * 0.5, _capHighlight);
    canvas.restore();
    canvas.restore();
  }
}
