FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
RUN apt-get update && apt-get install -y \
  unzip \
  wget 

WORKDIR /tmp
RUN git clone https://github.com/neo-ngd/neo-node.git
WORKDIR /tmp/neo-node/
RUN git checkout jiuquan
WORKDIR /tmp/neo-node/neo-cli/
RUN dotnet restore && dotnet publish -c Release -o /neo-cli

WORKDIR /neo-cli/Plugins

WORKDIR /tmp
RUN git clone https://github.com/neo-ngd/neo-plugins.git
WORKDIR /tmp/neo-plugins
RUN git checkout jiuquan

WORKDIR /tmp/neo-plugins/src/LevelDBStore
RUN dotnet publish -o publish
RUN cp -rf publish/LevelDBStore.dll /neo-cli/Plugins/

WORKDIR /tmp/neo-plugins/src/DBFTPlugin
RUN dotnet publish -o publish
RUN cp -rf publish/DBFTPlugin publish/DBFTPlugin.dll /neo-cli/Plugins/

WORKDIR /tmp/neo-plugins/src/ApplicationLogs
RUN dotnet publish -o publish
RUN cp -rf publish/ApplicationLogs publish/ApplicationLogs.dll /neo-cli/Plugins/

WORKDIR /tmp/neo-plugins/src/RpcServer
RUN dotnet publish -o publish
RUN cp -rf publish/RpcServer publish/RpcServer.dll /neo-cli/Plugins/

WORKDIR /tmp/neo-plugins/src/StateService
RUN dotnet publish -o publish
RUN cp -rf publish/StateService publish/StateService.dll publish/MPTTrie.dll /neo-cli/Plugins/

WORKDIR /tmp/neo-plugins/src/TokensTracker
RUN dotnet publish -o publish
RUN cp -rf publish/TokensTracker publish/TokensTracker.dll /neo-cli/Plugins/

FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS final
RUN apt-get update && apt-get install -y \
  screen \
  libleveldb-dev \
  sqlite3
RUN rm -rf /var/lib/apt/lists/*

COPY --from=build /neo-cli/ /neo-cli/

WORKDIR /neo-cli
COPY start.sh ./
RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]
