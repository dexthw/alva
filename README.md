<div align="center">

<img src="docs/assets/logo.png" alt="Logo do Alva" width="88" />

# Alva

**Hábitos diários com progresso que dá gosto de ver.**

<p>
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white" />
  <img alt="Dart" src="https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white" />
  <img alt="Android" src="https://img.shields.io/badge/Android-3DDC84?style=flat&logo=android&logoColor=white" />
  <img alt="Licença MIT" src="https://img.shields.io/badge/Licen%C3%A7a-MIT-7C3AED?style=flat&logo=opensourceinitiative&logoColor=white" />
  <img alt="Sem anúncios, sem rastreamento" src="https://img.shields.io/badge/Sem%20an%C3%BAncios%20%C2%B7%20Sem%20rastreamento-22C55E?style=flat&logo=shield&logoColor=white" />
</p>

<sub>
  <a href="#-funcionalidades">Funcionalidades</a> ·
  <a href="#-download">Download</a> ·
  <a href="#-privacidade">Privacidade</a> ·
  <a href="#-contribuir-e-contato">Contribuir</a>
</sub>

</div>

---

## 📱 Visão geral

O Alva é um app de hábitos para Android, feito em Flutter, com tema escuro, vidro
líquido e animações fluidas. Cada hábito tem seus dias, sua sequência e o
progresso de hoje.

Sem conta, sem nuvem e sem anúncios: seus hábitos ficam apenas no aparelho.

---

## ✨ Funcionalidades

### 📊 Acompanhamento do progresso

- Anel de vidro com a porcentagem de hoje no centro.
- Contagem de hábitos concluídos hoje, no formato `X/Y`.
- Sequência (streak) com chama animada e explosão ao concluir o hábito.
- Três modos por hábito: semana, mês e ano, com mapa de calor de 12 meses.
- Frase motivacional que fica igual durante todo o dia.

### 🎨 Visual e personalização

- Tema escuro com Material 3 e superfícies em vidro líquido.
- Anel com cápsula rosa na ponta e brilho pulsante de cerca de 2,2 s.
- Cards entram escalonados e os números contam até o valor final.
- Cards e blocos esmaecem ao sair pelo topo da rolagem e voltam ao subir.
- Fonte Inter empacotada no app: a tipografia funciona em modo avião.
- Respeita a opção "reduzir movimento" do sistema.

### 🧭 Navegação e organização

- Dock flutuante com Hoje e Ajustes, arrastável e com lente de vidro.
- Os rótulos do dock somem ao descer a página e voltam ao subir.
- Filtros por categoria: Todos, Fitness, Estudo e Health.
- Recolher ou expandir todos os cards de uma vez, com o estado mantido.

### 💾 Seus dados

- Tudo salvo no próprio aparelho, sem conta e sem nuvem.
- "Apagar todos os dados" em Ajustes, com confirmação e contagem de hábitos.
- Tela "O que há de novo" uma vez por versão, com o histórico das anteriores.
- Feedback abre o formulário de issues deste repositório no navegador.

### 🔮 Em breve

- Tela dedicada de criação de hábito, com recorrência, meta semanal, ícone e cor.
- Lembretes por hábito, nos dias que você escolher.
- Backup manual em um arquivo que você mesmo guarda.

Detalhes de cada funcionalidade em
[`docs/FUNCIONALIDADES.md`](docs/FUNCIONALIDADES.md).

---

## 📲 Download

O Alva é distribuído como APK, fora da Play Store. Todos os arquivos ficam na
página de **[Releases](https://github.com/dexthw/alva/releases)**.

**Versão atual:** `1.2.0` · **Requer Android 7.0 (API 24) ou superior.**

| APK                          | Para                                  |
| ---------------------------- | ------------------------------------- |
| `Alva-v1.2.0.apk`            | Qualquer Android 7.0 (API 24) ou mais |
| `Alva-v1.2.0.apk.sha256`     | Conferir a integridade do download    |

### 📥 Instalação

1. Abra a página de **[Releases](https://github.com/dexthw/alva/releases)** e baixe o `.apk` no celular.
2. Toque no arquivo baixado. Na primeira vez, o Android pede para permitir
   instalar apps de fontes desconhecidas: autorize o navegador ou o gerenciador
   de arquivos que fez o download.
3. Toque em **Instalar**.
4. Para atualizar, instale o APK novo por cima do anterior: hábitos e histórico
   são preservados.

O que mudou nesta versão está em
[`docs/releases/v1.2.0.md`](docs/releases/v1.2.0.md). Passo a passo por versão do
Android em [`docs/INSTALACAO.md`](docs/INSTALACAO.md).

---

## 🔒 Privacidade

O Alva não tem conta, não tem nuvem e não tem anúncios. Os hábitos, os dias
concluídos, a sequência e as preferências ficam no armazenamento local do
aparelho.

O APK de release **não declara a permissão de internet** e o app não inclui
analytics nem rastreadores. O único link externo é o formulário de feedback, que
abre no seu navegador — ali valem as regras do navegador.

"Apagar todos os dados" remove tudo o que o app guardou. Desinstalar o app
também apaga os dados, sem cópia em nenhum servidor.

---

## 🗺️ Roadmap

- 🧭 **Tela de criação de hábito.** Hoje o hábito nasce em uma folha com nome e
  categoria; a próxima versão quer uma tela dedicada, com recorrência, meta
  semanal, ícone e cor.
- 🔔 **Lembretes por hábito.** Um aviso nos dias escolhidos, sem servidor.
- 💾 **Backup manual.** Exportar e restaurar um arquivo que você mesmo guarda.

Nada de nuvem ou conta de usuário está previsto.

---

## 🤝 Contribuir e contato

Leia o [`CONTRIBUTING.md`](CONTRIBUTING.md) antes de abrir um pull request.
Bugs e ideias vão pelos formulários de
**[issues](https://github.com/dexthw/alva/issues/new/choose)**; para qualquer outro assunto, abra uma
issue e respondo por lá.

O roteiro manual de regressão está em
[`docs/regressao.md`](docs/regressao.md) e o de desempenho em
[`docs/desempenho.md`](docs/desempenho.md).

---

<div align="center">

## 📄 Licença

MIT — veja [`LICENSE`](LICENSE).

<sub>Feito com calma, em Flutter. Sem anúncios e sem rastreamento.</sub>

</div>
