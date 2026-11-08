# Instalação

← [Voltar ao README](../README.md)

O Alva não está na Play Store. Ele é distribuído como APK na página de
[Releases](https://github.com/dexthw/alva/releases) do repositório.

## Requisitos

- Android 7.0 (API 24) ou superior.
- Cerca de 60 MB livres para instalar e atualizar.
- Nenhuma permissão especial: o APK de release não pede acesso à internet.

## Arquivos de cada release

| Arquivo                   | Para                                  |
| ------------------------- | ------------------------------------- |
| `Alva-vX.Y.Z.apk`         | O app em si                           |
| `Alva-vX.Y.Z.apk.sha256`  | Conferir se o download chegou inteiro |

## Passo a passo

1. Abra a página de [Releases](https://github.com/dexthw/alva/releases) no
   celular e escolha a versão mais recente.
2. Baixe o `Alva-vX.Y.Z.apk`. Se o navegador avisar sobre o tipo de arquivo,
   confirme o download.
3. Abra o arquivo baixado (notificações ou pasta **Downloads**).
4. Na primeira instalação, o Android pede para permitir apps de fontes
   desconhecidas. Autorize o navegador ou o gerenciador de arquivos que fez o
   download e volte ao instalador.
5. Toque em **Instalar** e depois em **Abrir**.

## Onde fica "fontes desconhecidas"

- **Android 8 ou superior:** **Configurações → Apps → Acesso especial →
  Instalar apps desconhecidos** e escolha o app que abriu o APK.
- **Android 7:** **Configurações → Segurança → Fontes desconhecidas**.

## Atualizar

Instale o APK novo por cima do atual. Hábitos, histórico e preferências são
preservados. Se o Android recusar a instalação, confira se o app instalado veio
do mesmo arquivo e mesma assinatura.

## Conferir o checksum (opcional)

No computador, na pasta do download:

```bash
sha256sum -c Alva-vX.Y.Z.apk.sha256
```

A saída esperada é `OK`. Se der `FAILED`, baixe o APK de novo.

## Desinstalar

Desinstalar apaga todos os dados do app; não há cópia em servidor. Se quiser
recomeçar sem desinstalar, use **Ajustes → Apagar todos os dados**.

## Problemas comuns

| Sintoma                              | O que fazer                                            |
| ------------------------------------ | ------------------------------------------------------ |
| "App não instalado"                  | Desinstale a versão anterior e instale de novo         |
| Instalador não abre                  | Use um gerenciador de arquivos em vez do navegador     |
| Play Protect avisa sobre o APK       | É esperado fora da loja; escolha "Instalar mesmo assim" |
| Versão antiga continua aparecendo    | Confira a versão no rodapé de Ajustes                  |
