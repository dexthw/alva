import 'package:alva/models/habit.dart';
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

  group('porcentagem por período', () {
    test('semana começa em 0%', () {
      final PeriodStats stats = habitWith(<DateTime>[]).stats(
        Period.week,
        now: now,
      );
      expect(stats.completed, 0);
      expect(stats.expected, 2); // segunda e terça
      expect(stats.percent, 0);
      expect(stats.ratio, 0);
    });

    test('semana chega a 100% ao concluir todos os dias esperados', () {
      final PeriodStats stats = habitWith(<DateTime>[
        DateTime(2026, 11, 2),
        DateTime(2026, 11, 3),
      ]).stats(Period.week, now: now);

      expect(stats.completed, 2);
      expect(stats.expected, 2);
      expect(stats.percent, 100);
      expect(stats.ratio, 1);
    });

    test('mês usa os dias decorridos', () {
      final PeriodStats stats = habitWith(<DateTime>[
        DateTime(2026, 11, 1),
        DateTime(2026, 11, 3),
      ]).stats(Period.month, now: now);

      expect(stats.completed, 2);
      expect(stats.expected, 3);
      expect(stats.percent, 67);
    });

    test('ano usa todos os dias decorridos do ano', () {
      final PeriodStats stats = habitWith(<DateTime>[
        DateTime(2026, 1, 1),
        DateTime(2026, 11, 3),
      ]).stats(Period.year, now: now);

      expect(stats.completed, 2);
      expect(stats.expected, 307);
      expect(stats.percent, 1);
    });

    test('dias fora da janela não contam', () {
      final PeriodStats stats = habitWith(<DateTime>[
        DateTime(2026, 10, 31),
        DateTime(2026, 11, 2),
        DateTime(2026, 11, 8), // domingo futuro
      ]).stats(Period.week, now: now);

      expect(stats.completed, 1);
      expect(stats.ratio, 0.5);
    });

    test('clamp mantém o percentual entre 0 e 100', () {
      const PeriodStats acima = PeriodStats(completed: 9, expected: 4);
      const PeriodStats abaixo = PeriodStats(completed: -2, expected: 4);
      const PeriodStats vazio = PeriodStats(completed: 0, expected: 0);

      expect(acima.ratio, 1);
      expect(acima.percent, 100);
      expect(abaixo.ratio, 0);
      expect(abaixo.percent, 0);
      expect(vazio.ratio, 0);
      expect(vazio.percent, 0);
    });
  });
}
