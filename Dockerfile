FROM golang:1.27.1-alpine3.24 as builder
WORKDIR /go/src/app
COPY . .
RUN go build -o echoserver-tftp .

FROM alpine:3.24.2
COPY --from=builder /go/src/app/echoserver-tftp /usr/bin/echoserver-tftp
ENTRYPOINT ["/usr/bin/echoserver-tftp"]
