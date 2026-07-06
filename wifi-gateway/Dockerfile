FROM ghcr.io/home-assistant/aarch64-base:latest

RUN apk add --no-cache \
    iptables \
    dnsmasq \
    iproute2

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
