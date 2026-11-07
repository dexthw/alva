import 'package:alva/shared/widgets/scroll_fade_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double _firstOpacity(WidgetTester tester) {
  return tester
      .widget<Opacity>(
        find
            .descendant(
              of: find.byType(ScrollFadeItem).first,
              matching: find.byType(Opacity),
            )
            .first,
      )
      .opacity;
}

void main() {
  testWidgets('esmaece ao sair pelo topo e volta ao subir', (
    WidgetTester tester,
  ) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            controller: controller,
            children: <Widget>[
              for (int i = 0; i < 10; i++)
                ScrollFadeItem(
                  key: ValueKey<int>(i),
                  child: const SizedBox(height: 120),
                ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(_firstOpacity(tester), 1);

    controller.jumpTo(200);
    await tester.pumpAndSettle();
    expect(_firstOpacity(tester), lessThan(1));

    controller.jumpTo(0);
    await tester.pumpAndSettle();
    expect(_firstOpacity(tester), 1);
  });
}
