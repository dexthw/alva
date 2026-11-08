# Changelog

Todas as mudanças do Alva, da versão mais recente para a mais antiga. É o mesmo
texto dos Releases no GitHub e da tela "O que há de novo" do app.

## Alva 1.2.0 ✨ — 7 de novembro de 2026

[Release v1.2.0](https://github.com/dexthw/alva/releases/tag/v1.2.0)

Esta versão é sobre clareza: agora você vê tudo o que mudou no app sem precisar
procurar. O card de novidades ficou completo e o histórico das versões anteriores
passou a morar dentro dele. Obrigado por acompanhar cada detalhe.

### 🔄 Atualizações do app

- **A tela de novidades agora mostra a lista completa.** O card resumia as
  mudanças; agora o botão "Ver todas as N mudanças" abre o restante com uma
  animação suave.
- **O histórico das versões anteriores está no mesmo card.** A 1.1.0, a 1.0.2 e
  a 1.0.0 aparecem recolhidas logo abaixo — toque em uma delas para abrir.

### 🎨 Visual e animações

- **O rodapé do card avisa quando ainda há o que rolar.** Um fade suave com o
  texto "Role para ver tudo" aparece só enquanto existe conteúdo abaixo.

### 📲 Download

| APK                        | Para                                  |
| -------------------------- | ------------------------------------- |
| `Alva-v1.2.0.apk`          | Android 7.0 (API 24) ou superior      |
| `Alva-v1.2.0.apk.sha256`   | Conferir a integridade do arquivo     |

1. Baixe o APK no celular.
2. Abra o arquivo e permita instalar de fontes desconhecidas na primeira vez.
3. Toque em **Instalar**. Instalar por cima mantém hábitos e histórico.

## Alva 1.1.0 🎨 — 5 de novembro de 2026

[Release v1.1.0](https://github.com/dexthw/alva/releases/tag/v1.1.0)

A versão que deixou o app mais leve de usar: um anel novo, dock com vida própria
e uma tela para contar o que mudou. Obrigado por testar e apontar cada detalhe.

### ✨ Novidades

- **A tela "O que há de novo" abre uma vez por versão.** Ela aparece na primeira
  abertura depois de atualizar e não volta; na primeira instalação, nunca aparece.
- **"Apagar todos os dados" em Ajustes e na própria tela de novidades.** O
  diálogo informa quantos hábitos serão removidos antes de confirmar.
- **O feedback abre direto o formulário de issues.** O link vai para o
  repositório no navegador e o app avisa se não conseguir abrir.
- **A fonte Inter agora vem dentro do app.** A tipografia fica igual mesmo em
  modo avião.
- **Um toque recolhe ou expande todos os cards.** O botão fica ao lado de
  "Novo" e o estado continua ao reabrir o app.
- **A frase do dia fica igual o dia inteiro.** Ela só pode mudar no dia seguinte.

### 🧭 Navegação

- **A dock tem uma lente de vidro que acompanha o dedo.** Arraste-a entre Hoje e
  Ajustes e ela encaixa com uma mola; a borda dupla saiu.
- **A lente fica menor em repouso e cresce ao segurar ou arrastar.** O halo
  aparece no toque e os ícones não mudam de tamanho.
- **Os rótulos do dock somem ao rolar.** Ao descer sobram só os ícones; ao subir,
  os nomes voltam.

### 🎨 Visual e animações

- **O anel virou um círculo contínuo, sem divisões.** A porcentagem fica no
  centro, com cápsula rosa na ponta e brilho pulsante de cerca de 2,2 s.
- **A rolagem ganhou profundidade.** Cards e blocos esmaecem e encolhem um pouco
  ao sair pelo topo, de forma proporcional e reversível.
- **O seletor de período perdeu as divisórias verticais.** Semana, Mês e Ano
  aparecem separados só pelo espaço e pela pílula de seleção.
- **Recolher e expandir os dias ficou escalonado.** Os dias são puxados para
  dentro ao recolher e empurrados para fora ao expandir, em cerca de 400 ms.
- **Chips e seletor passaram a usar a fonte do tema.** Os controles ficam com a
  mesma tipografia do resto do app, sem cair na fonte padrão.
- **O cabeçalho ficou mais curto.** "Hoje" com a data logo abaixo, sem o título
  ocupando a tela.
- **Os textos de aviso e a ação de apagar ganharam contraste AA.** Mais fáceis de
  ler no tema escuro.

### ✅ Hábitos

- **A lista mostra todos os hábitos do filtro.** O limite de três itens e o
  "Ver todos" saíram.
- **O progresso conta apenas hoje.** Trocar entre Semana, Mês e Ano não muda mais
  o anel nem a contagem.
- **A primeira instalação começa vazia.** Nada de hábitos de exemplo, inclusive
  quando os dados salvos estão corrompidos.
- **A chama mantém o brilho ao concluir o hábito.** A explosão não apaga o brilho
  no pico.
- **Os cards se ajustam com fonte maior.** Escala de texto 1.3 em tela de 360 dp
  não corta mais o conteúdo.
- **O chip de porcentagem saiu do card.** A informação já está no anel e na
  contagem; o chevron individual também saiu.

### 🐛 Correções

- **Os marcadores das listas deixaram de sair amarelos.** O marcador agora é
  desenhado pelo app e segue a cor do texto.

### 📲 Download

| APK                        | Para                                  |
| -------------------------- | ------------------------------------- |
| `Alva-v1.1.0.apk`          | Android 7.0 (API 24) ou superior      |
| `Alva-v1.1.0.apk.sha256`   | Conferir a integridade do arquivo     |

1. Baixe o APK no celular.
2. Abra o arquivo e permita instalar de fontes desconhecidas na primeira vez.
3. Toque em **Instalar**. Instalar por cima mantém hábitos e histórico.

## Alva 1.0.2 💎 — 3 de novembro de 2026

[Release v1.0.2](https://github.com/dexthw/alva/releases/tag/v1.0.2)

A versão em que o Alva passou a lembrar dos seus hábitos. Também chegaram as
visões de mês e ano e o primeiro envio de feedback de dentro do app.

### ✨ Novidades

- **Seus hábitos continuam salvos ao fechar o app.** Dias concluídos, sequência,
  período, categoria e frase ficam guardados no aparelho.
- **A aba Ajustes ganhou "Enviar feedback".** A opção abre o formulário no
  navegador.
- **34 frases motivacionais em português.** A frase é sorteada ao abrir e não
  repete a última.
- **Cada hábito agora tem visão de mês e de ano.** Uma grade compacta para o mês
  e um mapa de calor dos 12 meses.
- **A Home ganhou "Ver todos" e "Ver menos".** A lista deixa de cortar em três
  itens, sem abrir outra tela.
- **A interface ganhou movimento.** Cards entram escalonados, os números contam e
  a chama pulsa.
- **O ícone do app passou a ser adaptativo.** Fundo claro e recorte correto no
  padrão do Android.

### 🎨 Visual e animações

- **O anel foi refeito em vidro fosco facetado.** Ganhou halo, régua, partículas
  e ponta rosada; o anel antigo de 60 marcações saiu.
- **O card de progresso ficou menor.** 144 dp, com anel de 112 dp e menos
  espaçamento interno.
- **Os cards de hábito ficaram cerca de 13% menores.** Miniatura de 76 dp, check
  de 48 dp e padding de 14 dp.
- **Cada card ganhou um chevron para recolher os dias.** Dá para esconder os dias
  de um hábito sem sair da Home.
- **O percentual passou a seguir o período selecionado.** Card e anel passaram a
  mostrar o mesmo recorte.
- **O seletor e os filtros passaram a animar na troca.** A pílula e as cores
  mudam com transição em vez de trocar de uma vez.
- **O nome "Alva" saiu do topo da Home.** O cabeçalho ficou mais limpo, com
  espaço para o conteúdo.

### 🐛 Correções

- **O anel parou de cortar traços e de sobrepor a agulha em 100%.** Os extremos
  ficaram limpos em 0%, 33%, 66% e 100%.
- **A porcentagem por hábito ficou sempre entre 0% e 100%.** Antes o cálculo
  podia passar do limite.
- **O chip verde comemora o último dia concluído.** Ele aparece com uma animação
  sutil em vez de ficar parado.
- **As datas deixaram de se deslocar com fuso e horário de verão.** Os dias da
  semana e do mês ficam corretos.

### 📲 Download

| APK                        | Para                                  |
| -------------------------- | ------------------------------------- |
| `Alva-v1.0.2.apk`          | Android 7.0 (API 24) ou superior      |
| `Alva-v1.0.2.apk.sha256`   | Conferir a integridade do arquivo     |

1. Baixe o APK no celular.
2. Abra o arquivo e permita instalar de fontes desconhecidas na primeira vez.
3. Toque em **Instalar**. Instalar por cima mantém hábitos e histórico.

## Alva 1.0.0 🎉 — 2 de novembro de 2026

[Release v1.0.0](https://github.com/dexthw/alva/releases/tag/v1.0.0)

A primeira versão do Alva: a Home que definiu o visual do app. Obrigado a quem
acompanhou o começo.

### ✨ Novidades

- **A primeira Home completa.** Tema escuro, card de progresso com anel, filtros
  por categoria, cards de hábito, dock em vidro e a folha de novo hábito.

### 📲 Download

O APK desta versão não foi preservado. A primeira versão com arquivo publicado é
a `1.0.2` — baixe-a na página de Releases.
