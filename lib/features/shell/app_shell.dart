import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../core/app_info.dart';
import '../../data/release_notes.dart';
import '../../data/repositories/release_repository.dart';
import '../../shared/widgets/glass_dock.dart';
import '../home/home_controller.dart';
import '../home/home_page.dart';
import '../settings/settings_page.dart';
import '../whats_new/whats_new_dialog.dart';

/// Casca do app: mantém a Home viva, alterna as abas e abre as novidades.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final HomeController _home = HomeController();
  final ReleaseRepository _releases = ReleaseRepository();

  /// Rótulos do dock: somem ao descer e voltam ao subir.
  bool _dockLabels = true;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  @override
  void dispose() {
    _home.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    await _home.load();
    if (!mounted) {
      return;
    }

    final String? seen = await _releases.seenVersion();
    if (!mounted) {
      return;
    }

    final bool show = shouldShowWhatsNew(
      seenVersion: seen,
      habitCount: _home.totalHabits,
      currentVersion: AppInfo.version,
    );

    if (!show) {
      if (seen != AppInfo.version) {
        await _releases.markSeen(AppInfo.version);
      }
      return;
    }

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Novidades',
      barrierColor: const Color(0x99000000),
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (BuildContext context, _, __) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: WhatsNewDialog(
            note: currentRelease,
            habitCount: _home.totalHabits,
            onContinue: () => unawaited(_releases.markSeen(AppInfo.version)),
            onClearData: _clearData,
          ),
        );
      },
      transitionBuilder:
          (BuildContext context, Animation<double> animation, _, Widget child) {
        final CurvedAnimation curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curve,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(curve),
            child: child,
          ),
        );
      },
    );

    await _releases.markSeen(AppInfo.version);
  }

  Future<void> _clearData() async {
    await _home.clearAll();
    await _releases.clear();
  }

  /// Só o scroll externo interessa; atualiza o estado apenas quando a
  /// visibilidade dos rótulos muda, evitando rebuild por frame.
  bool _onScroll(ScrollNotification notification) {
    if (notification.depth != 0) {
      return false;
    }
    final double pixels = notification.metrics.pixels;
    bool? visible;
    if (pixels <= 16) {
      visible = true;
    } else if (notification is ScrollUpdateNotification) {
      final double? delta = notification.scrollDelta;
      if (delta != null && delta > 0) {
        visible = false;
      } else if (delta != null && delta < 0) {
        visible = true;
      }
    }

    final bool? next = visible;
    if (next != null && next != _dockLabels) {
      setState(() => _dockLabels = next);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: ListenableBuilder(
              listenable: _home,
              builder: (BuildContext context, Widget? child) {
                return IndexedStack(
                  index: _index,
                  children: <Widget>[
                    HomePage(controller: _home),
                    SettingsPage(
                      habitCount: _home.totalHabits,
                      onClearData: _clearData,
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: 12),
              child: GlassDock(
                index: _index,
                labelsVisible: _dockLabels,
                onSelect: (int index) {
                  if (index == _index) {
                    return;
                  }
                  setState(() => _index = index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
