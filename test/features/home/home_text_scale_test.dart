import 'dart:convert';

import 'package:alva/core/theme/app_theme.dart';
import 'package:alva/data/repositories/habit_repository.dart';
import 'package:alva/features/home/home_controller.dart';
import 'package:alva/features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> _habit(int id, String name, String category) =>
    <String, dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'streak': 0,
      'days': <String>[],
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home em 360dp com texto 1.3 não estoura', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      HabitRepository.storageKey: jsonEncode(<String, dynamic>{
        'version': 2,
        'habits': <Map<String, dynamic>>[
          _habit(1, 'Corrida', 'Fitness'),
          _habit(2, 'Leitura', 'Estudo'),
          _habit(3, 'Beber água', 'Health'),
          _habit(4, 'Meditar', 'Estudo'),
        ],
        'category': 0,
        'period': 'week',
      }),
    });

    final HomeController controller = HomeController();
    addTearDown(controller.dispose);
    await controller.load();

    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.3)),
            child: child!,
          );
        },
        home: HomePage(controller: controller),
      ),
    );
    await tester.pump(const Duration(milliseconds: 900));

    expect(tester.takeException(), isNull);
  });
}
