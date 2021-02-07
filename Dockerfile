# stage - steamcmd
##################
FROM docker.io/cm2network/steamcmd:latest as steamcmd

# download Valheim dedicated server
RUN ./steamcmd.sh +quit \
    && ./steamcmd.sh +login anonymous +app_update 896660 validate +quit

# stage - valheim
#################
FROM docker.io/ubuntu:20.04 AS valheim

# install dependencies
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --no-install-recommends libsdl2-2.0-0:i386 ca-certificates && apt-get clean

# create service account
RUN useradd -s /bin/bash -d /valheim valheim

# copy entrypoint
COPY entrypoint.sh /entrypoint.sh

# copy valheim files
ARG src="/home/steam/Steam/steamapps/common/Valheim dedicated server"
COPY --from=steamcmd ${src} /valheim
COPY --from=steamcmd ${src} /valheim
RUN chown -R valheim:valheim /valheim

# create ENVs
ENV VALHEIM_SERVER_NAME="Valheim Container"
ENV VALHEIM_SERVER_WORLD="Valheim Test"
ENV VALHEIM_SERVER_PASSWORD=valheim
ENV VALHEIM_SERVER_PUBLIC=1

# expose ports
EXPOSE 2456-2458/tcp
EXPOSE 2456-2458/udp
WORKDIR /valheim
USER valheim

ENTRYPOINT [ "/entrypoint.sh" ]
