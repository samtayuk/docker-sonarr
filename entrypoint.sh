#!/bin/bash
set -e

echo "checking config.xml"
if [ ! -f /config/config.xml ]; then
	echo "config.xml doesn't exist. creating default config.xml"
	echo "<Config><UrlBase></UrlBase><Branch>master</Branch></Config>" > /config/config.xml
fi

echo "setting UrlBase from env"
xmlstarlet ed -L -u "/Config/UrlBase" -v $VIRTUAL_LOCATION /config/config.xml

exec "$@"
