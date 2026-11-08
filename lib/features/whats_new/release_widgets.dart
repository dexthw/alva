import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Bloco de uma categoria de mudanças (Novidades, Melhorias, Correções).
///
/// O marcador de cada item é desenhado pelo app: não depende de glifo nem da
/// fonte de emoji do sistema, que pintava o caractere "•" de amarelo.
class ReleaseBlock extends StatelessWidget {
  const ReleaseBlock({
    super.key,
    required this.icon,
    required this.title,
    required this.items,
    this.limit,
  });

  final IconData icon;
  final String title;
  final List<String> items;

  /// Quando informado, mostra só os primeiros itens e quantos ficaram de fora.
  final int? limit;

  @override
  Widget build(BuildContext context) {
    final int shown =
        limit == null || items.length <= limit! ? items.length : limit!;
    final int rest = items.length - shown;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white06.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.white06),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.white08,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 15, color: AppColors.textTertiary),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              Text(
                '${items.length}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < shown; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 8),
                    child: Container(
                      width: 3.5,
                      height: 3.5,
                      decoration: const BoxDecoration(
                        color: AppColors.textTertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      items[i],
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.3,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (rest > 0)
            Padding(
              padding: const EdgeInsets.only(left: 11, top: 1),
              child: Text(
                '+ $rest ${rest == 1 ? 'item' : 'itens'}',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
