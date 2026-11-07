import 'dart:math' as math;

import 'package:alva/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double _linear(double channel) {
  return channel <= 0.03928
      ? channel / 12.92
      : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();
}

double _luminance(Color color) {
  return 0.2126 * _linear(color.r) +
      0.7152 * _linear(color.g) +
      0.0722 * _linear(color.b);
}

double _contrast(Color foreground, Color background) {
  final double a = _luminance(foreground);
  final double b = _luminance(background);
  final double lighter = math.max(a, b);
  final double darker = math.min(a, b);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  const double aa = 4.5;

  test('texto destrutivo e avisos passam no WCAG AA', () {
    expect(
      _contrast(AppColors.dangerText, AppColors.cardSurface),
      greaterThanOrEqualTo(aa),
      reason: '"Apagar dados" em Ajustes',
    );
    expect(
      _contrast(AppColors.dangerText, AppColors.background),
      greaterThanOrEqualTo(aa),
    );
    expect(
      _contrast(Colors.white, AppColors.dangerStrong),
      greaterThanOrEqualTo(aa),
      reason: 'botão "Apagar tudo" do diálogo',
    );
    expect(
      _contrast(AppColors.textPrimary, AppColors.chipSurface),
      greaterThanOrEqualTo(aa),
      reason: 'aviso "Filtros avançados em breve."',
    );
    expect(
      _contrast(AppColors.textSecondary, AppColors.cardSurface),
      greaterThanOrEqualTo(aa),
      reason: 'subtítulos dos cards e do diálogo',
    );
  });
}
