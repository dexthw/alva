import 'dart:math';

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

/// Sorteia uma frase evitando repetir a última exibida.
String pickMotivationPhrase({String? last, Random? random}) {
  final Random rng = random ?? Random();
  if (motivationPhrases.length < 2) {
    return motivationPhrases.first;
  }

  int index = rng.nextInt(motivationPhrases.length);
  final int lastIndex = last == null ? -1 : motivationPhrases.indexOf(last);
  if (index == lastIndex) {
    index = (index + 1 + rng.nextInt(motivationPhrases.length - 1)) %
        motivationPhrases.length;
  }
  return motivationPhrases[index];
}
