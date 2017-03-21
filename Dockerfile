FROM ubuntu
#FROM alpine:edge
MAINTAINER Samuel Taylor "samtaylor.uk@gmail.com"

ENV SONARR_VERSION 2.0.0.4645

#RUN apk add --no-cache mono sqlite-libs libmediainfo --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
#   && apk add --no-cache --virtual=.build-dependencies wget tar gzip \
#   && mkdir /app \
#   && cd /app \
#   && wget "http://download.sonarr.tv/v2/master/mono/NzbDrone.master.$SONARR_VERSION.mono.tar.gz" -O "/tmp/sonarr.tar.gz" \ 
#   && tar -xf "/tmp/sonarr.tar.gz" \ 
#   && apk del .build-dependencies \
#   && rm /tmp/*
   
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
    echo "deb http://apt.sonarr.tv/ master main" > /etc/apt/sources.list.d/sonarr.list && \
    apt-get update && \
    apt-get install -y nzbdrone && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*


EXPOSE 8989
VOLUME ["/config"]

CMD ["mono", "/opt/NzbDrone/NzbDrone.exe", "--no-browser", "-data=/config"]
