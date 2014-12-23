FROM debian:wheezy
MAINTAINER Samuel Taylor "samtaylor.uk@gmail.com"

# To get rid of error messages like "debconf: unable to initialize frontend: Dialog":
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# use sonarr master branch, user can change branch and update within sonarr
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC \
  && echo "deb http://apt.sonarr.tv/ develop main" | tee -a /etc/apt/sources.list \
  && apt-get update -q \
  && apt-get install -qy nzbdrone xmlstarlet \
  ; apt-get clean \
  ; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN chown -R nobody:users /opt/NzbDrone \
  ; mkdir -p /volumes/config/sonarr /volumes/completed /volumes/media \
  && chown -R nobody:users /volumes

EXPOSE 8989
VOLUME /volumes/config
VOLUME /volumes/completed
VOLUME /volumes/media

ADD start.sh /
RUN chmod +x /start.sh

ADD sonarr-update.sh /sonarr-update.sh
RUN chmod 755 /sonarr-update.sh \
  && chown nobody:users /sonarr-update.sh

USER nobody
WORKDIR /opt/NzbDrone

CMD ["/start.sh"]
