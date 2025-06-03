#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
# Clone the source code from GitHub
RUN git clone https://github.com/ArneDecker3v08mk/MicroHack-AppServiceToContainerAppStart.git .
RUN dotnet restore "./MicroHackApp.csproj"
RUN dotnet build "./MicroHackApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MicroHackApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MicroHackApp.dll"]
