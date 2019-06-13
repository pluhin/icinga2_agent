FROM alpine:latest

LABEL maintainer="pluhin@gmail.com"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
	&& apk update \
	&& apk add icinga2 bash \
	&& /usr/sbin/icinga2 feature enable command checker mainlog notification \
	&& /usr/sbin/icinga2 api setup

VOLUME [ "/etc/icinga2", "/var/lib/icinga2" ]

HEALTHCHECK \
  --interval=5s \
  --timeout=2s \
  --retries=12 \
  --start-period=10s \
CMD ps ax | grep -v grep | grep -c "/usr/lib/icinga2/sbin/icinga2" || exit 1

EXPOSE 5665
