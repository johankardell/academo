FROM mcr.microsoft.com/dotnet/aspnet:8.0.2 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 9090

FROM mcr.microsoft.com/dotnet/sdk:8.0.200 AS build
WORKDIR /src
COPY ["externalapi.csproj", "."]
RUN dotnet restore "./externalapi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "externalapi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "externalapi.csproj" -c Release -o /app/publish

FROM base AS final
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y
WORKDIR /app
ENV APP_VERSION=$DOCKER_TAG
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "externalapi.dll"]