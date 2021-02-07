# Valheim Server Container

A Containerized Dedicated game server for Valheim

**Note** these scripts are only for Linux. It was tested on `Ubuntu 20.04`.

## Requirements
- A copy of Valheim
- podman or kuberentes
- buildah

## Building Container

Build the container using username spaces.

```
buildah unshare ./valheim-build.sh
```

## Running Container

```
podman run localhost/valheim:latest
```

### Environmental Variables

| Variable | Description | Default |
| ---: | :--- | :---: |
| `VALHEIM_SERVER_NAME` | Valheim server name | `Valheim-Container` |
| `VALHEIM_SERVER_WORLD` | World to run. Will create if world doesn't exists | `Valheim-Test` |
| `VALHEIM_SERVER_PASSWORD` | Server password | `valheim` |

Example
```bash
podman run \
    --env VALHEIM_SERVER_NAME=my.server.com \
    --env VALHEIM_SERVER_WORLD=valheimville \
    --env VALHEIM_SERVER_PASSWORD="my_secret_password \
    --port 2456:2456/tcp \
    --port 2457:2457/tcp \
    --port 2458:2458/tcp \
    --port 2456:2456/udp \
    --port 2457:2457/udp \
    --port 2458:2458/udp \
    localhost/valheim:latest
```
