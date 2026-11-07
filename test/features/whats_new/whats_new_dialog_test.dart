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

Widget _app(ReleaseNote note) {
  return MaterialApp(
    theme: buildAppTheme(),
    home: Scaffold(
      body: WhatsNewDialog(
        note: note,
        habitCount: 2,
        onContinue: () {},
        onClearData: () async {},
      ),
    ),
  );
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('lista atual começa resumida e expande por "Ver todas"', (
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

    await tester
        .ensureVisible(find.text('Ver todas as ${note.total} mudanças'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ver todas as ${note.total} mudanças'));
    await tester.pumpAndSettle();

    expect(find.text('Ver menos'), findsOneWidget);
    expect(find.text(note.news.last), findsOneWidget);
  });

  testWidgets('versões anteriores abrem e fecham', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ReleaseNote old = _note('1.0.2');
    await tester.pumpWidget(_app(currentRelease));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Versão 1.0.2'));
    await tester.pumpAndSettle();
    expect(find.text(old.news.first), findsNothing);

    await tester.tap(find.text('Versão 1.0.2'));
    await tester.pumpAndSettle();
    expect(find.text(old.news.first), findsOneWidget);

    await tester.tap(find.text('Versão 1.0.2'));
    await tester.pumpAndSettle();
    expect(find.text(old.news.first), findsNothing);
  });
}
