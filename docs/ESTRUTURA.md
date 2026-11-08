# Estrutura do projeto

← [Voltar ao README](../README.md)

## Pastas

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
docs/                        guias, regressão, desempenho e notas de release
.github/ISSUE_TEMPLATE/      formulários de bug e feedback
assets/                      logo e fonte Inter
android/                     projeto Android nativo
```

Camadas: `Widget → HomeController (ChangeNotifier) → Repositório →
shared_preferences`. A UI não acessa o armazenamento; o controller concentra
filtro, período, frase do dia e o debounce de gravação.

## Branches

| Branch       | Papel                                                       |
| ------------ | ----------------------------------------------------------- |
| `feature/*`  | Uma funcionalidade ou ajuste, saindo de `dev`                |
| `fix/*`      | Uma correção, saindo de `dev`                                |
| `dev`        | Integração do dia a dia; é a branch padrão do repositório     |
| `tester`     | Versão em validação manual com o roteiro de regressão         |
| `production` | Código publicado nos Releases                                |

Hoje o repositório remoto tem só `dev` (e branches de trabalho). `tester` e
`production` são criadas quando a versão sai de `dev` para validação e para
publicação.

Fluxo: `feature/*` ou `fix/*` → `dev` → `tester` → `production`.

Regras:

- Nunca commitar direto em `tester` ou `production`.
- `tester` só recebe código com `flutter test`, `flutter analyze` e
  `dart format` limpos.
- `production` recebe o que passou no roteiro de
  [`regressao.md`](regressao.md).
- APKs e checksums ficam anexados aos Releases, nunca no histórico do Git
  (`*.apk`, `dist/` e `build/` são ignorados).

## Documentos

| Documento                      | Conteúdo                                  |
| ------------------------------ | ----------------------------------------- |
| [`FUNCIONALIDADES.md`](FUNCIONALIDADES.md) | O que o app faz hoje e o que vem depois |
| [`INSTALACAO.md`](INSTALACAO.md)           | Instalar e atualizar o APK             |
| [`DESENVOLVIMENTO.md`](DESENVOLVIMENTO.md) | Ambiente, comandos e publicação        |
| [`regressao.md`](regressao.md)             | Checklist manual antes de publicar     |
| [`desempenho.md`](desempenho.md)           | Como medir as animações em aparelho    |
| [`issues.md`](issues.md)                   | Backlog da versão 1.1.0                |
| [`releases/`](releases/)                   | Texto pronto de cada release           |
