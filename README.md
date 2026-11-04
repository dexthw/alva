# Alva

Habit tracker em Flutter com UI escura, cards grafite, anel de progresso em
vidro facetado e dock flutuante.

**Em desenvolvimento:** `1.1.0` — backlog e critérios de aceite em
[`docs/issues.md`](docs/issues.md).

## Como rodar

```bash
flutter pub get
flutter run
```

O projeto Android já está no repositório. Para gerar o APK:

```bash
flutter build apk --release
# build/app/outputs/flutter-apk/app-release.apk
```

Testes e análise:

```bash
flutter test
flutter analyze
```

### Ícone do app

O ícone é gerado a partir de `assets/logo.png`:

```bash
dart run flutter_launcher_icons
```

## Estrutura

```text
lib/
├─ main.dart              entrada do app
├─ core/                  helpers de animação e rótulos de data
├─ models/habit.dart      Habit, Period e estatísticas
├─ data/                  HabitRepository (shared_preferences) e frases
├─ screens/               Home, Settings e o shell com o dock
├─ theme/                 cores e tema Material 3
└─ widgets/               anel, chama, contagem e widgets da Home
test/                     testes unitários e de widget
docs/                     backlog da versão e checklist de regressão
.github/ISSUE_TEMPLATE/   formulários de bug e feedback
```

## Issues e backlog

- Formulário de bug: `.github/ISSUE_TEMPLATE/bug.yml`
- Formulário de feedback: `.github/ISSUE_TEMPLATE/feedback.yml`
- Backlog da versão: [`docs/issues.md`](docs/issues.md)

## Branches

Fluxo: `feature/*` ou `fix/*` → `dev` → `tester` → `production`.

- `dev`: desenvolvimento ativo.
- `tester`: validação; recebe apenas merge de `dev`.
- `production`: estável; recebe apenas merge de `tester` e recebe a tag da release.
- Nunca commitar direto em `tester` ou `production`.

### Abrir uma branch de trabalho

```bash
git switch dev
git switch -c feature/1.1.0
```

Para correções: `git switch -c fix/nome-curto`.

### Sequência de merges de uma release

```bash
# 1. trabalho -> dev
git switch dev
git merge --no-ff feature/1.1.0

# 2. dev -> tester (validação)
git switch tester
git merge --no-ff dev

# 3. tester -> production (release)
git switch production
git merge --no-ff tester
git tag -a v1.1.0 -m "chore(release): v1.1.0"
```

Com remote configurado, cada merge é seguido de `git push origin <branch>` e a
release de `git push origin production --tags`.

### Proteção recomendada (GitHub)

| Branch | Regras |
|---|---|
| `production` | exigir pull request, 1 aprovação, status checks verdes, sem push direto, sem force push, exigir branch atualizada |
| `tester` | exigir pull request vindo de `dev`, sem push direto |
| `dev` | exigir pull request, permitir squash merge, status checks verdes |

## Versionamento

SemVer `MAJOR.MINOR.PATCH+build` no `pubspec.yaml`, registrado no
`CHANGELOG.md` e marcado com a tag `vX.Y.Z`. A versão não aparece na interface.

## Licença

MIT — veja [`LICENSE`](LICENSE).
