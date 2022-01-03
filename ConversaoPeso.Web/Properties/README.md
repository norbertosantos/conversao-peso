# CONVERSÃO PESO

Esta aplicação foi escrita em .Net e faz parte do desafio Docker da Formação Kubedev.

## Passos para a construção da imagem:

Para a construção desta imagem foi usada uma técnica de Multistage Building que consiste em primeiro realizar o processo de compilação do código da aplicação e depois do código compilado, copiá-lo para uma imagem de tamanho menor.

**1) Apontar a imagem do Dotnet Sdk que será usada pela solução e nomear essa primeira etapa de construção como build.**
```docker
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
```
**2) Criar o diretório de trabalho da nossa imagem.**

```docker
WORKDIR /source
```
**3) Copiar o arquivo de solution da nossa aplicação para dentro do diretório de trabalho da nossa imagem.**

```docker
COPY ConversaoPeso.sln .
```
**4) Copiar o arquivo fonte do nosso projeto para dentro do diretório semelhante dentro da nossa imagem.**

```docker
COPY ConversaoPeso.Web/ConversaoPeso.Web.csproj ./ConversaoPeso.Web/ConversaoPeso.Web.csproj
```

**5) Executar o comando para restaurar as dependências e ferramentas especificadas no arquivo do projeto da nossa aplicação.**

```docker
RUN dotnet restore
```
**6) Copiar o arquivo da nossa aplicação compilado para dentro do diretório de trabalho da nossa imagem.**

```docker
COPY ConversaoPeso.Web/. ./ConversaoPeso.Web/
```
**7) Criando um diretório dentro da nossa imagem para receber o arquivo executável do nosso projeto.**

```docker
WORKDIR /source/ConversaoPeso.Web
```

**8) Publicar a nossa aplicação em uma pasta para uma posterior implantação.**

```docker
RUN dotnet publish -c release -o /source/bin/ConversaoPeso.Web --no-restore
```
**9) Após realizarmos a etapa de construção da nossa aplicação através da estratégia multistage build. Vamos apontar qual será a imagem base a ser usada para implantar a nossa aplicação a partir da etapa de construção.**

```docker
FROM mcr.microsoft.com/dotnet/aspnet:5.0
```
**10) Vamos especificar o nosso diretório de trabalho dentro da imagem que vai implantar a nossa aplicação após a construção.**

```docker
WORKDIR /app
```
**11) Vamos copiar a nossa aplicação construida na etapa de build para o diretório source dentro da nossa imagem de implantação.**

```docker
COPY --from=build /source/bin/ConversaoPeso.Web ./
```
**12) Executar a nossa aplicação ao iniciar a nossa imagem de implantação.**

```docker
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll" ]
```