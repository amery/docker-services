FROM golang:alpine

# disable CGO and rebuild
ENV CGO_ENABLED=0
RUN go install -v -a ...
