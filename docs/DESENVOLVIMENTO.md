# Desenvolvimento

← [Voltar ao README](../README.md)

## Ambiente

- Flutter com Dart `>=3.5.0 <4.0.0`.
- Android SDK com compilação em Java 17.

```bash
flutter pub get
flutter run            # aparelho ou emulador conectado
```

## Comandos do dia a dia

```bash
flutter test                                      # testes
flutter analyze                                   # avisos
dart format --language-version=3.5 lib test       # formatação
```

O critério de pronto é: testes verdes, `analyze` sem avisos e formatação sem
alterações.

## Estrutura de código

Veja [`ESTRUTURA.md`](ESTRUTURA.md). Em resumo: UI → `HomeController` →
repositórios → `shared_preferences`. A UI nunca toca no storage.

## Ícone do app

O ícone é gerado a partir de `assets/logo.png`:

```bash
dart run flutter_launcher_icons
```

Configuração em `pubspec.yaml` (`flutter_launcher_icons`), com fundo `#E6E6E9` e
`min_sdk_android: 24`.

## Gerar o APK

```bash
flutter build apk --release
# build/app/outputs/flutter-apk/app-release.apk
```

Renomeie o arquivo para `Alva-vX.Y.Z.apk` e gere o checksum:

```bash
sha256sum Alva-vX.Y.Z.apk > Alva-vX.Y.Z.apk.sha256
```

## Subir uma versão

1. Suba `version` no `pubspec.yaml` (`X.Y.Z+N`): patch para correção, minor para
   funcionalidade, major para mudança estrutural. O build `+N` sempre sobe.
2. Atualize `lib/core/app_info.dart` (`AppInfo.version`).
3. Adicione a versão no topo de `lib/data/release_notes.dart`.
4. Atualize `CHANGELOG.md` e `docs/releases/vX.Y.Z.md` com **o mesmo texto**.
5. Rode testes, análise e formatação.
6. Gere o APK e o checksum.
7. Publique o release `vX.Y.Z` com título `Alva X.Y.Z` + emoji, anexando os dois
   arquivos.
8. Atualize o README (versão atual e tabela de download).

O texto de uma versão aparece em quatro lugares e precisa ser idêntico: tela de
novidades, `CHANGELOG.md`, notas do release e tabela do README.

## Regras que não mudam

- Sem conta, sem nuvem, sem anúncios e sem analytics.
- Nada de APK ou keystore no Git.
- Não alterar a lógica de hábitos nem a persistência local sem pedido aprovado.
- Mudança visual passa por prévia aprovada antes do código.
