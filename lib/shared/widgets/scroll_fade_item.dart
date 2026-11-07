import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Esmaece e reduz levemente o item conforme ele sai pelo topo do viewport.
///
/// O efeito é proporcional ao deslocamento (reversível ao subir) e só
/// reconstrói o wrapper de opacidade/escala, nunca o conteúdo.
class ScrollFadeItem extends StatelessWidget {
  const ScrollFadeItem({
    super.key,
    required this.child,
    this.distance = 150,
    this.minOpacity = 0.28,
    this.minScale = 0.95,
  });

  final Widget child;

  /// Distância em pixels em que o item vai de opaco a [minOpacity].
  final double distance;
  final double minOpacity;
  final double minScale;

  /// Offset de scroll em que o topo do item encosta no topo do viewport.
  ///
  /// É lido do layout (estável durante a rolagem), enquanto a posição atual é
  /// lida ao vivo da `ScrollPosition`.
  double _startOffset(BuildContext context) {
    final RenderObject? box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) {
      return 0;
    }
    final RenderAbstractViewport? viewport =
        RenderAbstractViewport.maybeOf(box);
    if (viewport == null) {
      return 0;
    }
    return viewport.getOffsetToReveal(box, 0).offset;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollPosition? position = Scrollable.maybeOf(context)?.position;
    if (position == null) {
      return child;
    }

    return AnimatedBuilder(
      animation: position,
      child: child,
      builder: (BuildContext context, Widget? cached) {
        final double start = _startOffset(context);
        final double progress =
            ((position.pixels - start) / distance).clamp(0.0, 1.0);
        return Opacity(
          opacity: 1 - (1 - minOpacity) * progress,
          child: Transform.scale(
            scale: 1 - (1 - minScale) * progress,
            alignment: Alignment.topCenter,
            child: cached,
          ),
        );
      },
    );
  }
}
