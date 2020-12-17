# vim: set ft=dockerfile ts=4 sw=4 et:
FROM amery/docker-alpine-core:latest
MAINTAINER Alejandro Mery <amery@linux.com>

ENV NGINX_VERSION 1.19.6
ENV NJS_VERSION   0.5.0
ENV PKG_RELEASE   1

# We will want NginX running under user www-data (id 82)
# We make sure www-data user and group exists
RUN apk add --no-cache musl-utils \
    && getent group www-data || addgroup -g 82 -S www-data \
    && getent passwd www-data || adduser -S -D -H -u 82 -h /var/www -s /sbin/nologin -G www-data -g www-data www-data


# The following will be installed from upstream:
# nginx nginx-module-xslt nginx-module-geoip nginx-module-image-filter nginx-module-njs
# First we make sure the keys are allright
RUN set -x \
    && nginxPackages=" \
        nginx=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-xslt=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-geoip=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-image-filter=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-njs=${NGINX_VERSION}.${NJS_VERSION}-r${PKG_RELEASE}" \
    && KEY_SHA512="e7fa8303923d9b95db37a77ad46c68fd4755ff935d0a534d26eba83de193c76166c68bfe7f65471bf8881004ef4aa6df3e34689c305662750c0172fca5d8552a *stdin" \
    && apk add --no-cache --virtual .cert-deps  openssl \
    && wget -O /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
    && if [ "$(openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout | openssl sha512 -r)" = "$KEY_SHA512" ]; then \
        echo "key verification succeeded!"; \
        mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/; \
    else \
        echo "key verification failed!"; \
        exit 1; \
    fi \
    && apk del .cert-deps \
    && apk add -X "https://nginx.org/packages/mainline/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" --no-cache $nginxPackages

# add nginx to supervisord
COPY 10-listen-on-ipv6-by-default.sh /etc/entrypoint.d
COPY 20-envsubst-on-templates.sh /etc/entrypoint.d
COPY supervisord.conf /etc/supervisor.d/nginx.conf
# We installed some nginx modules, if you need them please make sure that
# /etc/nginx/nginx.conf contains the required from the following lines:
#load_module modules/ngx_http_geoip_module.so;
#load_module modules/ngx_stream_geoip_module.so;
#load_module modules/ngx_http_image_filter_module.so;
#load_module modules/ngx_http_js_module.so;
#load_module modules/ngx_stream_js_module.so;
#load_module modules/ngx_http_xslt_filter_module.so;
