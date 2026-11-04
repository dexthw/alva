# Alva

Habit tracker em Flutter com UI escura, cards grafite, anel de progresso em
vidro facetado e dock flutuante.

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

```
lib/
├─ main.dart              entrada do app
├─ core/                  helpers de animação e rótulos de data
├─ models/habit.dart      Habit, Period e estatísticas
├─ data/                  HabitRepository (shared_preferences) e frases
├─ screens/               Home, Settings e o shell com o dock
├─ theme/                 cores e tema Material 3
└─ widgets/               anel, chama, contagem e widgets da Home
test/                     testes unitários e de widget
```

## Branches

Fluxo: `feature/*` ou `fix/*` → `dev` → `tester` → `production`.

- `dev`: desenvolvimento.
- `tester`: QA; recebe apenas merge.
- `production`: estável; recebe apenas merge.
- Nunca commitar direto em `tester` ou `production`.

## Versionamento

SemVer `MAJOR.MINOR.PATCH+build` no `pubspec.yaml`, registrado no
`CHANGELOG.md` e marcado com a tag `vX.Y.Z`. A versão não aparece na interface.
