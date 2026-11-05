import 'dart:convert';

import 'package:alva/data/models/habit.dart';
import 'package:alva/data/repositories/habit_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('primeira instalação não cria nenhum hábito', () async {
    final HabitState state = await HabitRepository().load();

    expect(state.habits, isEmpty);
    expect(state.status, HabitStorageStatus.empty);
    expect(state.selectedCategory, 0);
    expect(state.period, Period.week);
  });

  test(
    'salva e carrega hábitos, dias, categoria, período, frase e cards',
    () async {
      final HabitRepository repository = HabitRepository();
      await repository.save(
        HabitState(
          habits: <Habit>[
            Habit(
              id: 7,
              name: 'Corrida',
              category: 'Fitness',
              completedDays: <DateTime>{DateTime(2026, 11, 3)},
            ),
          ],
          selectedCategory: 2,
          period: Period.month,
          lastPhrase: 'Hoje conta.',
          cardsCollapsed: true,
        ),
      );

      final HabitState loaded = await HabitRepository().load();
      final Habit habit = loaded.habits.single;

      expect(habit.id, 7);
      expect(habit.name, 'Corrida');
      expect(habit.category, 'Fitness');
      expect(loaded.cardsCollapsed, isTrue);
      expect(habit.completedDays.contains(DateTime(2026, 11, 3)), isTrue);
      expect(loaded.selectedCategory, 2);
      expect(loaded.period, Period.month);
      expect(loaded.lastPhrase, 'Hoje conta.');
      expect(loaded.status, HabitStorageStatus.ok);
    },
  );

  test('dados corrompidos abrem vazio e sinalizam erro', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      HabitRepository.storageKey: '{isso não é json',
    });

    final HabitState state = await HabitRepository().load();

    expect(state.habits, isEmpty);
    expect(state.status, HabitStorageStatus.corrupted);
  });

  test('lista inválida abre vazio e sinaliza erro', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      HabitRepository.storageKey:
          '{"habits":[{"id":"x","name":"","category":3}],"category":8}',
    });

    final HabitState state = await HabitRepository().load();

    expect(state.habits, isEmpty);
    expect(state.status, HabitStorageStatus.empty);
  });

  test('migração v1 descarta só os três exemplos intactos', () async {
    final Map<String, dynamic> seed = <String, dynamic>{
      'version': 1,
      'habits': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 1,
          'name': 'Hábito 1',
          'category': 'Fitness',
          'streak': 0,
          'collapsed': false,
          'days': <String>[],
        },
        <String, dynamic>{
          'id': 2,
          'name': 'Hábito 2',
          'category': 'Health',
          'streak': 0,
          'collapsed': false,
          'days': <String>[],
        },
        <String, dynamic>{
          'id': 3,
          'name': 'Hábito 3',
          'category': 'Estudo',
          'streak': 0,
          'collapsed': false,
          'days': <String>[],
        },
        <String, dynamic>{
          'id': 9,
          'name': 'Corrida',
          'category': 'Fitness',
          'streak': 1,
          'collapsed': false,
          'days': <String>['2026-11-03'],
        },
      ],
      'category': 1,
      'period': 'month',
    };

    SharedPreferences.setMockInitialValues(<String, Object>{
      HabitRepository.storageKey: jsonEncode(seed),
    });

    final HabitState state = await HabitRepository().load();

    expect(state.habits.length, 1);
    expect(state.habits.single.name, 'Corrida');
    expect(state.selectedCategory, 1);
    expect(state.period, Period.month);
  });

  test('exemplo já usado pelo usuário não é descartado', () async {
    final Map<String, dynamic> seed = <String, dynamic>{
      'version': 1,
      'habits': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 1,
          'name': 'Hábito 1',
          'category': 'Fitness',
          'streak': 1,
          'collapsed': false,
          'days': <String>['2026-11-03'],
        },
      ],
    };

    SharedPreferences.setMockInitialValues(<String, Object>{
      HabitRepository.storageKey: jsonEncode(seed),
    });

    final HabitState state = await HabitRepository().load();

    expect(state.habits.length, 1);
    expect(state.habits.single.name, 'Hábito 1');
  });
}
