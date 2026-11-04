/// Tokens de layout e tempo do app.
///
/// Centralizar aqui evita números mágicos espalhados pelos widgets.
library;

class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 14;
  static const double xl = 18;
  static const double xxl = 22;
  static const double page = 20;
}

class AppRadius {
  const AppRadius._();

  static const double chip = 999;
  static const double thumbnail = 16;
  static const double card = 22;
  static const double hero = 24;
  static const double sheet = 28;
}

class AppSizes {
  const AppSizes._();

  static const double heroMinHeight = 144;
  static const double ring = 112;
  static const double thumbnail = 76;
  static const double checkButton = 48;
  static const int visibleHabits = 3;
}

class AppDurations {
  const AppDurations._();

  static const Duration saveDebounce = Duration(milliseconds: 250);
  static const Duration ring = Duration(milliseconds: 600);
  static const Duration listTransition = Duration(milliseconds: 260);
  static const Duration chipTransition = Duration(milliseconds: 240);
}
