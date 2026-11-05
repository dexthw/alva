# Issues da versão 1.1.0

Backlog pronto para abrir no GitHub. Cada item tem título, descrição, critérios de
aceite e labels. Itens marcados **wontfix** ficam registrados como decisão, não
como tarefa.

Labels usadas: `bug`, `feature`, `ui`, `data`, `docs`, `triage`, `feedback`,
`wontfix`, `release`.

## Decisões que valem para toda a versão

| # | Decisão |
|---|---|
| D1 | O progresso (anel, contagem) é **sempre de hoje**. Semana/Mês/Ano não alimentam o anel: servem para ver **onde o usuário falhou** nos checks. |
| D2 | O centro do anel mostra a porcentagem do dia, sem categoria; o chip verde de porcentagem do card é removido. |
| D3 | Versão **1.1.0**, tag `v1.1.0`. |
| D4 | Licença **MIT**. |

---

## Bugs

### B1 — Anel de progresso fora da referência

**Labels:** `bug`, `ui`

O anel atual (`lib/widgets/progress_ring.dart`, 508 linhas) já é facetado, mas
difere da referência aprovada: elipse inclinada 30° (a referência é ~18°),
trilha azul-ardósia (a referência é vidro cinza quase transparente), cápsula rosa
curta e centro com porcentagem. O chip verde do card também mostra porcentagem.

**Critérios de aceite**

- [ ] Elipse mais sutil que a atual, com facetas de vidro e bevel fino.
- [ ] Trilha em vidro cinza translúcido, não azul.
- [ ] Cápsula rosa alongada na ponta, integrada ao arco.
- [ ] Halo de linhas concêntricas finas + régua no quadrante inferior direito.
- [ ] Centro do anel mostra a categoria ativa (ou "Hoje" no filtro Todos).
- [ ] Chip verde do card removido; a tag de categoria permanece.
- [ ] Sem corte em 112dp e nos estados 0%, 33%, 66% e 100%.
- [ ] Prévia visual aprovada antes do código (etapa 5).

### B2 — Hábitos que não existem

**Labels:** `bug`, `data`

`HabitState.defaults()` (`lib/data/habit_repository.dart:24-28`) cria "Hábito 1/2/3"
quando o storage está vazio **e** quando o JSON está corrompido. O usuário vê
hábitos que nunca criou.

**Critérios de aceite**

- [ ] Primeira instalação abre sem nenhum hábito.
- [ ] JSON corrompido não gera hábitos fictícios; mostra estado de erro/vazio.
- [ ] Migração v1→v2 remove somente os três registros de exemplo intactos.
- [ ] Teste de repositório cobrindo storage vazio, corrompido e migração.

### B3 — Filtro de período repete hábitos

**Labels:** `bug`, `data`

Não reproduz no código atual: `_filteredHabits` (`lib/features/home/home_page.dart:95-101`)
filtra uma vez e cada hábito aparece uma vez. Era sintoma do código anterior à 1.0.2.

**Critérios de aceite**

- [ ] Teste de widget com 3 hábitos e filtro por categoria garante 1 card por hábito.
- [ ] Teste com Semana, Mês e Ano garante que a quantidade de cards não muda.

### B4 — Blur da chama só aparece depois de outra ação

**Labels:** `bug`, `ui`

`StreakFlame` inicia o pulso em `didUpdateWidget` e o brilho é um `boxShadow`
(`lib/shared/widgets/streak_flame.dart`). O burst de 620 ms zera o brilho
temporariamente, o que pode parecer "sem blur" no instante da conclusão.

**Critérios de aceite**

- [ ] Ao concluir o hábito, o brilho aparece imediatamente (≤1 frame).
- [ ] O burst não apaga o brilho por completo.
- [ ] Widget test verifica o `boxShadow` presente logo após o toggle.
- [ ] `MediaQuery.disableAnimations` mantém o brilho estático.

### B5 — Concluído e anel contam dias anteriores

**Labels:** `bug`, `data`, `ui`

O check já usa `isCompletedToday`, mas o chip e o anel do hero usam
`stats(period)`, então refletem o período inteiro.

**Critérios de aceite**

- [ ] Anel do hero e contagem usam apenas o dia atual, em qualquer período.
- [ ] Trocar Semana/Mês/Ano não altera o anel.
- [ ] Rótulo do hero fica fixo em "PROGRESSO DE HOJE".
- [ ] `X/Y` do hero = hábitos concluídos hoje ÷ hábitos ativos.

### B6 — Logo com fundo preto

**Labels:** `bug`, `ui`

Resolvido na 1.1.0: `assets/logo.png` é 1024×1024 com alpha 0 nos cantos e o
ícone adaptativo usa fundo cinza claro `#E6E6E9` + foreground transparente. O
ícone legado vem de `assets/logo_light.png`, com o mesmo fundo aplicado.

**Critérios de aceite**

- [x] Logo com transparência real.
- [x] Ícone adaptativo gerado.
- [ ] Reabrir apenas se uma arte oficial diferente for fornecida.

---

## Features

### F1 — Remover "Ver menos" e "Ver todos"

**Labels:** `feature`, `ui`

Hoje a Home mostra 3 hábitos e expande (`take(3)` + `_showAll` + `SectionHeader`).

**Critérios de aceite**

- [ ] O filtro **Todos** mostra todos os hábitos, sem limite de 3.
- [ ] Cada categoria mostra apenas os seus hábitos.
- [ ] `SectionHeader` deixa de ter o controle de expandir/recolher.
- [ ] Nenhum estado `_showAll` restante.

### F2 — Botão único de recolher/expandir todos os cards

**Labels:** `feature`, `ui`

**Critérios de aceite**

