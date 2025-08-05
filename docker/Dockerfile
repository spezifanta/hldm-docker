FROM debian:trixie-slim

ARG RELEASE_DATE=2025-07-12
ARG COMMIT_ID=unknown

ENV VERSION=2025.8
ENV RELEASE_DATE=${RELEASE_DATE}
ENV COMMIT_ID=${COMMIT_ID}
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Update base image and install dependencies.
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        rsync \
        libc6:i386 \
        libstdc++6:i386 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && groupadd -r steam && useradd -r -g steam -m -d /opt/steam steam \
    && mkdir /gamedir

USER steam
WORKDIR /opt/steam
COPY ./hldm.install /opt/steam

# Download SteamCMD, install HLDM, fix steamclient.so and reduce image size.
RUN curl -sL --fail https://media.steampowered.com/client/installer/steamcmd_linux.tar.gz | tar xzvf - \
    && ldd /opt/steam/linux32/steamcmd \
    && ./steamcmd.sh +runscript hldm.install \
    && rm -fr /opt/steam/hldm/cstrike /opt/steam/hldm/siteserverui /opt/steam/hldm/linux64 \
    && mkdir -p $HOME/.steam \
    && ln -s /opt/steam/linux32 $HOME/.steam/sdk32 \
    && echo 70 > /opt/steam/hldm/steam_appid.txt

WORKDIR /opt/steam/hldm

# Copy configs, Metamod, Stripper2 and AMX.
COPY --chown=steam:steam gamedir valve/
COPY --chown=steam:steam ./entrypoint.sh ./entrypoint.sh

# Expose ports
EXPOSE 27015 27015/udp

# Start server.
ENTRYPOINT ["./entrypoint.sh", "-timeout 3"]

# Default start parameters.
CMD ["+maxplayers 12", "+map crossfire"]

# Labels
LABEL vendor=steamcalculator.com \
    hldm.docker.version="${VERSION}" \
    hldm.docker.release-date="${RELEASE_DATE}" \
    hldm.docker.commit-id="${COMMIT_ID}"
