import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/animation_utils.dart';
import '../../data/release_notes.dart';
import '../settings/widgets/clear_data_dialog.dart';

const Color _cardBottom = Color(0xFF0D0D0F);

/// Card de novidades exibido uma vez a cada versão, sobre a Home desfocada.
///
/// A versão atual aparece no topo, resumida em dois itens por categoria. O
/// botão "Ver todas" expande a lista com animação e o rodapé ganha um gradiente
/// enquanto houver conteúdo para rolar. As versões anteriores ficam recolhidas
/// logo abaixo e abrem sob demanda.
class WhatsNewDialog extends StatefulWidget {
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

  @override
  State<WhatsNewDialog> createState() => _WhatsNewDialogState();
}

class _WhatsNewDialogState extends State<WhatsNewDialog> {
  bool _expanded = false;
  final Set<String> _openVersions = <String>{};

  Future<void> _clearData() async {
    final bool confirmed = await showClearDataDialog(
      context,
      habitCount: widget.habitCount,
    );
    if (!confirmed || !mounted) {
      return;
    }
    await widget.onClearData();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _continue() {
    widget.onContinue();
    Navigator.of(context).pop();
  }

  void _toggleVersion(String version) {
    setState(() {
      if (!_openVersions.remove(version)) {
        _openVersions.add(version);
      }
    });
  }

  List<Widget> _blocks(ReleaseNote note, {int? limit}) {
    final List<Widget> blocks = <Widget>[];

    void add(String title, IconData icon, List<String> items) {
      if (items.isEmpty) {
        return;
      }
      if (blocks.isNotEmpty) {
        blocks.add(const SizedBox(height: 10));
      }
      blocks.add(
        _ReleaseBlock(icon: icon, title: title, items: items, limit: limit),
      );
    }

    add('Novidades', Icons.star_outline_rounded, note.news);
    add('Melhorias', Icons.trending_up_rounded, note.improvements);
    add('Bugs corrigidos', Icons.build_outlined, note.fixes);
    return blocks;
  }

  @override
  Widget build(BuildContext context) {
    final ReleaseNote note = widget.note;
    final List<ReleaseNote> older = releaseHistory
        .where((ReleaseNote item) => item.version != note.version)
        .toList();

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.sizeOf(context).height * 0.9,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xFF18181C), _cardBottom],
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
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 52,
                        height: 52,
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
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 24,
                          color: AppColors.background,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'O que há de novo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 4,
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
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                Flexible(
                  child: _FadeScroll(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Versão ${note.version}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                '${note.total} mudanças',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          AnimatedSize(
                            duration: context
                                .motion(const Duration(milliseconds: 300)),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: _blocks(
                                note,
                                limit: _expanded ? null : 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () =>
                                setState(() => _expanded = !_expanded),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(color: AppColors.white15),
                              shape: const StadiumBorder(),
                              minimumSize: const Size(0, 42),
                            ),
                            child: Text(
                              _expanded
                                  ? 'Ver menos'
                                  : 'Ver todas as ${note.total} mudanças',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          if (older.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 18),
                            const Text(
                              'VERSÕES ANTERIORES',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textTertiary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (final ReleaseNote old in older)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _VersionTile(
                                  note: old,
                                  open: _openVersions.contains(old.version),
                                  onTap: () => _toggleVersion(old.version),
                                  blocks: _blocks(old),
                                ),
                              ),
                          ],
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 16),
                  child: Column(
                    children: <Widget>[
                      TextButton(
                        onPressed: _clearData,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          minimumSize: const Size(0, 32),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Apagar todos os dados',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Material(
                        color: AppColors.accent,
                        shape: const StadiumBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: _continue,
                          child: const SizedBox(
                            height: 48,
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

/// Rolagem do conteúdo com um gradiente no rodapé enquanto houver mais texto,
/// como na alternativa C.
class _FadeScroll extends StatefulWidget {
  const _FadeScroll({required this.child});

  final Widget child;

  @override
  State<_FadeScroll> createState() => _FadeScrollState();
}

class _FadeScrollState extends State<_FadeScroll> {
  final ScrollController _controller = ScrollController();
  bool _hasMore = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_update);
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  @override
  void didUpdateWidget(covariant _FadeScroll oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  void _update() {
    if (!mounted || !_controller.hasClients) {
      return;
    }
    final ScrollPosition position = _controller.position;
    final bool more = position.pixels < position.maxScrollExtent - 4;
    if (more != _hasMore) {
      setState(() => _hasMore = more);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          controller: _controller,
          padding: const EdgeInsets.only(bottom: 14),
          child: widget.child,
        ),
        if (_hasMore)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                height: 64,
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 6),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0x000D0D0F), _cardBottom],
                  ),
                ),
                child: const Text(
                  'Role para ver tudo',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _VersionTile extends StatelessWidget {
  const _VersionTile({
    required this.note,
    required this.open,
    required this.onTap,
    required this.blocks,
  });

  final ReleaseNote note;
  final bool open;
  final VoidCallback onTap;
  final List<Widget> blocks;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.white08),
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
                        Text(
                          'Versão ${note.version}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
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
                  AnimatedRotation(
                    turns: open ? 0.5 : 0,
                    duration: context.motion(const Duration(milliseconds: 220)),
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
          // O conteúdo só entra na árvore quando a versão está aberta, para
          // não deixar texto escondido para leitores de tela.
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

class _ReleaseBlock extends StatelessWidget {
  const _ReleaseBlock({
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
                  // Marcador desenhado: não depende de glifo nem de fonte de
                  // emoji do sistema.
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
