import 'package:flutter/material.dart';

import '../../core/app_info.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/animation_utils.dart';
import '../../data/release_notes.dart';
import 'release_widgets.dart';

/// Histórico completo de versões, aberto pelo item "Atualizações" em Ajustes.
///
/// A versão instalada aparece aberta e as anteriores ficam recolhidas, abrindo
/// sob demanda. A tela automática "O que há de novo" não lista o histórico.
class UpdatesPage extends StatefulWidget {
  const UpdatesPage({super.key, this.versions, this.currentVersion});

  final List<ReleaseNote>? versions;
  final String? currentVersion;

  @override
  State<UpdatesPage> createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  late final List<ReleaseNote> _versions = widget.versions ?? releaseHistory;
  late final String _current = widget.currentVersion ?? AppInfo.version;
  late final Set<String> _open = <String>{_current};

  void _toggle(String version, {required bool installed}) {
    if (installed) {
      return;
    }
    setState(() {
      if (!_open.remove(version)) {
        _open.add(version);
      }
    });
  }

  List<Widget> _blocks(ReleaseNote note) {
    final List<Widget> blocks = <Widget>[];

    void add(String title, IconData icon, List<String> items) {
      if (items.isEmpty) {
        return;
      }
      if (blocks.isNotEmpty) {
        blocks.add(const SizedBox(height: 10));
      }
      blocks.add(ReleaseBlock(icon: icon, title: title, items: items));
    }

    add('Novidades', Icons.star_outline_rounded, note.news);
    add('Melhorias', Icons.trending_up_rounded, note.improvements);
    add('Correções', Icons.build_outlined, note.fixes);
    return blocks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 20, 0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon:
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    color: AppColors.textSecondary,
                    tooltip: 'Voltar para Ajustes',
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(
                'Atualizações',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 6, 20, 18),
              child: Text(
                'Todas as versões do app.',
                style:
                    TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                itemCount: _versions.length,
                itemBuilder: (BuildContext context, int index) {
                  final ReleaseNote note = _versions[index];
                  final bool installed = note.version == _current;
                  final bool open = _open.contains(note.version);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _VersionCard(
                      note: note,
                      installed: installed,
                      open: open,
                      blocks: _blocks(note),
                      onTap: () => _toggle(note.version, installed: installed),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VersionCard extends StatelessWidget {
  const _VersionCard({
    required this.note,
    required this.installed,
    required this.open,
    required this.blocks,
    required this.onTap,
  });

  final ReleaseNote note;
  final bool installed;
  final bool open;
  final List<Widget> blocks;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: installed ? AppColors.white12 : AppColors.white08,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Semantics(
            button: true,
            expanded: open,
            label: 'Versão ${note.version}',
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Versão ${note.version}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (installed) ...<Widget>[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white06,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: AppColors.white10),
                                ),
                                child: const Text(
                                  'instalada',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${note.date}  ·  ${note.total} mudanças',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!installed)
                    AnimatedRotation(
                      turns: open ? 0.5 : 0,
                      duration: context.motion(
                        const Duration(milliseconds: 220),
                      ),
                      curve: Curves.easeOutCubic,
                      child: const Icon(
                        Icons.expand_more_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // O conteúdo só entra na árvore quando a versão está aberta, para não
          // deixar texto escondido para leitores de tela.
          AnimatedSize(
            duration: context.motion(const Duration(milliseconds: 260)),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: open
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(children: blocks),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
