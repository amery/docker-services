# vim: set ft=dockerfile ts=4 sw=4 et:
FROM alpine:latest
MAINTAINER Alejandro Mery <amery@linux.com>

# Install Supervisor
RUN apk --update upgrade -U && apk --no-cache add \
        supervisor

RUN mkdir -p \
    /etc/entrypoint.d \
    /etc/supervisor.d \
    /var/log/supervisor

COPY supervisord.conf /etc/
COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
