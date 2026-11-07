import 'package:alva/core/theme/app_theme.dart';
import 'package:alva/data/models/habit.dart';
import 'package:alva/features/habits/widgets/period_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Habit habit = Habit(
    id: 1,
    name: 'Corrida',
    category: 'Fitness',
    streak: 2,
  );

  Widget build({required bool collapsed}) {
    return MaterialApp(
      theme: buildAppTheme(),
      home: Scaffold(
        body: HabitPeriodView(
          habit: habit,
          period: Period.week,
          collapsed: collapsed,
        ),
      ),
    );
  }

  testWidgets('recolhe e expande os dias com animação', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(build(collapsed: false));
    await tester.pumpAndSettle();
    expect(find.byType(WeekDayPill), findsNWidgets(7));

    await tester.pumpWidget(build(collapsed: true));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(WeekDayPill), findsNWidgets(7));
    await tester.pumpAndSettle();
    expect(find.byType(WeekDayPill), findsNothing);

    await tester.pumpWidget(build(collapsed: false));
    await tester.pumpAndSettle();
    expect(find.byType(WeekDayPill), findsNWidgets(7));
  });
}
