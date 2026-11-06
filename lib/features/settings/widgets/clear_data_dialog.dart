import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Pergunta se o usuário realmente quer apagar tudo. Não apaga sozinho:
/// retorna `true` apenas quando a ação destrutiva é confirmada.
Future<bool> showClearDataDialog(
  BuildContext context, {
  required int habitCount,
}) async {
  final bool? result = await showDialog<bool>(
    context: context,
    barrierColor: const Color(0xCC000000),
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.white08),
        ),
        title: const Text(
          'Apagar todos os dados?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          habitCount > 0
              ? 'Isto remove $habitCount ${habitCount == 1 ? 'hábito' : 'hábitos'}, '
                  'todo o histórico de dias e as preferências do app. Não há como desfazer.'
              : 'Isto remove as preferências do app e a versão vista. Não há como desfazer.',
          style: const TextStyle(
            fontSize: 13.5,
            height: 1.4,
            color: AppColors.textSecondary,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
            child: const Text(
              'Apagar tudo',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
