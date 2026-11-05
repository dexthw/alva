import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/animation_utils.dart';
import '../../../core/utils/date_labels.dart';

/// Cabeçalho da Home: "Hoje" com a data logo abaixo, frase do dia e as ações
/// de recolher todos os cards e criar um hábito.
class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.phrase,
    required this.onNewHabit,
    required this.cardsCollapsed,
    required this.onToggleCards,
  });

  final String phrase;
  final VoidCallback onNewHabit;
  final bool cardsCollapsed;
  final VoidCallback onToggleCards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                'Hoje',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.4,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
            ),
            CollapseAllButton(
              collapsed: cardsCollapsed,
              onPressed: onToggleCards,
            ),
            const SizedBox(width: 8),
            NewHabitButton(onPressed: onNewHabit),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          formatHeaderDate(DateTime.now()),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: context.motion(const Duration(milliseconds: 320)),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: Text(
            phrase,
            key: ValueKey<String>(phrase),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

/// Recolhe ou expande a área de dias de todos os cards de uma vez.
class CollapseAllButton extends StatelessWidget {
  const CollapseAllButton({
    super.key,
    required this.collapsed,
    required this.onPressed,
  });

  final bool collapsed;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label:
          collapsed ? 'Expandir todos os hábitos' : 'Recolher todos os hábitos',
      child: Material(
        color: AppColors.white06,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 40,
            height: 40,
            child: AnimatedSwitcher(
              duration: context.motion(const Duration(milliseconds: 180)),
              child: Icon(
                collapsed
                    ? Icons.unfold_more_rounded
                    : Icons.unfold_less_rounded,
                key: ValueKey<bool>(collapsed),
                size: 19,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewHabitButton extends StatelessWidget {
  const NewHabitButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Novo hábito',
      child: Material(
        color: AppColors.accent,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: const SizedBox(
            height: 40,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.add, size: 17, color: AppColors.background),
                  SizedBox(width: 5),
                  Text(
                    'Novo',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.background,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
