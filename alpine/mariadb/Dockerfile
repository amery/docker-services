# vim: set ft=dockerfile ts=4 sw=4 et:
FROM amery/docker-alpine-core:latest
MAINTAINER Alejandro Mery <amery@linux.com>

# Install MariaDB
RUN apk --update upgrade -U && apk --no-cache add \
    mariadb \
    pwgen

EXPOSE 3306

COPY mysql.sh /etc/entrypoint.d/
COPY my.cnf /etc/my.cnf.d/mysql.cnf
COPY supervisord.conf /etc/supervisor.d/mysqld.conf

VOLUME [ "/var/lib/mysql" ]
