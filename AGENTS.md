# Regras permanentes do projeto — Alva

Estas regras valem para toda tarefa, sem precisar repetir o pedido.

## Repositório

- Repositório oficial: <https://github.com/dexthw/alva>. Usar esse repositório.
  **Não criar outro.**
- Publicar os APKs como GitHub Releases dele, organizados por versão.
- Nunca gravar tokens, senhas ou keystores no código nem no repositório.

## 1. Versionamento (obrigatório a cada entrega)

Sempre que houver qualquer mudança que gere um novo APK:

1. Incrementar a versão no `pubspec.yaml` seguindo o padrão semântico:
   - **Patch (`X.Y.Z+1`):** correções de bug e ajustes visuais pequenos.
   - **Minor (`X.Y+1.0`):** novas funcionalidades ou animações relevantes.
   - **Major (`X+1.0.0`):** mudanças grandes que alterem a estrutura do app.
2. Incrementar também o número de build (`+N`) a cada APK gerado, mesmo que a
   versão visível não mude.
3. Usar a mesma versão no nome do APK (`Alva-vX.Y.Z.apk`) e do checksum
   (`Alva-vX.Y.Z.apk.sha256`), na tag do release e no README.
4. Nunca reaproveitar um número de versão já publicado.

## 2. Tela de atualizações (obrigatório a cada versão)

Toda versão nova deve aparecer na tela de atualizações do app
(`lib/data/release_notes.dart`), no mesmo formato das anteriores:

- Número da versão e data.
- Lista das mudanças em linguagem clara, voltada ao usuário final, separadas por
  categoria (novas funcionalidades, ajustes visuais, correções de bug).
- A versão mais recente no topo.
- Basear o conteúdo apenas no que realmente foi alterado. Não inventar itens.
- Replicar o mesmo texto no changelog do README e nas notas do GitHub Release,
  para os três ficarem consistentes.

## 3. Aprovação visual antes de implementar (obrigatório)

Sempre que a tarefa envolver algo novo, ou algo correlato que possa ser mostrado
em imagem (telas, componentes, layouts, cores, ícones, estados de animação,
efeitos):

1. **Antes** de escrever o código, gerar uma imagem ou mockup do resultado
   proposto.
2. Para animações, mostrar os estados principais em sequência (por exemplo:
   parado, em interação, recolhido, expandido) e descrever o movimento em uma
   linha.
3. Apresentar a imagem e **parar**. Aguardar aprovação explícita antes de
   implementar.
4. Se houver pedido de ajustes, gerar nova imagem e pedir aprovação de novo.
5. Só implementar depois do "aprovado". Mudança puramente interna (lógica,
   correção sem efeito visual) não exige mockup.

## 4. Ordem de execução de cada entrega

1. Mockup e aprovação (quando se aplicar).
2. Implementação e validação.
3. Atualização da versão.
4. Atualização da tela de atualizações.
5. Geração do APK, release no GitHub e atualização do README.
6. Resumo final: versão publicada, link do release e arquivos alterados.

## Regras gerais

- Alterar apenas o que foi pedido. Não mudar a lógica de hábitos nem a
  persistência local sem pedido.
- Se algum passo falhar (build, autenticação, permissão), parar, explicar o
  motivo e dizer o que falta.

## Contexto técnico do projeto

- Flutter/Dart, Material 3, tema escuro. Código em inglês, UI e documentação em
  português (pt-BR).
- Branches: `feature/*`/`fix/*` → `dev` → `tester` → `production`. Nunca
  commitar direto em `tester` ou `production`.
- Camadas: UI → `HomeController`/repositórios → storage. A UI nunca acessa
  `shared_preferences`.
- Critério de pronto: critérios de aceite atendidos, `flutter test` verde,
  `flutter analyze` sem avisos e `dart format --language-version=3.5 lib test`
  sem alterações.
- APKs e checksums ficam anexados aos releases, nunca no histórico do Git
  (`*.apk`, `dist/` e `build/` são ignorados).
