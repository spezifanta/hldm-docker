#!/usr/bin/env sh

if [ -d /tmp/gamedir ]
then
  echo Found additional files, syncing...
  rsync --chown=steam:steam /tmp/gamedir/* /opt/steam/hldm/valve
fi

export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"

echo "Starting HLDS Docker ${VERSION} (${RELEASE_DATE}/${COMMIT_ID})..."
./hlds_linux "${@}"
