# Funcionalidades

← [Voltar ao README](../README.md)

Tudo o que existe hoje no app, com o comportamento real de cada item. O que ainda
não existe está no fim, em **Em breve**.

## Progresso

- **Anel de hoje.** O anel do topo mostra a porcentagem de hábitos concluídos no
  dia. Ele é sempre de hoje: trocar entre Semana, Mês e Ano não altera o anel.
- **Contagem `X/Y`.** `X` é quantos hábitos foram concluídos hoje; `Y` é quantos
  hábitos existem no filtro atual.
- **Sequência (streak).** Cada hábito conta quantos dias seguidos foram
  concluídos. A chama pulsa continuamente e solta uma explosão ao concluir.
- **Semana, Mês e Ano.** Cada card tem três modos de dias: os 7 dias da semana, a
  grade compacta do mês e um mapa de calor dos 12 meses.
- **Frase do dia.** Uma frase motivacional em pt-BR escolhida pela data. A mesma
  frase vale para o dia inteiro e pode mudar no dia seguinte.

## Organização

- **Categorias.** Todos, Fitness, Estudo e Health, em chips no topo da lista.
- **Recolher tudo.** Um controle ao lado de "Novo" recolhe ou expande todos os
  cards; o estado é salvo e continua ao reabrir.
- **Novo hábito.** Uma folha pede nome e categoria e cria o hábito na hora.

## Visual e movimento

- **Tema escuro** com Material 3 e superfícies translúcidas.
- **Anel** com cápsula rosa na ponta e brilho pulsante de cerca de 2,2 s.
- **Dock flutuante** em vidro líquido, arrastável, com encaixe por mola na aba
  mais próxima.
- **Lente do dock** menor em repouso; cresce com halo ao segurar ou arrastar.
- **Rótulos do dock** somem ao descer a página e voltam ao subir.
- **Rolagem com profundidade:** cards e blocos esmaecem e reduzem a escala ao
  sair pelo topo, de forma proporcional e reversível.
- **Entrada escalonada** dos cards e contagem animada dos números.
- **Fonte Inter** empacotada em `assets/fonts/Inter.ttf`, sem download em tempo de
  execução.
- **"Reduzir movimento":** com a opção do sistema ativa, as animações ficam
  estáticas.

## Dados e ajustes

- **Armazenamento local** em `shared_preferences`, via `HabitRepository`. A UI
  nunca acessa o storage diretamente.
- **Persistência** de hábitos, dias concluídos, sequência, período, categoria,
  frase do dia e estado de recolhimento.
- **Atualizações** abre o histórico completo de versões, com a versão instalada
  aberta e as anteriores recolhidas.
- **Apagar todos os dados** em Ajustes, com diálogo que
  informa quantos hábitos serão removidos.
- **O que há de novo** aparece uma vez por versão, com a lista completa
  da versão instalada. Nunca aparece na primeira
  instalação.
- **Enviar feedback** abre o formulário de issues do repositório no navegador.
- **Versão do app** no rodapé de Ajustes.

## Limites conhecidos

- Não há importação de outros apps.
- Não há lembretes nem notificações.
- Não há widget de tela inicial.
- Não há conta, sincronização ou backup automático.

## Em breve

- Tela dedicada de criação de hábito, com recorrência, meta semanal, ícone e cor.
- Lembretes por hábito, nos dias escolhidos.
- Backup manual em um arquivo guardado por você.
