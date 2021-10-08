FROM debian:stable-slim

ENV VERSION 1
ENV RELEASE_DATE 2018-11-17
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Add our user and group to make sure their IDs get assigned consitently.
RUN groupadd -r steam && useradd -r -g steam -m -d /opt/steam steam

# Update base image and install dependencies.
RUN dpkg --add-architecture i386 \
&& apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    libc6:i386 \
&& apt-get clean

USER steam
WORKDIR /opt/steam
COPY ./misc/hldm.install /opt/steam

# Download SteamCMD and install HLDM.
RUN curl -sL media.steampowered.com/client/installer/steamcmd_linux.tar.gz | tar xzvf - \
    && ldd /opt/steam/linux32/steamcmd && ./steamcmd.sh +runscript hldm.install

# Workaround, because steamcmd is not fully downloading HLDS, reset those files.
COPY ./misc/appmanifest_70.acf /opt/steam/hldm/steamapps/appmanifest_70.acf
COPY ./misc/appmanifest_90.acf /opt/steam/hldm/steamapps/appmanifest_90.acf

# Download HLDS again.
RUN ./steamcmd.sh +runscript hldm.install

# Fix error that steamclient.so is missing.
RUN mkdir -p $HOME/.steam \
    && ln -s /opt/steam/linux32 $HOME/.steam/sdk32

WORKDIR /opt/steam/hldm

# Remove warning on startup.
RUN echo 70 > steam_appid.txt

# Clean up.
RUN rm -fr cstrike

# Copy configs, Metamod and Stripper2.
COPY valve valve

EXPOSE 27015
EXPOSE 27015/udp

# Start server.
ENTRYPOINT ["./hlds_run", "-timeout 3"]

# Default start parameters.
CMD ["+maxplayers 12", "+map crossfire"]

# Labels
LABEL vendor=steamcalculator.com \
      hldm.docker.version="0.0.$VERSION" \
      hldm.docker.release-date="$RELEASE_DATE"
