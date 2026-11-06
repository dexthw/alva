import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_info.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/dot_grid.dart';
import 'widgets/clear_data_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.habitCount,
    required this.onClearData,
  });

  final int habitCount;
  final Future<void> Function() onClearData;

  Future<void> _openFeedback(BuildContext context) async {
    bool opened = false;
    try {
      opened = await launchUrl(
        AppInfo.feedbackUrl,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      opened = false;
    }

    if (!opened && context.mounted) {
      _snack(context, 'Não foi possível abrir o navegador.');
    }
  }

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
      _snack(context, 'Dados apagados.');
    }
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: DotGridPainter())),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Ajustes',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                      color: AppColors.textPrimary,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Preferências do app.',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _SettingsTile(
                    icon: Icons.chat_bubble_outline,
                    title: 'Enviar feedback',
                    subtitle: 'Abre o formulário de issues no navegador',
                    trailing: Icons.open_in_new,
                    onTap: () => _openFeedback(context),
                  ),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    icon: Icons.delete_outline_rounded,
                    title: 'Apagar todos os dados',
                    subtitle: habitCount > 0
                        ? 'Remove $habitCount ${habitCount == 1 ? 'hábito' : 'hábitos'} e todo o histórico'
                        : 'Remove preferências e histórico',
                    trailing: Icons.chevron_right_rounded,
                    destructive: true,
                    onTap: () => _clearData(context),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Versão ${AppInfo.version}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final IconData trailing;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final Color accentColor =
        destructive ? AppColors.danger : AppColors.textPrimary;

    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.white08),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: destructive
                        ? AppColors.danger.withValues(alpha: 0.12)
                        : AppColors.white08,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: destructive ? AppColors.danger : accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: destructive
                              ? AppColors.danger
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.3,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(trailing, size: 16, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
