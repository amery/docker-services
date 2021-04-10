FROM golang:alpine

# disable CGO and rebuild
ENV CGO_ENABLED=0
RUN go install -v -a ...

# prepare scratch root
RUN rm -rf root && \
	mkdir root root/etc root/bin root/data root/tmp && \
	chmod 01777 root/tmp && \
	cp /etc/passwd root/etc/

# FROM scratch
# COPY --from=0 /go/root /
# USER nobody
