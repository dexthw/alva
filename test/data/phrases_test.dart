import 'package:alva/data/phrases.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('frase do dia é a mesma dentro do mesmo dia', () {
    final DateTime morning = DateTime(2026, 11, 4, 7, 30);
    final DateTime night = DateTime(2026, 11, 4, 23, 59);

    expect(motivationPhraseFor(morning), motivationPhraseFor(night));
  });

  test('frase muda de um dia para o outro', () {
    expect(
      motivationPhraseFor(DateTime(2026, 11, 4)),
      isNot(motivationPhraseFor(DateTime(2026, 11, 5))),
    );
  });

  test('frase sempre vem do banco de frases', () {
    expect(
      motivationPhrases,
      contains(motivationPhraseFor(DateTime(2026, 11, 4))),
    );
  });
}
