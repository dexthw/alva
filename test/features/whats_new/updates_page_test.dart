import 'package:alva/core/theme/app_theme.dart';
import 'package:alva/data/release_notes.dart';
import 'package:alva/features/whats_new/updates_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app() {
  return MaterialApp(theme: buildAppTheme(), home: const UpdatesPage());
}

void main() {
  testWidgets('versão instalada começa aberta', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Todas as versões do app.'), findsOneWidget);
    expect(find.text('Versão ${currentRelease.version}'), findsOneWidget);
    expect(find.text('instalada'), findsOneWidget);
    expect(find.text(currentRelease.news.first), findsOneWidget);
  });

  testWidgets('versão anterior abre ao toque', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ReleaseNote old = releaseHistory.last;
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Versão ${old.version}'), 200);
    await tester.pumpAndSettle();
    expect(find.text(old.news.first), findsNothing);

    await tester.tap(find.text('Versão ${old.version}'));
    await tester.pumpAndSettle();
    expect(find.text(old.news.first), findsOneWidget);
  });
}
