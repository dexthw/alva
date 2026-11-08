import 'package:alva/core/theme/app_theme.dart';
import 'package:alva/data/release_notes.dart';
import 'package:alva/features/whats_new/whats_new_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ReleaseNote _note(String version) {
  return releaseHistory.firstWhere(
    (ReleaseNote note) => note.version == version,
  );
}

Widget _app(ReleaseNote note, {VoidCallback? onContinue}) {
  return MaterialApp(
    theme: buildAppTheme(),
    home: Scaffold(
      body: WhatsNewDialog(note: note, onContinue: onContinue ?? () {}),
    ),
  );
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('mostra apenas a versão instalada, sem histórico', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(currentRelease));
    await tester.pumpAndSettle();

    expect(find.text('O que há de novo'), findsOneWidget);
    expect(find.text('Versão ${currentRelease.version}'), findsOneWidget);
    expect(find.text('VERSÕES ANTERIORES'), findsNothing);
    expect(find.text('Versão 1.2.0'), findsNothing);
    expect(find.text('Versão 1.0.2'), findsNothing);
  });

  testWidgets('lista começa resumida e expande por "Ver todas"', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ReleaseNote note = _note('1.1.0');
    await tester.pumpWidget(_app(note));
    await tester.pumpAndSettle();

    expect(find.text('Ver todas as ${note.total} mudanças'), findsOneWidget);
    expect(find.text(note.news.last), findsNothing);

    final Finder button = find.text('Ver todas as ${note.total} mudanças');
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Ver menos'), findsOneWidget);
    expect(find.text(note.news.last), findsOneWidget);
  });

  testWidgets('não oferece ação de apagar dados', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_app(currentRelease));
    await tester.pumpAndSettle();

    expect(find.text('Apagar todos os dados'), findsNothing);
  });

  testWidgets('continuar chama o callback e fecha o card', (
    WidgetTester tester,
  ) async {
    bool continued = false;
    await tester.pumpWidget(
      _app(currentRelease, onContinue: () => continued = true),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(continued, isTrue);
  });
}
