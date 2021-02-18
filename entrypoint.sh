#!/usr/bin/env bash

# exit on error
set -o errexit
# trap Ctrl + c
#trap ctrl_c INT

function main() {
    local __invalid_options=0

    # TODO validate options

    if [[ $__invalid_options -le 0 ]]; then
        run_server
    else
        "fix your settings"
    fi

    finish
}

function run_server() {
    cd /valheim
    export templdpath=$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
    export SteamAppId=892970

    ./valheim_server.x86_64 \
        -nographics \
        -batchmode \
        -name ${VALHEIM_SERVER_NAME} \
        -port 2456 \
        -world ${VALHEIM_SERVER_WORLD} \
        -password ${VALHEIM_SERVER_PASSWORD} \
        -public ${VALHEIM_SERVER_PUBLIC}
}

function finish() {
    exit $?
}

if [[ "${0}" == "${BASH_SOURCE}" ]]; then
    main
fi
