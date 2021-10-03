FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

COPY ConversaoPeso.sln .
COPY ConversaoPeso.Web/ConversaoPeso.Web.csproj ./ConversaoPeso.Web/ConversaoPeso.Web.csproj
RUN dotnet restore

COPY ConversaoPeso.Web/. ./ConversaoPeso.Web/
WORKDIR /source/ConversaoPeso.Web
RUN dotnet publish -c release -o /source/bin/ConversaoPeso.Web --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /source/bin/ConversaoPeso.Web ./
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll" ]
