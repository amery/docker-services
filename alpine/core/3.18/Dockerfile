# vim: set ft=dockerfile ts=4 sw=4 et:
FROM alpine:3.18
LABEL org.opencontainers.image.authors="Alejandro Mery <amery@apptly.co>" \
    org.opencontainers.image.source="https://github.com/amery/docker-services" \
    org.opencontainers.image.licenses="MIT"

# Install Supervisor, S6 and getent
RUN apk --update upgrade -U && apk --no-cache add \
    musl-utils \
    s6 \
    supervisor

RUN mkdir -p \
    /etc/entrypoint.d \
    /etc/supervisor.d \
    /var/log/supervisor

COPY run-user.sh /usr/bin/run-user
COPY supervisord.conf /etc/
COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
