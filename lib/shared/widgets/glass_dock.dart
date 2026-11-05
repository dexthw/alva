import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/animation_utils.dart';

/// Dock flutuante com lente de vidro líquido.
///
/// A lente é vazada e só se move quando o próprio dock é arrastado; ao soltar,
/// ela encaixa na aba mais próxima. Um toque simples continua trocando de aba.
class GlassDock extends StatefulWidget {
  const GlassDock({super.key, required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  State<GlassDock> createState() => _GlassDockState();
}

class _GlassDockState extends State<GlassDock>
    with SingleTickerProviderStateMixin {
  static const int _tabs = 2;
  static const Duration _settle = Duration(milliseconds: 300);

  late final AnimationController _lens = AnimationController(
    vsync: this,
    duration: _settle,
    upperBound: (_tabs - 1).toDouble(),
    value: widget.index.toDouble(),
  );

  @override
  void didUpdateWidget(covariant GlassDock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index && !_lens.isAnimating) {
      _lens.animateTo(
        widget.index.toDouble(),
        duration: context.motion(_settle),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _lens.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, double itemWidth) {
    final double next = _lens.value + details.delta.dx / itemWidth;
    _lens.value = next.clamp(0.0, (_tabs - 1).toDouble());
  }

  void _onDragEnd() {
    final int target = _lens.value.round().clamp(0, _tabs - 1);
    _lens.animateTo(
      target.toDouble(),
      duration: context.motion(_settle),
      curve: Curves.easeOutCubic,
    );
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
                  border: Border.all(color: AppColors.white12),
                ),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double itemWidth = constraints.maxWidth / _tabs;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragUpdate: (DragUpdateDetails details) =>
                          _onDragUpdate(details, itemWidth),
                      onHorizontalDragEnd: (_) => _onDragEnd(),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _lens,
                              builder: (BuildContext context, Widget? child) {
                                return Stack(
                                  children: <Widget>[
                                    Positioned(
                                      left: _lens.value * itemWidth + 6,
                                      top: 6,
                                      bottom: 6,
                                      width: itemWidth - 12,
                                      child: const _LiquidLens(),
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
                                onTap: () => widget.onSelect(0),
                              ),
                              _DockItem(
                                label: 'Ajustes',
                                icon: widget.index == 1
                                    ? Icons.settings
                                    : Icons.settings_outlined,
                                selected: widget.index == 1,
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

/// Vidro vazado com borda dupla: sem preenchimento no centro.
class _LiquidLens extends StatelessWidget {
  const _LiquidLens();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.52),
            width: 1.3,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.14),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.22),
                width: 0.9,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const <double>[0, 0.42, 1],
                colors: <Color>[
                  Colors.white.withValues(alpha: 0.16),
                  Colors.white.withValues(alpha: 0.02),
                  Colors.transparent,
                ],
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
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
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
          onTap: onTap,
          child: SizedBox(
            height: 66,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedScale(
                  scale: selected ? 1.05 : 1,
                  duration: context.motion(const Duration(milliseconds: 200)),
                  child: Icon(
                    icon,
                    size: 23,
                    color: selected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
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
