import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/animation_utils.dart';
import '../../data/release_notes.dart';
import 'release_widgets.dart';

const Color _cardBottom = Color(0xFF0D0D0F);

/// Card de novidades exibido uma vez a cada versão, sobre a Home desfocada.
///
/// Mostra apenas a versão instalada: número, data, blocos e o botão
/// "Continuar". O histórico completo vive na tela "Atualizações", aberta pelo
/// item de mesmo nome em Ajustes, e nenhuma ação destrutiva aparece aqui.
class WhatsNewDialog extends StatefulWidget {
  const WhatsNewDialog({
    super.key,
    required this.note,
    required this.onContinue,
  });

  final ReleaseNote note;
  final VoidCallback onContinue;

  @override
  State<WhatsNewDialog> createState() => _WhatsNewDialogState();
}

class _WhatsNewDialogState extends State<WhatsNewDialog> {
  bool _expanded = false;

  void _continue() {
    widget.onContinue();
    Navigator.of(context).pop();
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
        ReleaseBlock(icon: icon, title: title, items: items, limit: limit),
      );
    }

    add('Novidades', Icons.star_outline_rounded, note.news);
    add('Melhorias', Icons.trending_up_rounded, note.improvements);
    add('Correções', Icons.build_outlined, note.fixes);
    return blocks;
  }

  @override
  Widget build(BuildContext context) {
    final ReleaseNote note = widget.note;

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
                            duration: context.motion(
                              const Duration(milliseconds: 300),
                            ),
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
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Material(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Rolagem do conteúdo com um gradiente no rodapé enquanto houver mais texto.
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
