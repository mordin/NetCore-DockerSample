FROM microsoft/aspnetcore AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build AS build
WORKDIR /src
COPY *.sln ./
COPY NetCore-DockerSample/NetCore-DockerSample.csproj NetCore-DockerSample/
RUN dotnet restore

COPY . .
WORKDIR /src/NetCore-DockerSample
RUN dotnet build NetCore-DockerSample.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish NetCore-DockerSample.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "NetCore-DockerSample.dll"]
