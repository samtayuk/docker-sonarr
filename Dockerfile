FROM ubuntu:14.04
MAINTAINER Samuel Taylor "samtaylor.uk@gmail.com"

ENV SONARR_VERSION 2.0.0.3594

# To get rid of error messages like "debconf: unable to initialize frontend: Dialog":
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# use sonarr master branch, user can change branch and update within sonarr
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC \
  && echo "deb http://apt.sonarr.tv/ master main" | tee -a /etc/apt/sources.list \
  && apt-get update -q \
  && apt-get install -qy nzbdrone=$SONARR_VERSION xmlstarlet \
  ; apt-get clean \
  ; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8989
VOLUME ["/config", "/data/shows", "/data/downloads"]

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

WORKDIR /opt/NzbDrone

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mono", "/opt/NzbDrone/NzbDrone.exe", "--no-browser", "-data=/config"]
