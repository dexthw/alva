import 'package:flutter/material.dart';

/// Tokens de cor do app. Brancos com opacidade fixa evitam `withOpacity`
/// espalhado pelos widgets.
class AppColors {
  const AppColors._();

  static const Color background = Color(0xFF0A0A0B);
  static const Color heroSurface = Color(0xFF2A2C30);
  static const Color cardSurface = Color(0xFF141416);
  static const Color chipSurface = Color(0xFF1C1C1F);
  static const Color textPrimary = Color(0xFFF2F2F4);
  static const Color textSecondary = Color(0xFF8E8E96);
  static const Color textTertiary = Color(0xFFA3A3AB);
  static const Color accent = Color(0xFFFFFFFF);
  static const Color greenBackground = Color(0xFF12301D);
  static const Color greenSurface = Color(0xFF1A4A2B);
  static const Color greenText = Color(0xFF4ADE80);
  static const Color flame = Color(0xFFFF8A3D);
  static const Color flameDim = Color(0xFF57575E);

  // Branco com opacidade fixa: 6%, 8%, 10%, 12%, 15%, 20%, 25%.
  static const Color white06 = Color(0x0FFFFFFF);
  static const Color white08 = Color(0x14FFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white12 = Color(0x1FFFFFFF);
  static const Color white15 = Color(0x26FFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white25 = Color(0x40FFFFFF);
  static const Color white40 = Color(0x66FFFFFF);

  // Anel de progresso: arco contínuo em vidro, com brilho pulsante.
  static const Color ringArcMint = Color(0xFFCFEAE6);
  static const Color ringArcLavender = Color(0xFFD8CFF5);
  static const Color ringArcViolet = Color(0xFFB9B0E6);
  static const Color ringArcSlate = Color(0xFF8E9CC8);
  static const Color ringTrack = Color(0xFF7C8291);
  static const Color ringCapLight = Color(0xFFFFF4F8);
  static const Color ringCapRose = Color(0xFFF0A8C5);
  static const Color ringCapHalo = Color(0xFFF2A9C6);
}
