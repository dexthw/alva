# Contribuir com o Alva

Obrigado pelo interesse. Este guia é curto de propósito.

## Antes de abrir

- **Bug:** use o formulário de bug nas issues, com versão do app, versão do
  Android e o aparelho.
- **Ideia:** use o formulário de feedback e conte o problema que ela resolve.
- **Mudança maior:** abra uma issue antes do código, para combinarmos o rumo.

## Código

- Código em inglês; interface, comentários de produto e documentação em pt-BR.
- Branches: `feature/*` ou `fix/*` saem de `dev` e voltam para `dev`.
  Nunca commite direto em `tester` ou `production`.
- Camadas: `Widget → HomeController/Repositório → storage`. A UI não acessa
  `shared_preferences`.
- Não altere a regra de hábitos nem a persistência local sem um pedido aprovado.
- Mudança com efeito visual pede uma prévia aprovada antes da implementação.

## Critério de pronto

```bash
flutter test
flutter analyze
dart format --language-version=3.5 lib test
```

Os três precisam passar sem avisos e sem alterações de formatação.

## Versão e release

Quem publica segue o [`AGENTS.md`](AGENTS.md): sobe a versão no `pubspec.yaml`,
atualiza `lib/data/release_notes.dart`, o `CHANGELOG.md` e o release no GitHub
com o mesmo texto. APK e checksum ficam anexados ao release, nunca no Git.

## Licença

Ao contribuir, você concorda que sua contribuição é publicada sob a licença MIT
deste repositório.
