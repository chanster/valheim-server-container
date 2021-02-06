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

# 
__baseMount="$(buildah mount ${__base})"
cp -r "${__valheim_server}" "${__baseMount}/"
buildah run "${__base}" /bin/bash -c "mv /Valheim\ dedicated\ server /valheim"
cp "${__dir}/entrypoint.sh" "${__baseMount}/entrypoint.sh"

# Set ENV defaults
buildah config --env VALHEIM_SERVER_NAME="Valheim-Container" "${__base}"
buildah config --env VALHEIM_SERVER_PORT="2456" "${__base}"
buildah config --env VALHEIM_SERVER_WORLD="Valheim-Test" "${__base}"
buildah config --env VALHEIM_SERVER_PASSWORD="valheim" "${__base}"

# set working dir
buildah config --workingdir "/valheim" "${__base}"
# copy entrypoint
buildah config --entrypoint "/entrypoint.sh" "${__base}"

buildah commit "${__base}" valheim:latest
