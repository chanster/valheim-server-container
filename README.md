# Valheim Server Container

A Containerized Dedicated game server for Valheim

**Note** these scripts are only for Linux. It was tested on `Ubuntu 20.04`.

## Requirements
- podman or docker

## Building Container

Docker
```
docker build -t valheim:latest .
```

Podman
```
podman build -t valheim:latest .
```

## Running Container

```bash
mkdir valheim && chmod 777 valheim

podman run \
    --env VALHEIM_SERVER_NAME=my.server.com \
    --env VALHEIM_SERVER_WORLD=valheimville \
    --env VALHEIM_SERVER_PASSWORD=my_secret_password \
    --port 2456-2458:2456-2458/tcp \
    --port 2456-2468:2456-2458/udp \
    --volume $(pwd)/valhiem:/valheim/.config/unity3d/IronGate/Valheim \
    localhost/valheim:latest
```

### Environmental Variables

| Variable | Description | Default |
| ---: | :--- | :---: |
| `VALHEIM_SERVER_NAME` | Valheim server name. This dispalys on the Valhiem Server List. | `Valheim-Container` |
| `VALHEIM_SERVER_WORLD` | World to run. Will create if world doesn't exists. See World files below. | `Valheim-Test` |
| `VALHEIM_SERVER_PASSWORD` | Server password | `valheim` |
| `VALHEIM_SERVER_PUBLIC` | Be shown in server list. `1` means yes, `0` means no. | `1` |

### Volumes and Files

Valheim keeps its data in `${HOME}/.config/unity3d/IronGate/Valheim/`. The container runs as user `valheim` with the home mapped to `/valheim`.

| File | Location | description |
| ---: | :--- | :--- |
| World | `/valheim/.config/unity3d/IronGate/Valheim/worlds/` | `${VALHEIM_SERVER_WORLD}.db` and `${VALHEIM_SERVER_WORLD}.fwl` |
| Admin List | `/valheim//.config/unity3d/IronGate/Valheim/adminlist.txt` | List admin players ID ONE per line |
| Banned List | `/valheim//.config/unity3d/IronGate/Valheim/adminlist.txt` | List banned players ID ONE per line |
| Permitted List | `/valheim//.config/unity3d/IronGate/Valheim/permittedlist.txt` | List permitted players ID ONE per line |
| Preferences | `/valheim//.config/unity3d/IronGate/Valheim/prefs` | `XML` file. Unsure of use yet |

Setup persistant data backend if you would like to keep your world between container re-creations.

Your mapped file structure should have simliar structure as the following
```
./valheim
|-- adminlist.txt
|-- bannedlist.txt
|-- permittedlist.txt
|-- prefs
`-- worlds
    |-- '${VALHEIM_SERVER_WORLD}.db'
    |-- '${VALHEIM_SERVER_WORLD}.db.old'
    |-- '${VALHEIM_SERVER_WORLD}.fwl'
    `-- '${VALHEIM_SERVER_WORLD}.fwl.old'
```

