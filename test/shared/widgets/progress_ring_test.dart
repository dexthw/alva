import 'package:alva/widgets/progress_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final double progress in <double>[0, 0.33, 0.66, 1]) {
    final int percent = (progress * 100).round();

    testWidgets('anel mostra $percent% e cabe em 112dp', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(child: ProgressRing(progress: progress)),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.text('$percent%'), findsOneWidget);
      expect(tester.getSize(find.byType(ProgressRing)), const Size(112, 112));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('progresso fora da faixa é limitado', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: ProgressRing(progress: 1.8)),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('100%'), findsOneWidget);
  });
}
