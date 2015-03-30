#!/bin/bash

function handle_signal {
  PID=$!
  echo "received signal. PID is ${PID}"
  kill -s SIGHUP $PID
}

trap "handle_signal" SIGINT SIGTERM SIGHUP

echo "checking config.xml"
if [ ! -f /config/config.xml ]; then
	echo "config.xml doesn't exist. creating default config.xml"
	echo "<Config><UrlBase></UrlBase><Branch>master</Branch></Config>" > /config/config.xml
fi

echo "setting UrlBase from env"
xmlstarlet ed -L -u "/Config/UrlBase" -v $VIRTUAL_LOCATION /config/config.xml

echo "starting sonarr"
mono /opt/NzbDrone/NzbDrone.exe --no-browser -data=/config & wait
echo "stopping sonarr"
