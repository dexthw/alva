import 'dart:convert';

import 'package:alva/data/models/habit.dart';
import 'package:alva/data/repositories/habit_repository.dart';
import 'package:alva/features/home/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> _habit(int id, String name, String category) =>
    <String, dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'streak': 0,
      'collapsed': false,
      'days': <String>[],
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void seedThreeHabits() {
    SharedPreferences.setMockInitialValues(<String, Object>{
      HabitRepository.storageKey: jsonEncode(<String, dynamic>{
        'version': 2,
        'habits': <Map<String, dynamic>>[
          _habit(1, 'Corrida', 'Fitness'),
          _habit(2, 'Leitura', 'Estudo'),
          _habit(3, 'Água', 'Health'),
        ],
        'category': 0,
        'period': 'week',
      }),
    });
  }

  test('filtro Todos mostra cada hábito uma única vez', () async {
    seedThreeHabits();
    final HomeController controller = HomeController();
    addTearDown(controller.dispose);

    await controller.load();

    expect(
      controller.filteredHabits.map((Habit habit) => habit.id).toList(),
      <int>[1, 2, 3],
    );
    expect(controller.visibleHabits.length, 3);

    controller.selectPeriod(Period.month);
    expect(controller.filteredHabits.length, 3);
    controller.selectPeriod(Period.year);
    expect(controller.filteredHabits.length, 3);
  });

  test('filtro de categoria mostra apenas os hábitos dela', () async {
    seedThreeHabits();
    final HomeController controller = HomeController();
    addTearDown(controller.dispose);

    await controller.load();
    controller.selectCategory(1); // Fitness

    expect(controller.filteredHabits.single.name, 'Corrida');
    expect(controller.visibleHabits.length, 1);
  });

  test('primeira instalação abre vazia e com progresso zero', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final HomeController controller = HomeController();
    addTearDown(controller.dispose);

    await controller.load();

    expect(controller.habits, isEmpty);
    expect(controller.loaded, isTrue);
    expect(controller.status, HabitStorageStatus.empty);
    expect(controller.todayStats.completed, 0);
    expect(controller.todayStats.expected, 0);
    expect(controller.todayStats.ratio, 0);
  });

  test('concluir hoje atualiza a contagem do dia', () async {
    seedThreeHabits();
    final HomeController controller = HomeController();
    addTearDown(controller.dispose);

    await controller.load();
    controller.toggleHabit(controller.habits.first);

    expect(controller.completedToday, 1);
    expect(controller.todayStats.completed, 1);
    expect(controller.todayStats.expected, 3);
    expect(controller.todayStats.percent, 33);
  });

  test('trocar o período não muda o progresso de hoje', () async {
    seedThreeHabits();
    final HomeController controller = HomeController();
    addTearDown(controller.dispose);

    await controller.load();
    controller.toggleHabit(controller.habits.first);

    final PeriodStats antes = controller.todayStats;
    controller.selectPeriod(Period.year);

    expect(controller.todayStats.completed, antes.completed);
    expect(controller.todayStats.expected, antes.expected);
  });

  test('Controller não inventa hábitos com storage corrompido', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      HabitRepository.storageKey: '{quebrado',
    });
    final HomeController controller = HomeController();
    addTearDown(controller.dispose);

    await controller.load();

    expect(controller.habits, isEmpty);
    expect(controller.status, HabitStorageStatus.corrupted);
  });
}
