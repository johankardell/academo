FROM mcr.microsoft.com/dotnet/aspnet:8.0.10 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 9090

FROM mcr.microsoft.com/dotnet/sdk:8.0.403 AS build
WORKDIR /src
COPY ["internalapi.csproj", "."]
RUN dotnet restore "./internalapi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "internalapi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "internalapi.csproj" -c Release -o /app/publish

FROM base AS final
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y
WORKDIR /app
ENV APP_VERSION=$DOCKER_TAG
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "internalapi.dll"]