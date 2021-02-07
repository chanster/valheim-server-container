#!/usr/bin/env bash

set -x
set -e

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

# get location of Valheim server files.
__valheim_server="${VALHEIM_SERVER_PATH:-${HOME}/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/common/Valheim dedicated server}"

# start with base Ubuntu
__base=$(buildah from docker.io/ubuntu:20.04)

# install requirements
buildah config --env "DEBIAN_FRONTEND=noninteractive" "${__base}"
buildah run "${__base}" /bin/bash -c "dpkg --add-architecture i386 && apt-get update && apt-get install -y --no-install-recommends libsdl2-2.0-0:i386 ca-certificates"

__baseMount="$(buildah mount ${__base})"
cp -r "${__valheim_server}" "${__baseMount}/"
buildah run "${__base}" /bin/bash -c "mv /Valheim\ dedicated\ server /valheim"
cp "${__dir}/entrypoint.sh" "${__baseMount}/entrypoint.sh"

buildah run "${__base}" /bin/bash -c "useradd -s /bin/bash -d /valheim valheim && chown -R valheim:valheim /valheim"

# Set ENV defaults
buildah config --env VALHEIM_SERVER_NAME="Valheim-Container" "${__base}"
buildah config --env VALHEIM_SERVER_WORLD="Valheim-Test" "${__base}"
buildah config --env VALHEIM_SERVER_PASSWORD="valheim" "${__base}"
buildah config --port 2456/tcp "${__base}"
buildah config --port 2457/tcp "${__base}"
buildah config --port 2458/tcp "${__base}"
buildah config --port 2456/udp "${__base}"
buildah config --port 2457/udp "${__base}"
buildah config --port 2458/udp "${__base}"

# set working dir
buildah config --workingdir "/valheim" "${__base}"
# copy entrypoint
buildah config --entrypoint "/entrypoint.sh" "${__base}"
# set user
buildah config --user "valheim" "${__base}"

buildah commit "${__base}" valheim:latest
