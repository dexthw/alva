/// Conteúdo de uma versão exibido na tela "O que há de novo".
class ReleaseNote {
  const ReleaseNote({
    required this.version,
    required this.date,
    required this.news,
    required this.improvements,
    required this.fixes,
  });

  final String version;
  final String date;
  final List<String> news;
  final List<String> improvements;
  final List<String> fixes;
}

/// Versão atual do app. Mantenha aqui ao subir o `pubspec.yaml`.
const ReleaseNote currentRelease = ReleaseNote(
  version: '1.1.0',
  date: '5 de novembro de 2026',
  news: <String>[
    'Dock com lente de vidro arrastável',
    'Tela "O que há de novo" a cada versão',
  ],
  improvements: <String>[
    'Anel de progresso com brilho pulsante',
    'Cabeçalho com "Hoje" e a data juntos',
  ],
  fixes: <String>[
    'Hábitos que não existiam',
    'Progresso contando dias anteriores',
  ],
);

/// Decide se a tela de novidades deve abrir.
///
/// - Mesma versão já vista: não abre.
/// - Primeira instalação (sem versão vista e sem hábitos): não abre.
/// - Atualização de uma instalação com dados: abre.
bool shouldShowWhatsNew({
  required String? seenVersion,
  required int habitCount,
  required String currentVersion,
}) {
  if (seenVersion == currentVersion) {
    return false;
  }
  if (seenVersion == null && habitCount == 0) {
    return false;
  }
  return true;
}
