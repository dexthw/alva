import 'package:alva/shared/widgets/streak_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Maior alfa de brilho encontrado nas sombras da chama.
double _maxGlowAlpha(WidgetTester tester) {
  double maxAlpha = 0;
  for (final Container container in tester.widgetList<Container>(
    find.byType(Container),
  )) {
    final Decoration? decoration = container.decoration;
    if (decoration is! BoxDecoration) {
      continue;
    }
    for (final BoxShadow shadow
        in decoration.boxShadow ?? const <BoxShadow>[]) {
      if (shadow.color.a > maxAlpha) {
        maxAlpha = shadow.color.a;
      }
    }
  }
  return maxAlpha;
}

Widget _flame({int burstToken = 0}) => MaterialApp(
      home: Scaffold(
        body: Center(child: StreakFlame(streak: 4, burstToken: burstToken)),
      ),
    );

void main() {
  testWidgets('brilho já está presente no primeiro frame após concluir', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_flame());
    await tester.pump(const Duration(milliseconds: 700));
    expect(_maxGlowAlpha(tester), greaterThan(0.05));

    await tester.pumpWidget(_flame(burstToken: 1));
    await tester.pump();

    expect(_maxGlowAlpha(tester), greaterThan(0.05));
  });

  testWidgets('burst não apaga o brilho no pico', (WidgetTester tester) async {
    await tester.pumpWidget(_flame());
    await tester.pump(const Duration(milliseconds: 700));

    await tester.pumpWidget(_flame(burstToken: 1));
    await tester.pump(const Duration(milliseconds: 310));

    expect(_maxGlowAlpha(tester), greaterThan(0.05));
  });
}
