# jiuquan-build

## Build

```bash
docker build -t jiuquan:v1.2.0 .
```

## Run

```bash
docker run -v `pwd`/ApplicationLogs:/neo-cli/Plugins/ApplicationLogs \
    -v `pwd`/DBFTPlugin:/neo-cli/Plugins/DBFTPlugin \
    -v `pwd`/RpcServer:/neo-cli/Plugins/RpcServer \
    -v `pwd`/StateService:/neo-cli/Plugins/StateService \
    -v `pwd`/TokensTracker:/neo-cli/TokensTracker \
    -v `pwd`/config.json:/neo-cli/config.json \
    -v `pwd`/data:/data \
    -d --name jiuquan-node jiuquan:v1.2.0

```
