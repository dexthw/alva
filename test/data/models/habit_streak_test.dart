import 'package:alva/data/models/habit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Terça-feira, 3 de novembro de 2026.
  final DateTime now = DateTime(2026, 11, 3);

  Habit habitWith(List<DateTime> days) => Habit(
        id: 1,
        name: 'Teste',
        category: 'Fitness',
        completedDays: days.map(Habit.dayKey).toSet(),
      );

  test('sem dias a sequência é zero', () {
    final Habit habit = habitWith(<DateTime>[]);
    habit.recalculateStreak(now: now);
    expect(habit.streak, 0);
  });

  test('conta dias consecutivos terminando ontem', () {
    final Habit habit = habitWith(<DateTime>[
      DateTime(2026, 11, 1),
      DateTime(2026, 11, 2),
    ]);
    habit.recalculateStreak(now: now);
    expect(habit.streak, 2);
  });

  test('marcar hoje aumenta a sequência', () {
    final Habit habit = habitWith(<DateTime>[
      DateTime(2026, 11, 1),
      DateTime(2026, 11, 2),
    ]);
    habit.recalculateStreak(now: now);

    final bool added = habit.toggleOn(now);

    expect(added, isTrue);
    expect(habit.isCompletedOn(now), isTrue);
    expect(habit.streak, 3);
  });

  test('desmarcar hoje volta a sequência para os dias anteriores', () {
    final Habit habit = habitWith(<DateTime>[
      DateTime(2026, 11, 1),
      DateTime(2026, 11, 2),
      DateTime(2026, 11, 3),
    ]);
    habit.recalculateStreak(now: now);
    expect(habit.streak, 3);

    final bool added = habit.toggleOn(now);

    expect(added, isFalse);
    expect(habit.isCompletedOn(now), isFalse);
    expect(habit.streak, 2);
  });

  test('um dia sem marcar quebra a sequência', () {
    final Habit habit = habitWith(<DateTime>[
      DateTime(2026, 10, 30),
      DateTime(2026, 11, 2),
    ]);
    habit.recalculateStreak(now: now);
    expect(habit.streak, 1);
  });
}
