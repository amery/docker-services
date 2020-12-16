# vim: set ft=dockerfile ts=4 sw=4 et:
FROM alpine:latest
MAINTAINER Alejandro Mery <amery@linux.com>

# Install Supervisor
RUN apk --update upgrade -U && apk --no-cache add \
        supervisor

COPY supervisord.conf /etc/

RUN mkdir -p /var/log/supervisor /etc/supervisor.d

ENTRYPOINT [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]
