# Alva — app de hábitos

Aplicativo Android de acompanhamento de hábitos diários, feito em Flutter. O Alva
serve para quem quer registrar a rotina de forma rápida e visual: cada hábito
tem seus dias, sua sequência e um progresso de hoje, sem conta, sem nuvem e sem
cadastro. Todos os dados ficam no aparelho.

**Versão atual:** `1.1.0`
**Repositório:** <https://github.com/dexthw/alva>

---

## Instalação

O aplicativo é distribuído como APK, fora da Play Store.

1. Abra a aba **[Releases](../../releases)** deste repositório.
2. Escolha a versão desejada e baixe o arquivo `app-habitos-vX.Y.Z.apk`.
3. Confira, se quiser, o checksum `app-habitos-vX.Y.Z.apk.sha256` anexado ao
   mesmo release.
4. No Android, abra o arquivo baixado. Na primeira vez o sistema pede para
   permitir a instalação de aplicativos de fontes desconhecidas:
   **Configurações → Apps → Acesso especial → Instalar apps desconhecidos**,
   e autorize o navegador ou o gerenciador de arquivos usado no download.
5. Toque em **Instalar**. Para atualizar, instale o APK novo por cima do
   anterior: hábitos e histórico são preservados.

Requisitos: Android 7.0 (API 24) ou superior.

---

## Funcionalidades atuais

- **Home com progresso do dia** em anel de vidro, com a porcentagem no centro e
  contagem de hábitos concluídos.
- **Hábitos por categoria**, com filtros (Todos, Fitness, Estudo, Health) e
  busca visual por chips.
- **Três modos de dias** por hábito: semana, mês e ano.
- **Sequência (streak)** com chama animada e explosão ao concluir o hábito.
- **Frase motivacional do dia**, determinística pela data.
- **Recolher todos os cards** de uma vez, com estado persistido.
- **Tela "O que há de novo"** exibida uma vez a cada versão.
- **Apagar todos os dados** em Ajustes e na própria tela de novidades, com
  confirmação.
- **Dock flutuante em vidro líquido**, arrastável, com rótulos que somem durante
  a rolagem.
- **Feedback** que abre o formulário de issues deste repositório.
- **Funciona offline**, inclusive a tipografia (fonte Inter empacotada).

---

## Histórico de versões

As notas abaixo refletem apenas o que foi alterado no código. Cada versão tem um
release correspondente na aba **[Releases](../../releases)**.

### 1.1.0 — 5 de novembro de 2026

[Release v1.1.0](../../releases/tag/v1.1.0) · APK: `app-habitos-v1.1.0.apk`

#### Novas funcionalidades

| Mudança | Por que mudou | Como você percebe | Categoria |
|---|---|---|---|
| Tela "O que há de novo", uma vez por versão | O usuário não tinha como saber o que mudou ao atualizar | Um card sobre a Home aparece na primeira abertura após atualizar e não volta | Nova funcionalidade |
| "Apagar todos os dados" em Ajustes e na tela de novidades | Não havia como recomeçar do zero sem desinstalar o app | Diálogo informa quantos hábitos serão removidos e apaga hábitos, histórico e preferências | Nova funcionalidade |
| Feedback pelo formulário de issues do repositório | O Google Forms não registrava o contexto do app nem permitia acompanhar o retorno | "Enviar feedback" abre o formulário no navegador; avisa se não conseguir | Nova funcionalidade |
| Fonte Inter empacotada no app | A tipografia vinha do `google_fonts`, que baixa fontes e falha offline | O app mantém a mesma fonte em modo avião e na primeira abertura | Nova funcionalidade |
| Recolhimento global dos cards | Recolher um por um era lento em listas longas | Um botão ao lado de "Novo" recolhe ou expande todos; o estado permanece ao reabrir | Nova funcionalidade |
| Frase do dia determinística | A frase mudava a cada abertura, o que parecia aleatório | A mesma frase vale para o dia inteiro | Nova funcionalidade |
| Roteiro manual de regressão (`docs/regressao.md`) | Faltava um checklist para validar o app no aparelho | Documento para quem testa, sem impacto direto no uso | Nova funcionalidade (documentação) |

#### Ajustes visuais

