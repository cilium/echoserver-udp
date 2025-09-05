FROM golang:1.25.1-alpine3.21 as builder
WORKDIR /go/src/app
COPY . .
RUN go build -o echoserver-tftp .

FROM alpine:3.21.3
COPY --from=builder /go/src/app/echoserver-tftp /usr/bin/echoserver-tftp
ENTRYPOINT ["/usr/bin/echoserver-tftp"]
