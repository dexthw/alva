import 'package:alva/data/repositories/habit_repository.dart';
import 'package:alva/data/models/habit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('sem dados salvos devolve os hábitos padrão', () async {
    final HabitState state = await HabitRepository().load();

    expect(state.habits.length, 3);
    expect(state.selectedCategory, 0);
    expect(state.period, Period.week);
    expect(state.lastPhrase, isNull);
  });

  test('salva e carrega hábitos, dias, categoria, período e frase', () async {
    final HabitRepository repository = HabitRepository();
    await repository.save(
      HabitState(
        habits: <Habit>[
          Habit(
            id: 7,
            name: 'Corrida',
            category: 'Fitness',
            completedDays: <DateTime>{DateTime(2026, 11, 3)},
            daysCollapsed: true,
          ),
        ],
        selectedCategory: 2,
        period: Period.month,
        lastPhrase: 'Hoje conta.',
      ),
    );

    final HabitState loaded = await HabitRepository().load();
    final Habit habit = loaded.habits.single;

    expect(habit.id, 7);
    expect(habit.name, 'Corrida');
    expect(habit.category, 'Fitness');
    expect(habit.daysCollapsed, isTrue);
    expect(habit.completedDays.contains(DateTime(2026, 11, 3)), isTrue);
    expect(loaded.selectedCategory, 2);
    expect(loaded.period, Period.month);
    expect(loaded.lastPhrase, 'Hoje conta.');
  });

  test('dados corrompidos não travam o app', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      HabitRepository.storageKey: '{isso não é json',
    });

    final HabitState state = await HabitRepository().load();

    expect(state.habits.length, 3);
    expect(state.period, Period.week);
  });

  test('lista de hábitos inválida cai nos padrões', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      HabitRepository.storageKey:
          '{"habits":[{"id":"x","name":"","category":3}],"category":8}',
    });

    final HabitState state = await HabitRepository().load();

    expect(state.habits.length, 3);
    expect(state.selectedCategory, 0);
  });
}
