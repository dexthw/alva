import 'package:flutter/material.dart';

import '../../../core/utils/animation_utils.dart';
import '../../../data/models/habit.dart';
import '../../../core/theme/app_colors.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.onFilterTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
        itemCount: habitCategories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int index) {
          if (index == habitCategories.length) {
            return Semantics(
              label: 'Filtros',
              button: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onFilterTap,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white15),
                  ),
                  child: const Icon(
                    Icons.tune,
                    size: 17,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }

          final bool selected = index == selectedIndex;
          return Semantics(
            button: true,
            selected: selected,
            label: habitCategories[index],
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: context.motion(const Duration(milliseconds: 200)),
                curve: Curves.easeOut,
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: selected ? AppColors.accent : AppColors.white15,
                  ),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: context.motion(const Duration(milliseconds: 200)),
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: selected
                        ? AppColors.background
                        : AppColors.textPrimary,
                  ),
                  child: Text(habitCategories[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
