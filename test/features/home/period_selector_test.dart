import 'package:alva/core/theme/app_theme.dart';
import 'package:alva/data/models/habit.dart';
import 'package:alva/features/home/widgets/period_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('seletor de período não desenha divisórias', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Scaffold(
          body: PeriodSelector(value: Period.week, onChanged: (_) {}),
        ),
      ),
    );

    expect(find.byType(VerticalDivider), findsNothing);
    expect(find.byType(Divider), findsNothing);
  });
}
