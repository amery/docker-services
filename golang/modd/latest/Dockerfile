FROM amery/docker-golang-base:latest

# modd
RUN go install -v github.com/cortesi/modd/cmd/...@latest && \
	cp bin/modd root/ && \
	touch root/etc/modd.conf

FROM scratch
COPY --from=0 /go/root /
USER nobody
ENTRYPOINT [ "/modd", "-f", "/etc/modd.conf" ]
