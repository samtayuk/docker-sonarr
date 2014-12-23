#!/bin/bash

function handle_signal {
  PID=$!
  echo "received signal. PID is ${PID}"
  kill -s SIGHUP $PID
}

trap "handle_signal" SIGINT SIGTERM SIGHUP

echo checking config.xml
if [ ! -f /volumes/config/sonarr/config.xml ]; then
	echo "config.xml doesn't exist. creating default config.xml"
	echo "<Config><UrlBase></UrlBase><UpdateMechanism>Script</UpdateMechanism><UpdateScriptPath>/sonarr-update.sh</UpdateScriptPath><Branch>develop</Branch></Config>" > /volumes/config/sonarr/config.xml
fi

echo setting UrlBase from env
xmlstarlet ed -L -u "/Config/UrlBase" -v $VIRTUAL_LOCATION /volumes/config/sonarr/config.xml

echo "starting sonarr"
mono /opt/NzbDrone/NzbDrone.exe --no-browser -data=/volumes/config/sonarr & wait
echo "stopping sonarr"
