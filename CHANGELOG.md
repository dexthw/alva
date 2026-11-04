# Changelog

Todas as mudanças relevantes deste projeto são documentadas aqui.

O formato segue [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) e o
versionamento segue [SemVer](https://semver.org/lang/pt-BR/).

## [1.0.2] - 2026-11-03

### Added

- Persistência local (JSON em `shared_preferences`) em `HabitRepository`, salvando hábitos, dias concluídos, sequência, período, categoria, última frase e o estado recolhido de cada card.
- Aba Settings com a única opção "Enviar feedback", que abre o Google Forms no navegador via `url_launcher`.
- Banco de 34 frases motivacionais em pt-BR, sorteio ao abrir o app sem repetir a última e troca com fade.
- Modos Mês (grade compacta) e Ano (mapa de calor dos 12 meses) funcionais nos cards.
- Chevron por card para recolher/expandir a área de dias.
- "Ver todos"/"Ver menos" na Home, expandindo a lista sem tela nova.
- Animações de entrada escalonada dos cards, contagem dos números e da porcentagem.
- Chama da sequência com pulso contínuo, brilho discreto e explosão ao concluir o hábito do dia.
- Ícone adaptativo do app gerado com `flutter_launcher_icons` a partir de `assets/logo.png`.
- Testes unitários de porcentagem, sequência e persistência, e widget test do anel em 0%, 33%, 66% e 100%.

### Changed

- Anel de progresso refeito em vidro fosco facetado (12 facetas), com halo, régua, partículas e ponta rosada; camada estática cacheada em `Picture`.
- Card de progresso reduzido para 144dp, com anel de 112dp e padding menor.
- Cards de hábito ~13% menores (miniatura 76dp, check 48dp, padding 14dp).
- Percentual do card e anel do topo passam a refletir o período selecionado (semana, mês ou ano).
- Seletor de período e filtros com transições animadas.
- `main.dart` dividido em `theme/`, `models/`, `data/`, `widgets/` e `screens/`.
- Versão do app atualizada para `1.0.2+2`.

### Fixed

- Bug visual do anel: sem traços cortados, sem agulha sobreposta em 100% e sem "pulos" entre marcações.
- Cálculo de porcentagem por hábito com clamp entre 0% e 100% e janela correta por período.
- Chip verde exibindo `100%` ao concluir o último dia esperado, com animação sutil.
- Datas passaram a ser calculadas por construtor (`DateTime(y, m, d ± n)`), evitando deslocamento em mudanças de fuso/DST.

### Removed

- Wordmark "Alva" do canto superior esquerdo da Home.
- Anel antigo com 60 marcações, pontos cardeais e agulha.
- Nenhuma tela cheia de criação de hábito existia; o bottom sheet simples (nome + categoria) foi mantido.

## [1.0.0] - 2026-11-02

### Added

- Primeira versão visual da Home: tema escuro, card de progresso, filtros por categoria, cards de hábito, dock em vidro e folha de novo hábito.