| Mudança | Por que mudou | Como você percebe | Categoria |
|---|---|---|---|
| Anel de progresso circular, sem divisões, com cápsula rosa e brilho pulsante | O anel anterior, facetado, não correspondia à referência aprovada | Anel contínuo, com brilho suave de ~2,2 s, e a porcentagem no centro | Ajuste visual |
| Dock com lente de vidro vazada e encaixe por mola | A borda dupla incomodava e o encaixe era seco | A lente acompanha o dedo e assenta com elasticidade; a borda externa saiu | Ajuste visual |
| Seletor de período sem divisórias verticais | A linha aparecia no meio da opção selecionada | Semana, Mês e Ano aparecem separados apenas pelo espaço e pela pílula de seleção | Ajuste visual |
| Cards e blocos esmaecem ao sair pelo topo da rolagem | A rolagem parecia chapada, sem profundidade | Ao descer, o conteúdo do topo perde opacidade e encolhe levemente; ao subir, volta | Ajuste visual |
| Dock esconde os rótulos durante a rolagem | Os rótulos competiam com o conteúdo na tela pequena | Ao descer, sobram só os ícones sobre o vidro; ao subir, os rótulos reaparecem | Ajuste visual |
| Lente do dock menor em repouso e maior ao segurar/arrastar | A lente parada parecia grande demais e sem resposta ao toque | A lente cresce com um halo ao ser tocada ou arrastada e volta com mola; os ícones não mudam de tamanho | Ajuste visual |
| Recolher/expandir dias com escalonamento | A área de dias sumia de uma vez | Os dias são puxados para dentro ao recolher e empurrados para fora ao expandir, em ~400 ms | Ajuste visual |
| Lista de hábitos sem limite de três itens | O app escondia hábitos atrás de "Ver todos" | Todos os hábitos do filtro aparecem na Home | Ajuste visual |
| Cabeçalho com "Hoje" e a data logo abaixo | O título ocupava espaço demais | Cabeçalho mais curto, com a data em destaque menor | Ajuste visual |
| Chips e seletor herdando a fonte do tema | Os controles usavam a fonte padrão do Flutter | A tipografia fica uniforme com a Inter | Ajuste visual |
| Textos "Em breve" e "Apagar dados" com contraste AA | Os textos ficavam abaixo do mínimo de leitura confortável | Aviso e ação destrutiva com contraste ≥ 4,5:1 | Ajuste visual (acessibilidade) |

#### Correções

| Mudança | Por que mudou | Como você percebe | Categoria |
|---|---|---|---|
| Marcadores das listas da tela de novidades apareciam amarelos | O caractere "•" caía na fonte de emoji do sistema | Os marcadores agora são desenhados e seguem a cor do texto | Correção de bug |
| Brilho da chama zerava durante a explosão | A animação de conclusão apagava o brilho no pico | A chama mantém o brilho ao concluir o hábito | Correção de bug |
| Hábitos fictícios na primeira instalação e com dados corrompidos | O app criava exemplos que o usuário não pediu | A primeira abertura começa vazia | Correção de bug |
| Progresso contando dias anteriores | O percentual somava o período inteiro em vez de hoje | Percentual do card e do anel refletem apenas o dia atual | Correção de bug |
| Cards estourando layout com escala de texto 1.3 | Acessibilidade com fonte maior quebrava o card em 360 dp | O conteúdo se ajusta sem overflow | Correção de bug (acessibilidade) |

#### Remoções

| Mudança | Por que mudou | Como você percebe | Categoria |
|---|---|---|---|
| "Ver todos"/"Ver menos" e o estado `_showAll` | A lista completa tornou o controle desnecessário | A seção "Meus hábitos" mostra tudo | Ajuste visual |
| Chevron por card e o campo `collapsed` do hábito | O recolhimento passou a ser global | Sem chevron individual | Ajuste visual |
| Chip de porcentagem do card | A informação já está no anel e na contagem | Card mais limpo | Ajuste visual |
| Dependência `google_fonts` | Fonte passou a ser empacotada | Sem download de fonte em tempo de execução | Ajuste técnico |

### 1.0.2 — 3 de novembro de 2026

[Release v1.0.2](../../releases/tag/v1.0.2) · APK: `app-habitos-v1.0.2.apk`

#### Novas funcionalidades

| Mudança | Por que mudou | Como você percebe | Categoria |
|---|---|---|---|
| Persistência local em `shared_preferences` | Os hábitos se perdiam ao fechar o app | Hábitos, dias concluídos, sequência, período, categoria e frase continuam salvos | Nova funcionalidade |
| Aba Ajustes com "Enviar feedback" | Não havia canal de retorno no app | Opção que abre o formulário no navegador | Nova funcionalidade |
| Banco de 34 frases motivacionais em pt-BR | A frase única repetia demais | Frase sorteada ao abrir, sem repetir a última | Nova funcionalidade |
| Modos Mês e Ano nos cards | A visão semanal não mostrava histórico | Grade compacta do mês e mapa de calor dos 12 meses | Nova funcionalidade |
| "Ver todos"/"Ver menos" na Home | A lista cortava em três itens | Expande a lista sem abrir outra tela | Nova funcionalidade |
| Animações de entrada, contagem e chama | A interface parecia estática | Cards entram escalonados, números contam e a chama pulsa | Nova funcionalidade |
| Ícone adaptativo gerado de `assets/logo.png` | O ícone não seguia o padrão adaptativo do Android | Ícone com fundo claro e recorte correto | Nova funcionalidade |
| Testes de porcentagem, sequência, persistência e anel | Faltava rede de segurança para as regras | Sem impacto direto no uso | Nova funcionalidade (qualidade) |

#### Ajustes visuais

