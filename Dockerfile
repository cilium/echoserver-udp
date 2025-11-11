FROM golang:1.25.3-alpine3.21 as builder
WORKDIR /go/src/app
COPY . .
RUN go build -o echoserver-tftp .

FROM alpine:3.22.2
COPY --from=builder /go/src/app/echoserver-tftp /usr/bin/echoserver-tftp
ENTRYPOINT ["/usr/bin/echoserver-tftp"]
