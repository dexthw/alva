import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/animation_utils.dart';
import '../data/habit_repository.dart';
import '../data/motivation_phrases.dart';
import '../models/habit.dart';
import '../theme/app_colors.dart';
import '../widgets/dot_grid.dart';
import '../widgets/home/category_chips.dart';
import '../widgets/home/habit_card.dart';
import '../widgets/home/header.dart';
import '../widgets/home/hero_progress_card.dart';
import '../widgets/home/new_habit_sheet.dart';
import '../widgets/home/period_selector.dart';
import '../widgets/home/section_header.dart';
import '../widgets/staggered_entry.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HabitRepository _repository = HabitRepository();
  final Map<int, int> _bursts = <int, int>{};

  List<Habit> _habits = <Habit>[];
  int _selectedCategory = 0;
  Period _period = Period.week;
  String _phrase = motivationPhrases.first;
  bool _showAll = false;
  bool _loaded = false;
  int _nextId = 1;
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _saveNow();
    super.dispose();
  }

  Future<void> _load() async {
    final HabitState state = await _repository.load();
    if (!mounted) {
      return;
    }
    setState(() {
      _habits = state.habits;
      _selectedCategory = state.selectedCategory;
      _period = state.period;
      _phrase = pickMotivationPhrase(last: state.lastPhrase);
      _nextId = _habits.fold<int>(
            0,
            (int max, Habit habit) => math.max(max, habit.id),
          ) +
          1;
      _loaded = true;
    });
    _scheduleSave();
  }

  List<Habit> get _filteredHabits {
    if (_selectedCategory <= 0) {
      return _habits;
    }
    final String category = habitCategories[_selectedCategory];
    return _habits
        .where((Habit habit) => habit.category == category)
        .toList();
  }

  PeriodStats get _aggregateStats {
    int completed = 0;
    int expected = 0;
    for (final Habit habit in _habits) {
      final PeriodStats stats = habit.stats(_period);
      completed += stats.completed;
      expected += stats.expected;
    }
    return PeriodStats(completed: completed, expected: expected);
  }

  void _toggleHabit(Habit habit) {
    HapticFeedback.lightImpact();
    setState(() {
      final bool completed = habit.toggleOn(DateTime.now());
      if (completed) {
        _bursts[habit.id] = (_bursts[habit.id] ?? 0) + 1;
      }
    });
    _scheduleSave();
  }

  void _toggleCollapsed(Habit habit) {
    setState(() => habit.daysCollapsed = !habit.daysCollapsed);
    _scheduleSave();
  }

  void _selectCategory(int index) {
    if (index == _selectedCategory) {
      return;
    }
    setState(() {
      _selectedCategory = index;
      _showAll = false;
    });
    _scheduleSave();
  }

  void _selectPeriod(Period period) {
    if (period == _period) {
      return;
    }
    setState(() => _period = period);
    _scheduleSave();
  }

  void _toggleShowAll() {
    setState(() => _showAll = !_showAll);
  }

  Future<void> _openNewHabitSheet() async {
    final HabitDraft? draft = await showModalBottomSheet<HabitDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xCC000000),
      builder: (_) => const NewHabitSheet(),
    );

    if (!mounted || draft == null) {
      return;
    }

    setState(() {
      _habits.add(
        Habit(id: _nextId++, name: draft.name, category: draft.category),
      );
      _selectedCategory = 0;
      _showAll = false;
    });
    _scheduleSave();
  }

  void _scheduleSave() {
    if (!_loaded) {
      return;
    }
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 250), _saveNow);
  }

  void _saveNow() {
    if (!_loaded) {
      return;
    }
    unawaited(
      _repository.save(
        HabitState(
          habits: _habits,
          selectedCategory: _selectedCategory,
          period: _period,
          lastPhrase: _phrase,
        ),
      ),
    );
  }

  void _showFilterHint() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Filtros avançados em breve.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.chipSurface,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 110),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.white10),
          ),
        ),
      );
  }

  Widget _buildHabitList(List<Habit> visible, bool showEmpty) {
    final List<Widget> children = <Widget>[];

    if (showEmpty) {
      children.add(const _EmptyHabits());
    } else {
      for (int i = 0; i < visible.length; i++) {
        final Habit habit = visible[i];
        children.add(
          Padding(
            padding: EdgeInsets.only(bottom: i == visible.length - 1 ? 0 : 12),
            child: StaggeredEntry(
              index: i,
              child: HabitCard(
                habit: habit,
                period: _period,
                burstToken: _bursts[habit.id] ?? 0,
                onToggle: () => _toggleHabit(habit),
                onToggleCollapsed: () => _toggleCollapsed(habit),
              ),
            ),
          ),
        );
      }
    }

    return AnimatedSize(
      duration: context.motion(const Duration(milliseconds: 260)),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: context.motion(const Duration(milliseconds: 220)),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        layoutBuilder: (Widget? current, List<Widget> previous) => Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[...previous, if (current != null) current],
        ),
        child: Column(
          key: ValueKey<String>(
            '$_selectedCategory-$_period-$_showAll-${_habits.length}',
          ),
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Habit> filtered = _filteredHabits;
    final List<Habit> visible = _showAll
        ? filtered
        : filtered.take(3).toList();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          const Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: DotGridPainter())),
          ),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Header(
                      phrase: _phrase,
                      onNewHabit: _openNewHabitSheet,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: HeroProgressCard(
                      stats: _aggregateStats,
                      period: _period,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: PeriodSelector(
                      value: _period,
                      onChanged: _selectPeriod,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: CategoryChips(
                    selectedIndex: _selectedCategory,
                    onSelected: _selectCategory,
                    onFilterTap: _showFilterHint,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Meus hábitos',
                      expanded: _showAll,
                      canExpand: filtered.length > 3,
                      onToggle: _toggleShowAll,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: _loaded
                        ? _buildHabitList(visible, filtered.isEmpty)
                        : const SizedBox.shrink(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.paddingOf(context).bottom + 130,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHabits extends StatelessWidget {
  const _EmptyHabits();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white08),
      ),
      child: const Text(
        'Nenhum hábito nesta categoria ainda.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
      ),
    );
  }
}
