import 'package:flutter/widgets.dart';

/// Centraliza o respeito a `MediaQuery.disableAnimations`.
extension MotionContext on BuildContext {
  bool get animationsDisabled =>
      MediaQuery.maybeDisableAnimationsOf(this) ?? false;

  Duration motion(Duration duration) =>
      animationsDisabled ? Duration.zero : duration;
}
