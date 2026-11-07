import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Título da seção de hábitos, sem controle de expandir/recolher.
///
/// A lista mostra todos os hábitos do filtro; quem recolhe os cards é o
/// controle global do cabeçalho.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      ),
    );
  }
}
