import 'package:alva/shared/widgets/glass_dock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _dock({required int index, required ValueChanged<int> onSelect}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: GlassDock(index: index, onSelect: onSelect)),
    ),
  );
}

void main() {
  testWidgets('toque simples troca de aba', (WidgetTester tester) async {
    int selected = 0;
    await tester.pumpWidget(_dock(index: 0, onSelect: (int i) => selected = i));

    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();

    expect(selected, 1);
  });

  testWidgets('arrastar move a lente e encaixa na aba vizinha', (
    WidgetTester tester,
  ) async {
    int selected = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return GlassDock(
                  index: selected,
                  onSelect: (int i) => setState(() => selected = i),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.byType(GlassDock), const Offset(160, 0));
    await tester.pumpAndSettle();

    expect(selected, 1);
  });

  testWidgets('arrasto pequeno volta para a aba atual', (
    WidgetTester tester,
  ) async {
    int selected = 0;
    await tester.pumpWidget(_dock(index: 0, onSelect: (int i) => selected = i));

    await tester.drag(find.byType(GlassDock), const Offset(20, 0));
    await tester.pumpAndSettle();

    expect(selected, 0);
  });
}
