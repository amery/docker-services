# vim: set ts=4 sw=4 et:
FROM alpine:latest
MAINTAINER Alejandro Mery <amery@linux.com>

# Install Supervisor
RUN apk upgrade -U \
    && apk --update add \
        supervisor \
    && rm -rf /var/cache/apk/*

COPY supervisord.conf /etc/

ENTRYPOINT [ "/usr/bin/supervisord" ]
