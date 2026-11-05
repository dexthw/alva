/// Banco de frases curtas em pt-BR.
const List<String> motivationPhrases = <String>[
  'Um passo por vez já é progresso.',
  'A constância vence o talento.',
  'Comece pequeno, siga firme.',
  'Hoje conta.',
  'Disciplina é liberdade.',
  'Feito é melhor que perfeito.',
  'Seu futuro agradece o esforço de hoje.',
  'Não quebre a corrente.',
  'A rotina constrói o resultado.',
  'Foco no próximo passo.',
  'Pouco, todos os dias.',
  'Você está mais perto do que ontem.',
  'Hábitos vencem a motivação.',
  'Repita até virar natural.',
  'Progresso não é perfeição.',
  'Um dia de cada vez.',
  'O simples, feito sempre, muda tudo.',
  'Cuide do básico bem-feito.',
  'Sua sequência é seu compromisso.',
  'Volte sempre ao caminho.',
  'Devagar também é avançar.',
  'Faça o que importa primeiro.',
  'A soma dos pequenos gestos.',
  'Sem pressa, sem pausa.',
  'Marque hoje e siga.',
  'Você está construindo algo.',
  'O esforço de hoje é o hábito de amanhã.',
  'Comece antes de estar pronto.',
  'Consistência abre portas.',
  'Um check de cada vez.',
  'Escolha o difícil agora.',
  'O melhor dia para começar é hoje.',
  'Firmeza vale mais que intensidade.',
  'Pequenas vitórias, grandes mudanças.',
];

/// Frase do dia: a mesma durante todo o dia e outra no dia seguinte.
///
/// A escolha depende só da data, então reabrir o app não troca a frase.
String motivationPhraseFor(DateTime date) {
  final int seed = date.year * 10000 + date.month * 100 + date.day;
  return motivationPhrases[seed % motivationPhrases.length];
}