| Mudança | Por que mudou | Como você percebe | Categoria |
|---|---|---|---|
| Anel refeito em vidro fosco facetado | O anel anterior era simples demais | Anel com halo, régua, partículas e ponta rosada | Ajuste visual |
| Card de progresso reduzido para 144 dp | O card ocupava espaço excessivo | Mais conteúdo visível na primeira tela | Ajuste visual |
| Cards de hábito ~13% menores | Os cards ficavam altos em telas pequenas | Miniatura de 76 dp, check de 48 dp e padding de 14 dp | Ajuste visual |
| Percentual refletindo o período selecionado | O card e o anel divergiam | Os dois mostram o mesmo período | Ajuste visual |
| Transições animadas no seletor e nos filtros | A troca era instantânea e sem contexto | Pílula e cores animam ao trocar | Ajuste visual |
| Código dividido em `theme/`, `models/`, `data/`, `widgets/` e `screens/` | O `main.dart` concentrava tudo | Sem impacto no uso; base para as versões seguintes | Ajuste técnico |

#### Correções

| Mudança | Por que mudou | Como você percebe | Categoria |
|---|---|---|---|
| Anel sem traços cortados nem agulha sobreposta em 100% | Havia artefatos visuais nos extremos | Anel limpo em 0%, 33%, 66% e 100% | Correção de bug |
| Porcentagem por hábito limitada entre 0% e 100% | O cálculo podia passar do limite | Valores sempre dentro da faixa | Correção de bug |
| Chip verde exibindo 100% ao concluir o último dia | O estado final não era comemorado | Chip aparece com animação sutil | Correção de bug |
| Datas calculadas por construtor | Mudanças de fuso/DST deslocavam os dias | Os dias da semana e do mês ficam corretos | Correção de bug |

#### Remoções

| Mudança | Por que mudou | Como você percebe | Categoria |
|---|---|---|---|
| Wordmark "Alva" do canto superior esquerdo | O título competia com "Hoje" | Cabeçalho mais limpo | Ajuste visual |
| Anel antigo com 60 marcações, pontos cardeais e agulha | Substituído pelo anel facetado | Visual novo | Ajuste visual |

### 1.0.0 — 2 de novembro de 2026

[Release v1.0.0](../../releases/tag/v1.0.0) · APK **não disponível** (o binário
dessa versão não foi preservado; a primeira versão com APK publicado é a 1.0.2).

| Mudança | Por que mudou | Como você percebe | Categoria |
|---|---|---|---|
| Primeira versão visual da Home | Validar a direção de design do app | Tema escuro, card de progresso, filtros por categoria, cards de hábito, dock em vidro e folha de novo hábito | Nova funcionalidade |

---

## Estrutura do projeto

```text
lib/
├─ main.dart                 inicialização do app
├─ app.dart                  tema e rota inicial
├─ core/
│  ├─ app_info.dart          versão, repositório e URL de feedback
│  ├─ constants.dart         espaçamentos, raios, tamanhos e durações
│  ├─ theme/                 cores e ThemeData
│  └─ utils/                 animação (respeito a "reduzir movimento") e datas
├─ data/
│  ├─ models/                Habit, Period e estatísticas
│  ├─ repositories/          HabitRepository e ReleaseRepository (storage)
│  ├─ phrases.dart           frases motivacionais
│  └─ release_notes.dart     conteúdo da tela de novidades
├─ features/
│  ├─ shell/                 AppShell: abas, dock e abertura das novidades
│  ├─ home/                  HomePage, HomeController e widgets da Home
│  ├─ habits/                cards, visões de semana/mês/ano e novo hábito
│  ├─ settings/              Ajustes e diálogo de apagar dados
│  └─ whats_new/             tela "O que há de novo"
└─ shared/widgets/           anel, chama, contagem, dock, fade de rolagem, grade

test/                        espelha lib/ (core, data, features e shared)
docs/                        backlog da versão e checklist de regressão
.github/ISSUE_TEMPLATE/      formulários de bug e feedback
```

Camadas: `Widget → HomeController (ChangeNotifier) → Repositório → shared_preferences`.
A UI não acessa o armazenamento; o controller concentra filtro, período, frase do
dia e o debounce de gravação. Nenhum dado sai do aparelho.

### Desenvolvimento

```bash
flutter pub get
flutter run
flutter test
flutter analyze
```

Para gerar o APK:

```bash
flutter build apk --release
# build/app/outputs/flutter-apk/app-release.apk
```

O ícone é gerado a partir de `assets/logo.png` com `dart run flutter_launcher_icons`.

---

## Roadmap

**Próxima etapa: tela de criação de hábito.**

Hoje o app cria hábitos por uma folha simples com nome e categoria. A próxima
versão deve trazer uma tela dedicada, com recorrência, meta semanal, ícone e
cor por hábito, mantendo o mesmo repositório local e a mesma regra de sequência.
Nada de nuvem ou conta de usuário está previsto.

---

## Licença

MIT — veja [`LICENSE`](LICENSE).
