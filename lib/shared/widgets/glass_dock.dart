import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../core/animation_utils.dart';
import '../../theme/app_colors.dart';

class GlassDock extends StatelessWidget {
  const GlassDock({super.key, required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 220),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 66,
                decoration: BoxDecoration(
                  color: AppColors.white08,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.white12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _DockItem(
                      label: 'Hoje',
                      icon: index == 0 ? Icons.home : Icons.home_outlined,
                      selected: index == 0,
                      onTap: () => onSelect(0),
                    ),
                    _DockItem(
                      label: 'Ajustes',
                      icon: index == 1 ? Icons.settings : Icons.settings_outlined,
                      selected: index == 1,
                      onTap: () => onSelect(1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: 84,
          height: 66,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedScale(
                scale: selected ? 1.05 : 1,
                duration: context.motion(const Duration(milliseconds: 200)),
                child: Icon(
                  icon,
                  size: 23,
                  color: selected
                      ? AppColors.accent
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: context.motion(const Duration(milliseconds: 200)),
                width: selected ? 4 : 0,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
