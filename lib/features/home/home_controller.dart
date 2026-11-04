import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../core/constants.dart';
import '../../data/models/habit.dart';
import '../../data/phrases.dart';
import '../../data/repositories/habit_repository.dart';

/// Estado e regras da Home, sem depender de widgets.
///
/// A UI apenas escuta e chama os métodos; nenhum acesso ao storage acontece
/// fora do repositório.
class HomeController extends ChangeNotifier {
  HomeController({HabitRepository? repository})
    : _repository = repository ?? HabitRepository();

  final HabitRepository _repository;

  List<Habit> _habits = <Habit>[];
  int _selectedCategory = 0;
  Period _period = Period.week;
  String _phrase = motivationPhrases.first;
  bool _showAll = false;
  bool _loaded = false;
  int _nextId = 1;
  HabitStorageStatus _status = HabitStorageStatus.empty;
  final Map<int, int> _bursts = <int, int>{};
  Timer? _saveTimer;

  List<Habit> get habits => List<Habit>.unmodifiable(_habits);
  int get selectedCategory => _selectedCategory;
  Period get period => _period;
  String get phrase => _phrase;
  bool get showAll => _showAll;
  bool get loaded => _loaded;
  HabitStorageStatus get status => _status;

  /// Contador de explosões da chama deste hábito.
  int burstFor(int habitId) => _bursts[habitId] ?? 0;

  int get totalHabits => _habits.length;

  int get completedToday =>
      _habits.where((Habit habit) => habit.isCompletedToday).length;

  /// Progresso do dia: hábitos concluídos hoje ÷ hábitos ativos.
  PeriodStats get todayStats =>
      PeriodStats(completed: completedToday, expected: totalHabits);

  List<Habit> get filteredHabits {
    if (_selectedCategory <= 0) {
      return _habits;
    }
    final String category = habitCategories[_selectedCategory];
    return _habits
        .where((Habit habit) => habit.category == category)
        .toList();
  }

  List<Habit> get visibleHabits => _showAll
      ? filteredHabits
      : filteredHabits.take(AppSizes.visibleHabits).toList();

  Future<void> load() async {
    final HabitState state = await _repository.load();
    _habits = state.habits;
    _selectedCategory = state.selectedCategory;
    _period = state.period;
    _phrase = pickMotivationPhrase(last: state.lastPhrase);
    _status = state.status;
    _nextId =
        _habits.fold<int>(
          0,
          (int max, Habit habit) => math.max(max, habit.id),
        ) +
        1;
    _loaded = true;
    notifyListeners();
    // Não sobrescreve um storage ilegível antes de o usuário decidir.
    if (_status != HabitStorageStatus.corrupted) {
      _scheduleSave();
    }
  }

  /// Marca ou desmarca o hábito hoje e dispara a animação da chama.
  void toggleHabit(Habit habit) {
    final bool completed = habit.toggleOn(DateTime.now());
    if (completed) {
      _bursts[habit.id] = (_bursts[habit.id] ?? 0) + 1;
    }
    notifyListeners();
    _scheduleSave();
  }

  void toggleCollapsed(Habit habit) {
    habit.daysCollapsed = !habit.daysCollapsed;
    notifyListeners();
    _scheduleSave();
  }

  void selectCategory(int index) {
    if (index == _selectedCategory) {
      return;
    }
    _selectedCategory = index;
    _showAll = false;
    notifyListeners();
    _scheduleSave();
  }

  void selectPeriod(Period period) {
    if (period == _period) {
      return;
    }
    _period = period;
    notifyListeners();
    _scheduleSave();
  }

  void toggleShowAll() {
    _showAll = !_showAll;
    notifyListeners();
  }

  void addHabit({required String name, required String category}) {
    _habits.add(Habit(id: _nextId++, name: name, category: category));
    _selectedCategory = 0;
    _showAll = false;
    notifyListeners();
    _scheduleSave();
  }

  void _scheduleSave() {
    if (!_loaded) {
      return;
    }
    _saveTimer?.cancel();
    _saveTimer = Timer(AppDurations.saveDebounce, () => unawaited(saveNow()));
  }

  Future<void> saveNow() async {
    if (!_loaded) {
      return;
    }
    await _repository.save(
      HabitState(
        habits: _habits,
        selectedCategory: _selectedCategory,
        period: _period,
        lastPhrase: _phrase,
      ),
    );
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    unawaited(saveNow());
    super.dispose();
  }
}
