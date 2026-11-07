/// Modelo de hábito, período de análise e estatísticas de conclusão.
library;

const List<String> habitCategories = <String>[
  'Todos',
  'Fitness',
  'Health',
  'Estudo',
];

/// Janela de análise do progresso.
enum Period {
  week('Semana'),
  month('Mês'),
  year('Ano');

  const Period(this.label);

  final String label;

  static Period fromName(Object? value) {
    if (value is String) {
      for (final Period period in Period.values) {
        if (period.name == value) {
          return period;
        }
      }
    }
    return Period.week;
  }
}

/// Resultado de um hábito em um período.
class PeriodStats {
  const PeriodStats({required this.completed, required this.expected});

  final int completed;
  final int expected;

  /// Percentual de 0 a 100, sempre dentro dos limites.
  int get percent => (ratio * 100).round();

  /// Proporção concluída, com clamp entre 0 e 1.
  double get ratio {
    if (expected <= 0) {
      return 0;
    }
    return (completed / expected).clamp(0.0, 1.0);
  }
}

class Habit {
  Habit({
    required this.id,
    required this.name,
    required this.category,
    this.streak = 0,
    Set<DateTime>? completedDays,
  }) : completedDays = completedDays ?? <DateTime>{};

  final int id;
  final String name;
  final String category;
  int streak;
  final Set<DateTime> completedDays;

  /// Data sem hora: chave usada no conjunto de dias concluídos.
  static DateTime dayKey(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime _addDays(DateTime date, int days) =>
      DateTime(date.year, date.month, date.day + days);

  bool isCompletedOn(DateTime date) => completedDays.contains(dayKey(date));

  bool get isCompletedToday => isCompletedOn(DateTime.now());

  /// Marca ou desmarca o dia. Retorna `true` quando o dia passou a concluído.
  bool toggleOn(DateTime date) {
    final DateTime key = dayKey(date);
    final bool added = !completedDays.remove(key);
    if (added) {
      completedDays.add(key);
    }
    recalculateStreak(now: date);
    return added;
  }

  /// Sequência de dias consecutivos terminando hoje (ou ontem).
  void recalculateStreak({DateTime? now}) {
    DateTime cursor = dayKey(now ?? DateTime.now());
    if (!completedDays.contains(cursor)) {
      cursor = _addDays(cursor, -1);
    }
    int count = 0;
    while (completedDays.contains(cursor)) {
      count++;
      cursor = _addDays(cursor, -1);
    }
    streak = count;
  }

  /// Concluídos e dias esperados dentro do período selecionado.
  PeriodStats stats(Period period, {DateTime? now}) {
    final DateTime reference = dayKey(now ?? DateTime.now());
    switch (period) {
      case Period.week:
        final DateTime monday = _addDays(reference, -(reference.weekday - 1));
        return PeriodStats(
          completed: _countBetween(monday, reference),
          expected: reference.weekday,
        );
      case Period.month:
        final DateTime first = DateTime(reference.year, reference.month);
        return PeriodStats(
          completed: _countBetween(first, reference),
          expected: reference.day,
        );
      case Period.year:
        final DateTime first = DateTime(reference.year);
        final int elapsed = DateTime.utc(
              reference.year,
              reference.month,
              reference.day,
            ).difference(DateTime.utc(reference.year)).inDays +
            1;
        return PeriodStats(
          completed: _countBetween(first, reference),
          expected: elapsed,
        );
    }
  }

  /// Proporção concluída no período, já com clamp.
  double completion(Period period, {DateTime? now}) =>
      stats(period, now: now).ratio;

  int _countBetween(DateTime start, DateTime end) {
    int count = 0;
    for (final DateTime day in completedDays) {
      if (!day.isBefore(start) && !day.isAfter(end)) {
        count++;
      }
    }
    return count;
  }

  Map<String, dynamic> toJson() {
    final List<String> days = completedDays.map(_isoDay).toList()..sort();
    return <String, dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'streak': streak,
      'days': days,
    };
  }

  /// Leitura tolerante: devolve `null` para registros inválidos.
  static Habit? tryFromJson(Object? raw) {
    if (raw is! Map) {
      return null;
    }
    final Object? id = raw['id'];
    final Object? name = raw['name'];
    final Object? category = raw['category'];
    if (id is! int || name is! String || category is! String) {
      return null;
    }
    if (name.trim().isEmpty) {
      return null;
    }

    final Set<DateTime> days = <DateTime>{};
    final Object? rawDays = raw['days'];
    if (rawDays is List) {
      for (final Object? item in rawDays) {
        if (item is String) {
          final DateTime? parsed = DateTime.tryParse(item);
          if (parsed != null) {
            days.add(dayKey(parsed));
          }
        }
      }
    }

    return Habit(
      id: id,
      name: name,
      category: category,
      streak: raw['streak'] is int ? raw['streak'] as int : 0,
      completedDays: days,
    );
  }

  static String _isoDay(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year.toString().padLeft(4, '0')}-$month-$day';
  }
}
