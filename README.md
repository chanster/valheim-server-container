# Valheim Server Container

A Containerized Dedicated game server for Valheim

## Requirements
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
| `VALHEIM_SERVER_PORT` | Port to bind to | `2456` |
| `VALHEIM_SERVER_WORLD` | World to run. Will create if world doesn't exists | `Valheim-Test` |
| `VALHEIM_SERVER_PASSWORD` | Server password | `valheim` |

Example
```bash
podman run \
    --env VALHEIM_SERVER_NAME="my.server.com" \
    --env VALHEIM_SERVER_PORT=32567
    --env VALHEIM_SERVER_WORLD="valheimville"
    --env VALHEIM_SERVER_PASSWORD="my secret password"
    localhost/valheim:latest
```
