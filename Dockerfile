FROM alpine:edge
MAINTAINER Samuel Taylor "samtaylor.uk@gmail.com"

ENV SONARR_VERSION 2.0.0.4645

RUN apk add --no-cache mono sqlite-libs --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
   && apk add --no-cache --virtual=.build-dependencies wget tar gzip \
   && mkdir /app \
   && cd /app \
   && wget "http://download.sonarr.tv/v2/master/mono/NzbDrone.master.$SONARR_VERSION.mono.tar.gz" -O "/tmp/sonarr.tar.gz" \ 
   && tar -xf "/tmp/sonarr.tar.gz" \ 
   && apk del .build-dependencies \
   && rm /tmp/*

EXPOSE 8989
VOLUME ["/config"]

CMD ["mono", "/app/NzbDrone/NzbDrone.exe", "--no-browser", "-data=/config"]
