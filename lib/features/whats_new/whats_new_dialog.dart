import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/release_notes.dart';
import '../settings/widgets/clear_data_dialog.dart';

/// Card de novidades exibido uma vez a cada versão, sobre a Home desfocada.
class WhatsNewDialog extends StatelessWidget {
  const WhatsNewDialog({
    super.key,
    required this.note,
    required this.habitCount,
    required this.onContinue,
    required this.onClearData,
  });

  final ReleaseNote note;
  final int habitCount;
  final VoidCallback onContinue;
  final Future<void> Function() onClearData;

  Future<void> _clearData(BuildContext context) async {
    final bool confirmed = await showClearDataDialog(
      context,
      habitCount: habitCount,
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    await onClearData();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _continue(BuildContext context) {
    onContinue();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.sizeOf(context).height * 0.86,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xFF18181C), Color(0xFF0D0D0F)],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.white12),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.55),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              AppColors.ringArcLavender,
                              AppColors.ringArcMint,
                            ],
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppColors.ringArcMint.withValues(
                                alpha: 0.25,
                              ),
                              blurRadius: 22,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 26,
                          color: AppColors.background,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'O que há de novo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.6,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white06,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.white10),
                        ),
                        child: Text(
                          'v${note.version}  ·  ${note.date}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: <Widget>[
                        _ReleaseBlock(
                          icon: Icons.star_outline_rounded,
                          title: 'Novidades',
                          items: note.news,
                        ),
                        const SizedBox(height: 14),
                        _ReleaseBlock(
                          icon: Icons.trending_up_rounded,
                          title: 'Melhorias',
                          items: note.improvements,
                        ),
                        const SizedBox(height: 14),
                        _ReleaseBlock(
                          icon: Icons.build_outlined,
                          title: 'Bugs corrigidos',
                          items: note.fixes,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
                  child: Column(
                    children: <Widget>[
                      TextButton(
                        onPressed: () => _clearData(context),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          minimumSize: const Size(0, 36),
                        ),
                        child: const Text(
                          'Apagar todos os dados',
                          style: TextStyle(fontSize: 12.5),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Material(
                        color: AppColors.accent,
                        shape: const StadiumBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => _continue(context),
                          child: const SizedBox(
                            height: 52,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Continuar',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.background,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReleaseBlock extends StatelessWidget {
  const _ReleaseBlock({
    required this.icon,
    required this.title,
    required this.items,
  });

  final IconData icon;
  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.white08,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: AppColors.textTertiary),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final String item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                '•  $item',
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
