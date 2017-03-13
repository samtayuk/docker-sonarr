FROM frolvlad/alpine-mono
MAINTAINER Samuel Taylor "samtaylor.uk@gmail.com"

ENV SONARR_VERSION 2.0.0.4645

RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates tar gzip \
   && mkdir /app \
   && cd /app \
   && wget "http://download.sonarr.tv/v2/master/mono/NzbDrone.master.$SONARR_VERSION.mono.tar.gz" -O "/tmp/sonarr.tar.gz" \ 
   && tar -xf "/tmp/sonarr.tar.gz" \ 
   && apk del .build-dependencies \
   && rm /tmp/*

EXPOSE 8989
VOLUME ["/config", "/data/shows", "/data/downloads"]

#ADD entrypoint.sh /
#RUN chmod +x /entrypoint.sh

WORKDIR /app/NzbDrone

#ENTRYPOINT ["/entrypoint.sh"]
CMD ["mono", "/app/NzbDrone/NzbDrone.exe", "--no-browser", "-data=/config"]
