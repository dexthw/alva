import 'package:flutter/material.dart';

import 'screens/app_shell.dart';
import 'theme/app_theme.dart';

void main() => runApp(const AlvaApp());

class AlvaApp extends StatelessWidget {
  const AlvaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alva',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const AppShell(),
    );
  }
}
