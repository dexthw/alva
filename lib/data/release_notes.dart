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

  int get total => news.length + improvements.length + fixes.length;
}

/// Histórico do app, da versão mais recente para a mais antiga.
///
/// A tela de novidades mostra a primeira expandida e todas as outras
/// recolhidas, com o mesmo texto do README e das notas do release.
const List<ReleaseNote> releaseHistory = <ReleaseNote>[
  ReleaseNote(
    version: '1.2.0',
    date: '7 de novembro de 2026',
    news: <String>[
      'Tela de novidades com a lista completa',
      'Histórico das versões anteriores',
    ],
    improvements: <String>[
      'Gradiente de rolagem no card',
    ],
    fixes: <String>[],
  ),
  ReleaseNote(
    version: '1.1.0',
    date: '5 de novembro de 2026',
    news: <String>[
      'Tela "O que há de novo" a cada versão',
      'Apagar todos os dados em Ajustes',
      'Feedback pelo formulário do repositório',
      'Fonte Inter funciona offline',
      'Recolher todos os cards de uma vez',
      'Frase do dia igual durante todo o dia',
    ],
    improvements: <String>[
      'Anel circular com brilho pulsante',
      'Dock arrastável sem borda dupla',
      'Lente do dock cresce ao arrastar',
      'Rótulos do dock somem ao rolar',
      'Cards esmaecem ao sair pelo topo',
      'Seletor sem divisórias verticais',
      'Dias recolhem com escalonamento',
      'Lista completa de hábitos',
      'Cabeçalho com "Hoje" e a data',
      'Contraste AA nos textos de apagar',
    ],
    fixes: <String>[
      'Marcadores amarelos nas listas de novidades',
      'Brilho da chama ao concluir o hábito',
      'Hábitos fictícios na primeira instalação',
      'Progresso contando dias anteriores',
      'Cards estourando com fonte 1.3',
    ],
  ),
  ReleaseNote(
    version: '1.0.2',
    date: '3 de novembro de 2026',
    news: <String>[
      'Persistência local dos hábitos',
      'Aba Ajustes com envio de feedback',
      '34 frases motivacionais',
      'Modos Mês e Ano por hábito',
      '"Ver todos" na Home',
      'Animações de entrada e contagem',
      'Ícone adaptativo',
    ],
    improvements: <String>[
      'Anel em vidro fosco facetado',
      'Card de progresso menor',
      'Cards de hábito 13% menores',
      'Percentual pelo período selecionado',
      'Transições no seletor e nos filtros',
      'Código dividido em módulos',
      'Sem o wordmark "Alva"',
    ],
    fixes: <String>[
      'Anel sem traços cortados',
      'Porcentagem limitada a 100%',
      'Chip verde ao concluir o último dia',
      'Datas corretas com fuso/DST',
    ],
  ),
  ReleaseNote(
    version: '1.0.0',
    date: '2 de novembro de 2026',
    news: <String>[
      'Home com tema escuro, anel, filtros e dock',
    ],
    improvements: <String>[],
    fixes: <String>[],
  ),
];

/// Versão atual do app. Mantenha aqui ao subir o `pubspec.yaml`.
final ReleaseNote currentRelease = releaseHistory.first;

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
