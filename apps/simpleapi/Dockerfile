FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
EXPOSE 9090

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["simpleApi.csproj", "."]
RUN dotnet restore "./simpleApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "simpleApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "simpleApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
ENV APP_VERSION=$DOCKER_TAG
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "simpleApi.dll"]