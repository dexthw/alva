import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';

/// Fotografia do estado persistido do app.
class HabitState {
  HabitState({
    required this.habits,
    required this.selectedCategory,
    required this.period,
    this.lastPhrase,
  });

  final List<Habit> habits;
  final int selectedCategory;
  final Period period;
  final String? lastPhrase;

  static HabitState defaults() => HabitState(
    habits: <Habit>[
      Habit(id: 1, name: 'Hábito 1', category: 'Fitness'),
      Habit(id: 2, name: 'Hábito 2', category: 'Health'),
      Habit(id: 3, name: 'Hábito 3', category: 'Estudo'),
    ],
    selectedCategory: 0,
    period: Period.week,
  );
}

/// Persistência local em JSON via `shared_preferences`.
///
/// A camada é intencionalmente pequena: para trocar por Hive/Isar basta
/// reimplementar `load`/`save` mantendo `HabitState`.
class HabitRepository {
  HabitRepository({SharedPreferences? prefs}) : _prefs = prefs;

  static const String storageKey = 'alva.habits.v1';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<HabitState> load() async {
    try {
      final SharedPreferences prefs = await _instance;
      final String? raw = prefs.getString(storageKey);
      if (raw == null || raw.isEmpty) {
        return HabitState.defaults();
      }

      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return HabitState.defaults();
      }

      final List<Habit> habits = <Habit>[];
      final Object? rawHabits = decoded['habits'];
      if (rawHabits is List) {
        for (final Object? item in rawHabits) {
          final Habit? habit = Habit.tryFromJson(item);
          if (habit != null) {
            habit.recalculateStreak();
            habits.add(habit);
          }
        }
      }
      if (habits.isEmpty) {
        return HabitState.defaults();
      }

      final Object? category = decoded['category'];
      final Object? phrase = decoded['lastPhrase'];
      final int safeCategory = category is int &&
              category >= 0 &&
              category < habitCategories.length
          ? category
          : 0;

      return HabitState(
        habits: habits,
        selectedCategory: safeCategory,
        period: Period.fromName(decoded['period']),
        lastPhrase: phrase is String && phrase.isNotEmpty ? phrase : null,
      );
    } catch (_) {
      // Dados corrompidos não podem impedir o app de abrir.
      return HabitState.defaults();
    }
  }

  Future<void> save(HabitState state) async {
    try {
      final SharedPreferences prefs = await _instance;
      final String payload = jsonEncode(<String, dynamic>{
        'version': 1,
        'habits': state.habits.map((Habit habit) => habit.toJson()).toList(),
        'category': state.selectedCategory,
        'period': state.period.name,
        'lastPhrase': state.lastPhrase,
      });
      await prefs.setString(storageKey, payload);
    } catch (_) {
      // Falha de escrita não deve quebrar a interação.
    }
  }
}
