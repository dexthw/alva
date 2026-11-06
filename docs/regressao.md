# Checklist de regressão — 1.1.0

Roteiro para o tester validar antes de promover `tester` → `production`.
Marque cada item no aparelho, em modo claro/escuro do sistema e com escala de
texto padrão; os itens de acessibilidade têm configuração própria.

## 1. Primeira instalação

- [ ] Desinstalar o app antes (isso apaga os dados) e instalar o APK novo.
- [ ] A Home abre **sem hábitos**, com a mensagem para criar o primeiro.
- [ ] O anel mostra `0%` e `0/0`.
- [ ] A tela "O que há de novo" **não** aparece na primeira abertura.

## 2. Criar, concluir e editar hábitos

- [ ] Criar um hábito com nome e categoria; ele aparece na lista.
- [ ] Criar mais dois hábitos; a lista mostra os três, sem "Ver todos".
- [ ] Concluir um hábito: o check fica preenchido, a chama acende na hora e o anel sobe.
- [ ] Desmarcar o hábito: o anel volta e a sequência recalcula.
- [ ] Fechar e reabrir o app: hábitos, checks e ordem continuam.

## 3. Progresso e períodos

- [ ] O anel e `X/Y` refletem **apenas hoje**.
- [ ] Trocar Semana/Mês/Ano não muda o anel nem a contagem.
- [ ] Semana mostra os 7 dias; Mês, a grade do mês; Ano, os 12 meses.
- [ ] O card recolhido/expandido respeita o botão global ao lado de "Novo".
- [ ] Fechar e reabrir mantém o estado de recolhimento.

## 4. Cabeçalho e frase

- [ ] Título "Hoje" com a data por extenso logo abaixo.
- [ ] A frase do dia é a mesma ao fechar e reabrir o app.
- [ ] No dia seguinte (ou mudando a data do aparelho), a frase muda.

## 5. Dock e navegação

- [ ] O dock tem lente de vidro sobre a aba ativa, sem borda externa marcada.
- [ ] Arrastar o dock move a lente e, ao soltar, ela encaixa na aba mais próxima.
- [ ] Arrastar a Home (lista) **não** move a lente.
- [ ] Tocar em "Hoje"/"Ajustes" troca de aba.
- [ ] A lente anima suave, sem corte seco.

## 6. Ajustes

- [ ] "Enviar feedback" abre o navegador no formulário de issues; sem navegador, aparece o aviso.
- [ ] "Apagar todos os dados" mostra o diálogo com a quantidade de hábitos.
- [ ] Cancelar não apaga nada.
- [ ] Confirmar apaga tudo: a Home volta vazia (`0/0`, `0%`), sem hábitos de exemplo.
- [ ] A versão aparece no rodapé de Ajustes.

## 7. O que há de novo

- [ ] Atualizar por cima de uma instalação **com hábitos** mostra a tela uma vez.
- [ ] "Continuar" fecha e não reaparece na próxima abertura.
- [ ] "Apagar todos os dados" dentro da tela também funciona.
- [ ] Instalação nova não mostra a tela.

## 8. Acessibilidade e casos extremos

- [ ] Escala de texto 1.3 em tela de 360dp: nada cortado ou sobreposto.
- [ ] TalkBack anuncia check, chips, dock e botões.
- [ ] Modo avião: a tipografia continua a mesma (Inter empacotada).
- [ ] Rotação/voltar do sistema não quebra o estado.
- [ ] Com muitos hábitos (10+), a lista rola sem travar.

## 9. Build

- [ ] `flutter analyze` sem avisos.
- [ ] `dart format --language-version=3.5 --output=none --set-exit-if-changed lib test` sem mudanças.
- [ ] `flutter test` verde.
- [ ] `flutter build apk --release` conclui e o APK instala por cima da versão anterior.
