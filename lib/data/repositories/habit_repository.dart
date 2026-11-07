import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';

/// Situação da leitura do armazenamento local.
enum HabitStorageStatus {
  /// Dados lidos com sucesso.
  ok,

  /// Não há nada salvo (primeira instalação ou tudo apagado).
  empty,

  /// O conteúdo salvo não pôde ser interpretado.
  corrupted,
}

/// Fotografia do estado persistido do app.
class HabitState {
  HabitState({
    required this.habits,
    required this.selectedCategory,
    required this.period,
    this.lastPhrase,
    this.cardsCollapsed = false,
    this.status = HabitStorageStatus.ok,
  });

  final List<Habit> habits;
  final int selectedCategory;
  final Period period;
  final String? lastPhrase;

  /// Todos os cards recolhidos (controle global do cabeçalho).
  final bool cardsCollapsed;
  final HabitStorageStatus status;

  /// Primeira instalação: nenhum hábito, nenhum dado.
  static HabitState empty() => HabitState(
        habits: <Habit>[],
        selectedCategory: 0,
        period: Period.week,
        status: HabitStorageStatus.empty,
      );

  /// Conteúdo ilegível: o app abre vazio em vez de inventar dados.
  static HabitState corrupted() => HabitState(
        habits: <Habit>[],
        selectedCategory: 0,
        period: Period.week,
        status: HabitStorageStatus.corrupted,
      );
}

/// Persistência local em JSON via `shared_preferences`.
///
/// Para trocar por Hive/Isar basta reimplementar `load`/`save` mantendo
/// `HabitState`.
class HabitRepository {
  HabitRepository({SharedPreferences? prefs}) : _prefs = prefs;

  static const String storageKey = 'alva.habits.v1';

  /// Versão do esquema gravada no JSON.
  static const int schemaVersion = 2;

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<HabitState> load() async {
    try {
      final SharedPreferences prefs = await _instance;
      final String? raw = prefs.getString(storageKey);
      if (raw == null || raw.isEmpty) {
        return HabitState.empty();
      }

      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return HabitState.corrupted();
      }

      final Object? rawVersion = decoded['version'];
      final int version = rawVersion is int ? rawVersion : 1;

      final List<Habit> habits = <Habit>[];
      final Object? rawHabits = decoded['habits'];
      if (rawHabits is List) {
        for (final Object? item in rawHabits) {
          final Habit? habit = Habit.tryFromJson(item);
          if (habit == null) {
            continue;
          }
          // v1 criava três hábitos de exemplo na primeira abertura.
          if (version < 2 && _isSeedHabit(habit)) {
            continue;
          }
          habit.recalculateStreak();
          habits.add(habit);
        }
      }

      if (habits.isEmpty) {
        return HabitState.empty();
      }

      final Object? category = decoded['category'];
      final Object? phrase = decoded['lastPhrase'];
      final int safeCategory =
          category is int && category >= 0 && category < habitCategories.length
              ? category
              : 0;

      return HabitState(
        habits: habits,
        selectedCategory: safeCategory,
        period: Period.fromName(decoded['period']),
        lastPhrase: phrase is String && phrase.isNotEmpty ? phrase : null,
        cardsCollapsed: decoded['cardsCollapsed'] == true,
      );
    } catch (_) {
      return HabitState.corrupted();
    }
  }

  /// Registro de exemplo da v1 que nunca foi usado pelo usuário.
  bool _isSeedHabit(Habit habit) {
    const Map<int, String> seeds = <int, String>{
      1: 'Hábito 1',
      2: 'Hábito 2',
      3: 'Hábito 3',
    };
    return seeds[habit.id] == habit.name &&
        habit.completedDays.isEmpty &&
        habit.streak == 0;
  }

  /// Remove tudo o que este repositório guarda.
  Future<void> clear() async {
    try {
      final SharedPreferences prefs = await _instance;
      await prefs.remove(storageKey);
    } catch (_) {
      // Falha de escrita não deve quebrar a interação.
    }
  }

  Future<void> save(HabitState state) async {
    try {
      final SharedPreferences prefs = await _instance;
      final String payload = jsonEncode(<String, dynamic>{
        'version': schemaVersion,
        'habits': state.habits.map((Habit habit) => habit.toJson()).toList(),
        'category': state.selectedCategory,
        'period': state.period.name,
        'lastPhrase': state.lastPhrase,
        'cardsCollapsed': state.cardsCollapsed,
      });
      await prefs.setString(storageKey, payload);
    } catch (_) {
      // Falha de escrita não deve quebrar a interação.
    }
  }
}
