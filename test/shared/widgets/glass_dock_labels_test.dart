import 'package:alva/core/theme/app_theme.dart';
import 'package:alva/shared/widgets/glass_dock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('rótulos somem quando labelsVisible é falso', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Scaffold(
          body: Center(
            child: GlassDock(
              index: 0,
              labelsVisible: false,
              onSelect: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final Iterable<AnimatedOpacity> labels = tester.widgetList<AnimatedOpacity>(
      find.byType(AnimatedOpacity),
    );
    expect(labels, isNotEmpty);
    expect(labels.every((AnimatedOpacity item) => item.opacity == 0), isTrue);
  });
}
