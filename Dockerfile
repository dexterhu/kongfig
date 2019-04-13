FROM golang:1.11-stretch@sha256:4dc37a26f694159e9063731cf4e37d1a8b4701199c3682f0c566840cd9ad1b87

WORKDIR /go/src/github.com/pagerinc/kongfig/
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOARM=6 go build -a -installsuffix cgo -ldflags '-w -s' -o kongfig

FROM alpine:3.9@sha256:28ef97b8686a0b5399129e9b763d5b7e5ff03576aa5580d6f4182a49c5fe1913

COPY --from=0 /go/src/github.com/pagerinc/kongfig/kongfig /go/kongfig

RUN apk add --no-cache tini
# Tini is now available at /sbin/tini
ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/go/kongfig", "--help"]