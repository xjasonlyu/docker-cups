FROM debian:buster-slim

LABEL MAINTAINER="xjasonlyu"

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    ca-certificates \
    sudo \
    locales \
    whois \
    cups \
    cups-client \
    cups-bsd \
    printer-driver-all \
    printer-driver-gutenprint \
    hpijs-ppds \
    hp-ppd  \
    hplip \
    printer-driver-foo2zjs \
  && useradd \
    --groups=sudo,lp,lpadmin \
    --create-home \
    --home-dir=/home/print \
    --shell=/bin/bash \
    --password=$(mkpasswd print) \
    print \
  && sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers \
  && apt-get clean autoclean -y \
  && apt-get autoremove -y \
  && rm -rf \
      /tmp/* \
      /var/lib/apt/lists/* \
      /var/tmp/*

COPY etc-cups/cupsd.conf /etc/cups/cupsd.conf

EXPOSE 631

ENTRYPOINT [ "/usr/sbin/cupsd", "-f" ]
