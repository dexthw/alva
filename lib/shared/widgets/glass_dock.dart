import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/animation_utils.dart';

/// Dock flutuante com lente de vidro líquido.
///
/// A lente é vazada, fica um pouco menor em repouso e cresce (com halo) ao ser
/// segurada ou arrastada. Ao soltar, volta ao repouso com mola elástica e
/// encaixa na aba mais próxima. Um toque simples troca de aba. Os ícones nunca
/// mudam de tamanho.
class GlassDock extends StatefulWidget {
  const GlassDock({
    super.key,
    required this.index,
    required this.onSelect,
    this.labelsVisible = true,
  });

  final int index;
  final ValueChanged<int> onSelect;

  /// Falso esconde os rótulos durante a rolagem, deixando só os ícones.
  final bool labelsVisible;

  @override
  State<GlassDock> createState() => _GlassDockState();
}

class _GlassDockState extends State<GlassDock> with TickerProviderStateMixin {
  static const int _tabs = 2;

  /// Mola do encaixe: firme, com overshoot mínimo.
  static const SpringDescription _snapSpring = SpringDescription(
    mass: 1,
    stiffness: 300,
    damping: 27,
  );

  /// Mola da volta ao repouso: mais macia, com leve elasticidade.
  static const SpringDescription _releaseSpring = SpringDescription(
    mass: 1,
    stiffness: 260,
    damping: 18,
  );

  late final AnimationController _lens = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
    upperBound: (_tabs - 1).toDouble(),
    value: widget.index.toDouble(),
  );

  /// 0 = repouso (lente menor), 1 = segurado/arrastado (lente maior + halo).
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  @override
  void didUpdateWidget(covariant GlassDock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _snapTo(widget.index.toDouble(), 0);
    }
  }

  @override
  void dispose() {
    _press.dispose();
    _lens.dispose();
    super.dispose();
  }

  void _snapTo(double target, double velocity) {
    if (context.animationsDisabled) {
      _lens.value = target;
      return;
    }
    _lens.animateWith(
      SpringSimulation(
        _snapSpring,
        _lens.value,
        target,
        velocity.clamp(-8.0, 8.0),
      ),
    );
  }

  void _setPressed(bool pressed) {
    if (!mounted) {
      return;
    }
    if (pressed) {
      _press.forward();
      return;
    }
    if (context.animationsDisabled) {
      _press.value = 0;
      return;
    }
    _press.animateWith(
      SpringSimulation(_releaseSpring, _press.value, 0, 0),
    );
  }

  void _onDragUpdate(DragUpdateDetails details, double itemWidth) {
    final double next = _lens.value + details.delta.dx / itemWidth;
    _lens.value = next.clamp(0.0, (_tabs - 1).toDouble());
  }

  void _onDragEnd(DragEndDetails details, double itemWidth) {
    _setPressed(false);
    final int target = _lens.value.round().clamp(0, _tabs - 1);
    final double velocity = (details.primaryVelocity ?? 0) / itemWidth;
    _snapTo(target.toDouble(), velocity);
    if (target != widget.index) {
      widget.onSelect(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 220),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 66,
                decoration: BoxDecoration(
                  color: AppColors.white08,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double itemWidth = constraints.maxWidth / _tabs;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragStart: (_) => _setPressed(true),
                      onHorizontalDragCancel: () => _setPressed(false),
                      onHorizontalDragUpdate: (DragUpdateDetails details) =>
                          _onDragUpdate(details, itemWidth),
                      onHorizontalDragEnd: (DragEndDetails details) =>
                          _onDragEnd(details, itemWidth),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: Listenable.merge(<Listenable>[
                                _lens,
                                _press,
                              ]),
                              builder: (BuildContext context, Widget? child) {
                                final double press =
                                    Curves.easeOutCubic.transform(_press.value);
                                // Em repouso a lente é menor; ao segurar,
                                // cresce até quase encostar na borda.
                                final double inset = 9 - 4 * press;
                                return Stack(
                                  children: <Widget>[
                                    Positioned(
                                      left: _lens.value * itemWidth + inset,
                                      top: inset,
                                      bottom: inset,
                                      width: itemWidth - inset * 2,
                                      child: _LiquidLens(focus: press),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              _DockItem(
                                label: 'Hoje',
                                icon: widget.index == 0
                                    ? Icons.home
                                    : Icons.home_outlined,
                                selected: widget.index == 0,
                                labelVisible: widget.labelsVisible,
                                onPressStart: () => _setPressed(true),
                                onPressEnd: () => _setPressed(false),
                                onTap: () => widget.onSelect(0),
                              ),
                              _DockItem(
                                label: 'Ajustes',
                                icon: widget.index == 1
                                    ? Icons.settings
                                    : Icons.settings_outlined,
                                selected: widget.index == 1,
                                labelVisible: widget.labelsVisible,
                                onPressStart: () => _setPressed(true),
                                onPressEnd: () => _setPressed(false),
                                onTap: () => widget.onSelect(1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Vidro vazado sem borda externa: apenas o reflexo do topo, um contorno
/// interno discreto e um halo de foco que cresce com [focus].
class _LiquidLens extends StatelessWidget {
  const _LiquidLens({required this.focus});

  final double focus;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.05 + 0.05 * focus),
                blurRadius: 22,
              ),
              BoxShadow(
                color: AppColors.ringArcLavender.withValues(
                  alpha: 0.10 * focus,
                ),
                blurRadius: 18 + 10 * focus,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.20 + 0.10 * focus),
                  width: 0.9,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const <double>[0, 0.42, 1],
                  colors: <Color>[
                    Colors.white.withValues(alpha: 0.14 + 0.08 * focus),
                    Colors.white.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.labelVisible,
    required this.onPressStart,
    required this.onPressEnd,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool labelVisible;
  final VoidCallback onPressStart;
  final VoidCallback onPressEnd;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        label: label,
        button: true,
        selected: selected,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => onPressStart(),
          onTapCancel: onPressEnd,
          onTapUp: (_) => onPressEnd(),
          onTap: onTap,
          child: SizedBox(
            height: 66,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // O ícone mantém sempre o mesmo tamanho e posição.
                Icon(
                  icon,
                  size: 23,
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
                const SizedBox(height: 3),
                AnimatedOpacity(
                  opacity: labelVisible ? 1 : 0,
                  duration: context.motion(const Duration(milliseconds: 220)),
                  curve: Curves.easeOut,
                  child: AnimatedSlide(
                    offset: labelVisible ? Offset.zero : const Offset(0, 0.35),
                    duration: context.motion(const Duration(milliseconds: 220)),
                    curve: Curves.easeOutCubic,
                    child: AnimatedDefaultTextStyle(
                      duration:
                          context.motion(const Duration(milliseconds: 220)),
                      curve: Curves.easeOut,
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 10,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
                            color: selected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                      child: Text(label),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
