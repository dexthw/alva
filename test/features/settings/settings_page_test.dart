import 'package:alva/core/theme/app_theme.dart';
import 'package:alva/features/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app({
  required int habitCount,
  required Future<void> Function() onClear,
}) {
  return MaterialApp(
    theme: buildAppTheme(),
    home: SettingsPage(habitCount: habitCount, onClearData: onClear),
  );
}

void main() {
  testWidgets('apagar todos os dados exige confirmação', (
    WidgetTester tester,
  ) async {
    bool cleared = false;
    await tester.pumpWidget(
      _app(
        habitCount: 2,
        onClear: () async {
          cleared = true;
        },
      ),
    );

    await tester.tap(find.text('Apagar todos os dados'));
    await tester.pumpAndSettle();

    expect(find.text('Apagar todos os dados?'), findsOneWidget);
    expect(cleared, isFalse);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(cleared, isFalse);

    await tester.tap(find.text('Apagar todos os dados'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apagar tudo'));
    await tester.pumpAndSettle();

    expect(cleared, isTrue);
    expect(find.text('Dados apagados.'), findsOneWidget);
  });

  testWidgets('lista quantos hábitos serão apagados', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_app(habitCount: 4, onClear: () async {}));

    await tester.tap(find.text('Apagar todos os dados'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Isto remove 4 hábitos'),
      findsOneWidget,
    );
  });

  testWidgets('item Atualizações abre o histórico de versões', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_app(habitCount: 0, onClear: () async {}));

    await tester.tap(find.text('Atualizações'));
    await tester.pumpAndSettle();

    expect(find.text('Todas as versões do app.'), findsOneWidget);
  });
}
