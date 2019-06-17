FROM centos:7

LABEL maintainer="pluhin@gmail.com"

ENV ICINGA2_VERSION="2.10.4" \
    TIMEZONE="UTC" \
    ICINGA_API_PASS="QwertY_13" \
    ICINGA_LOGLEVEL=warning \
    ICINGA_FEATURES="api"
RUN rpm --import http://packages.icinga.org/icinga.key \
    && curl -sSL http://packages.icinga.org/epel/ICINGA-release.repo > /etc/yum.repos.d/ICINGA-release.repo \
    && yum -y install epel-release deltarpm  \
    && yum -y install \
      vim \
      wget \
      jq \
      net-tools \
      openssl \
      nagios-plugins* \
      perl-Crypt-Rijndael bc \
    && sed -i 's~nodocs~~g' /etc/yum.conf \
    && yum -y install \
      icinga2-$ICINGA2_VERSION \
    && chsh -s /bin/bash icinga \
    && su icinga -c 'cp /etc/skel/.bash* /var/spool/icinga2' \
    && chmod u+s /usr/bin/ping \
    && yum clean all && rm -rf /var/yum/cache \
    && localedef -f UTF-8 -i en_US en_US.UTF-8 \
    && wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 \
    && chmod +x /usr/local/bin/dumb-init

ADD content /

EXPOSE 5665

VOLUME [ "/var/lib/icinga2", "/etc/icinga2", "/tmp" ]

CMD ["/init/run.sh"]
