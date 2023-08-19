FROM golang:1.20-alpine

# supervisord
#
ENV SUPERVISORD "0.7.3"

RUN apk --update upgrade -U && apk --no-cache add \
		gcc \
		git \
		musl-dev \
		&& \
	git clone -b "v${SUPERVISORD}" https://github.com/ochinchina/supervisord && \
	cd supervisord && \
	mkdir -p \
		root/sbin \
		root/etc/supervisor.d \
		root/var/run \
		root/var/log/supervisor \
		&& \
	go get -v ./... && \
	go get -v github.com/UnnoTed/fileb0x && \
	go generate && \
	env GOOS=linux CGO_ENABLED=1 \
		go build -tags release -a \
			-ldflags "-linkmode external -extldflags -static" \
			-o root/sbin/supervisord

COPY supervisord.conf root/etc/

FROM scratch
COPY --from=0 /go/supervisord/root /
USER nobody
ENTRYPOINT [ "/supervisord" ]
