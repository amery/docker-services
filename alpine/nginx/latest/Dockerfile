# vim: set ft=dockerfile ts=4 sw=4 et:
FROM amery/docker-alpine-core:latest
MAINTAINER Alejandro Mery <amery@linux.com>

ENV NGINX_VERSION 1.25.1
ENV NJS_VERSION   0.8.0
ENV PKG_RELEASE   1

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
    && KEY_SHA512="de7031fdac1354096d3388d6f711a508328ce66c168967ee0658c294226d6e7a161ce7f2628d577d56f8b63ff6892cc576af6f7ef2a6aa2e17c62ff7b6bf0d98 *stdin" \
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
COPY user_env /etc/entrypoint.d
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

EXPOSE 80
