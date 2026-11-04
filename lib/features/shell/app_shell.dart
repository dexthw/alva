import 'package:flutter/material.dart';

import '../../shared/widgets/glass_dock.dart';
import '../home/home_page.dart';
import '../settings/settings_page.dart';

/// Casca do app: mantém a Home viva e alterna com a aba de Ajustes.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          IndexedStack(
            index: _index,
            children: const <Widget>[HomePage(), SettingsPage()],
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
