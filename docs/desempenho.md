# Roteiro de desempenho em aparelho real

Este roteiro mede as animações da 1.1.0 em um Android real. **Nada aqui foi
medido ainda**: a validação até agora é de testes de widget e de estrutura
(rebuild restrito), não de frames reais.

## Preparação

1. Conecte o celular com depuração USB ativada e confirme com `flutter devices`.
2. Rode em modo de perfil (obrigatório — em debug as medições não valem):

   ```bash
   flutter run --profile
   ```

3. Com o app aberto, pressione **`P`** no terminal do `flutter run` para ativar
   o **Performance Overlay** (as duas barras no topo: UI e Raster).
4. Feche apps pesados em segundo plano e, se possível, ative o modo avião.

## O que medir

Para cada cenário, observe as barras por ~10 segundos:

| # | Cenário | Como reproduzir | O que observar |
|---|---|---|---|
| 1 | Rolagem com fade | Role a Home para baixo e para cima, passando pelos cards e blocos | Barras dentro de 16 ms; o fade acompanha o dedo, sem atraso |
| 2 | Dock — rótulos | Role para baixo até os rótulos sumirem e suba até voltarem | Transição suave; sem piscar ou "pular" |
| 3 | Dock — vidro líquido | Segure e arraste a lente entre Hoje e Ajustes 10 vezes | Lente cresce com halo, encaixa com mola, sem engasgo |
| 4 | Recolher/expandir dias | Toque no botão de recolher todos e expanda 10 vezes | Stagger visível (dias em sequência), ~400 ms, sem travar |

## Como registrar

1. Anote o aparelho, a versão do Android e a versão do app (Ajustes → rodapé).
2. Para cada cenário, classifique:
   - **OK** — barras verdes, sem picos acima de 16 ms.
   - **Atenção** — picos isolados entre 16 e 32 ms.
   - **Problema** — picos acima de 32 ms ou queda visível de frames.
3. Se possível, grave a tela durante a rolagem e o arrasto do dock.
4. Envie o resultado (aparelho + classificação por cenário).

## Critério de aceite

- Nenhum cenário classificado como **Problema**.
- Cenários 1 e 4 sem **Atenção** em aparelhos de 2022 ou mais novos.
- Se houver **Problema**, o ajuste precisa ser medido de novo antes de declarar
  a animação aprovada.
