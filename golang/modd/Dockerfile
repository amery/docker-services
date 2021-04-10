FROM amery/docker-golang-base:latest

# modd
RUN go get -v github.com/cortesi/modd/cmd/... && \
	cp bin/modd root/

# FROM scratch
# COPY --from=0 /go/root/* /
# USER nobody
# ENTRYPOINT [ "/modd", "-f", "/etc/modd.conf" ]
