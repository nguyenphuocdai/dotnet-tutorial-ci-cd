FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5077

ENV ASPNETCORE_URLS=http://+:5077

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["myWebApp.csproj", "./"]
RUN dotnet restore "myWebApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "myWebApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "myWebApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "myWebApp.dll"]