- [ ] Um controle ao lado de "Novo hábito" recolhe todos os cards de uma vez.
- [ ] O mesmo controle expande todos.
- [ ] O ícone comunica o estado atual.
- [ ] Chevron por card é removido.
- [ ] O estado global é persistido.

### F3 — Ajustes: apagar todos os dados e feedback no GitHub

**Labels:** `feature`, `data`, `ui`

Hoje só existe "Enviar feedback" abrindo um Google Forms.

**Critérios de aceite**

- [ ] Item "Apagar todos os dados" com diálogo de confirmação explícito.
- [ ] Apagar limpa hábitos, dias, preferências e `last_seen_version`.
- [ ] Após apagar, a Home volta ao estado vazio de primeira instalação.
- [ ] Feedback abre o formulário de issues do repositório no navegador.
- [ ] Se o navegador não abrir, aparece aviso claro.

### F4 — Primeira instalação sem hábitos

**Labels:** `feature`, `data`

**Critérios de aceite**

- [ ] Instalação nova abre com lista vazia e chamada para criar o primeiro hábito.
- [ ] Atualização preserva todos os dados existentes.
- [ ] Nenhum hábito de exemplo é criado em nenhum caminho.

### F5 — Cabeçalho: "Hoje" e data mais próximos

**Labels:** `feature`, `ui`

Hoje o header mostra "HOJE" em caixa alta e a data **acima** dele, com 14dp de
espaçamento.

**Critérios de aceite**

- [ ] Título "Hoje", sem caixa alta.
- [ ] Data por extenso logo abaixo ("Quarta, 4 de novembro").
- [ ] Espaçamento entre os dois reduzido.
- [ ] Botão "Novo" continua no topo direito.

### F6 — Frase motivacional fixa durante o dia

**Labels:** `feature`

Hoje a frase é sorteada a cada abertura (`Random()` + `lastPhrase`).

**Critérios de aceite**

- [ ] A frase é determinística pela data (mesma frase o dia inteiro).
- [ ] Reabrir o app não muda a frase.
- [ ] No dia seguinte, a frase pode mudar.
- [ ] Teste unitário cobre a escolha por data.

### F7 — Dock com lente de vidro líquido

**Labels:** `feature`, `ui`

Hoje o dock é estático (`lib/shared/widgets/glass_dock.dart`) com uma bolinha de
4dp na aba ativa.

**Critérios de aceite**

- [ ] Bolinha branca removida.
- [ ] Lente de vidro sobre a aba ativa.
- [ ] A lente só se move ao ser arrastada (arrastar a tela não move).
- [ ] Ao soltar, encaixa na aba mais próxima com animação.
- [ ] Toque simples na aba continua funcionando.
- [ ] Prévia visual aprovada antes do código (etapa 5).

### F8 — Tela "O que há de novo"

**Labels:** `feature`, `ui`

**Critérios de aceite**

- [ ] Aparece uma vez a cada versão nova.
- [ ] Nunca aparece na primeira instalação.
- [ ] Compara a versão atual com `last_seen_version`.
- [ ] Conteúdo vem de um arquivo único com versão, data e três blocos: Novidades, Melhorias, Bugs corrigidos.
- [ ] "Continuar" fecha e salva a versão vista.
- [ ] Prévia visual aprovada antes do código (etapa 5).

---

## Vindos do segundo cérebro

### V1 — Busca e ordenação no "Ver todos" — **wontfix**

**Labels:** `wontfix`, `feature`

O backup pedia busca e ordenação. O F1 remove o "Ver todos" e passa a mostrar
tudo no filtro Todos, então o item perde o lugar. Se voltar, entra como filtro
da lista completa.

### V2 — Voltar dias para marcar/desmarcar (A13/R10) — **wontfix**

**Labels:** `wontfix`, `feature`

Contradiz D1/B5 (progresso é só de hoje). Registrado como decisão, não como
tarefa. Pode voltar no futuro como "correção de dia" separada do anel.

### V3 — Nome definitivo do app (Alva × Streak)

**Labels:** `feature`, `docs`

**Critérios de aceite**

- [ ] Decisão registrada.
- [ ] Se mudar: `applicationId`, label, ícone, README e CHANGELOG atualizados juntos.

### V4 — Fonte Inter empacotada no app

**Labels:** `feature`, `ui`

`google_fonts` baixa a Inter em tempo de execução; sem rede o app cai na fonte
padrão.

**Critérios de aceite**

- [ ] Arquivos da Inter em `assets/fonts/` e declarados no `pubspec.yaml`.
- [ ] `google_fonts` removido das dependências.
- [ ] Tipografia idêntica à atual com o app em modo avião.

### V5 — Escala de texto e acessibilidade

**Labels:** `feature`, `ui`

**Critérios de aceite**

- [ ] Home em 360dp com escala de texto 1.3, sem overflow.
- [ ] `Semantics` presente em check, chips, dock e botões.
- [ ] Teste de widget com `textScaler` 1.3.

### V6 — Checklist de regressão manual

**Labels:** `docs`, `release`

**Critérios de aceite**

- [ ] Documento em `docs/regressao.md` com o roteiro do tester.
- [ ] Cobrir: primeira instalação, criar/editar hábito, check, trocar período, apagar dados, dock, "O que há de novo", modo avião.

---

## Ordem de entrega

| Etapa | Issues |
|---|---|
| 2 | Repositório, licença, templates, este arquivo |
| 3 | Refatoração de pastas e estado (sem issue de produto) |
| 4 | B2, B3, B5, base de dados e migração |
| 5 | Prévias de B1, F7, F8 e do mapa de falhas |
| 6 | B1, B4, B6, F1, F2, F5, F6, F7 |
| 7 | F3, F4, V4, V5 |
| 8 | F8, V6, CHANGELOG, README final, testes |
