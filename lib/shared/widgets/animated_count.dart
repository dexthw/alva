import 'package:flutter/material.dart';

import '../../core/utils/animation_utils.dart';

/// Número que conta suavemente até o novo valor.
class AnimatedCount extends StatelessWidget {
  const AnimatedCount({
    super.key,
    required this.value,
    required this.style,
    this.prefix = '',
    this.suffix = '',
  });

  final int value;
  final TextStyle style;
  final String prefix;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: value.toDouble()),
      duration: context.motion(const Duration(milliseconds: 420)),
      curve: Curves.easeOutCubic,
      builder: (BuildContext context, double animated, Widget? child) {
        return Text(
          '$prefix${animated.round()}$suffix',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style,
        );
      },
    );
  }
}
