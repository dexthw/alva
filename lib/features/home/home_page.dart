import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/animation_utils.dart';
import '../../data/models/habit.dart';
import '../../data/repositories/habit_repository.dart';
import '../../shared/widgets/dot_grid.dart';
import '../../shared/widgets/staggered_entry.dart';
import '../habits/new_habit_sheet.dart';
import '../habits/widgets/habit_card.dart';
import 'home_controller.dart';
import 'widgets/category_chips.dart';
import 'widgets/header.dart';
import 'widgets/hero_progress_card.dart';
import 'widgets/period_selector.dart';
import 'widgets/section_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();

  @override
  void initState() {
    super.initState();
    unawaited(_controller.load());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleHabit(Habit habit) {
    HapticFeedback.lightImpact();
    _controller.toggleHabit(habit);
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

    _controller.addHabit(name: draft.name, category: draft.category);
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

  String get _emptyMessage => _controller.totalHabits == 0
      ? 'Nenhum hábito ainda.\nToque em "Novo" para criar o primeiro.'
      : 'Nenhum hábito nesta categoria ainda.';

  Widget _buildHabitList(List<Habit> visible, bool showEmpty) {
    final List<Widget> children = <Widget>[];

    if (showEmpty) {
      children.add(_EmptyHabits(message: _emptyMessage));
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
                period: _controller.period,
                burstToken: _controller.burstFor(habit.id),
                onToggle: () => _toggleHabit(habit),
                onToggleCollapsed: () => _controller.toggleCollapsed(habit),
              ),
            ),
          ),
        );
      }
    }

    return AnimatedSize(
      duration: context.motion(AppDurations.listTransition),
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
            '${_controller.selectedCategory}-${_controller.period}-'
            '${_controller.showAll}-${_controller.habits.length}',
          ),
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (BuildContext context, Widget? child) {
        final List<Habit> filtered = _controller.filteredHabits;
        final List<Habit> visible = _controller.visibleHabits;

        return Scaffold(
          body: Stack(
            children: <Widget>[
              const Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: DotGridPainter()),
                ),
              ),
              SafeArea(
                bottom: false,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.page,
                        AppSpacing.xl,
                        AppSpacing.page,
                        0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Header(
                          phrase: _controller.phrase,
                          onNewHabit: _openNewHabitSheet,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.page,
                        AppSpacing.xl,
                        AppSpacing.page,
                        0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: HeroProgressCard(stats: _controller.todayStats),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.page,
                        AppSpacing.xxl,
                        AppSpacing.page,
                        0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: PeriodSelector(
                          value: _controller.period,
                          onChanged: _controller.selectPeriod,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    SliverToBoxAdapter(
                      child: CategoryChips(
                        selectedIndex: _controller.selectedCategory,
                        onSelected: _controller.selectCategory,
                        onFilterTap: _showFilterHint,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.page,
                        AppSpacing.xxl,
                        AppSpacing.page,
                        0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: SectionHeader(
                          title: 'Meus hábitos',
                          expanded: _controller.showAll,
                          canExpand:
                              filtered.length > AppSizes.visibleHabits,
                          onToggle: _controller.toggleShowAll,
                        ),
                      ),
                    ),
                    if (_controller.status == HabitStorageStatus.corrupted)
                      const SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.page,
                          12,
                          AppSpacing.page,
                          0,
                        ),
                        sliver: SliverToBoxAdapter(child: _StorageWarning()),
                      ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.page,
                        12,
                        AppSpacing.page,
                        0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _controller.loaded
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
      },
    );
  }
}

class _EmptyHabits extends StatelessWidget {
  const _EmptyHabits({required this.message});

  final String message;

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
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
      ),
    );
  }
}

class _StorageWarning extends StatelessWidget {
  const _StorageWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.greenBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white08),
      ),
      child: const Text(
        'Não foi possível ler os hábitos salvos. Você pode começar um novo hábito normalmente.',
        style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
      ),
    );
  }
}
