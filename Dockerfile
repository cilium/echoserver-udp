FROM golang:1.22.2-alpine3.19 as builder
WORKDIR /go/src/app
COPY . .
RUN go build -o echoserver-tftp .

FROM alpine:3.19.1
COPY --from=builder /go/src/app/echoserver-tftp /usr/bin/echoserver-tftp
ENTRYPOINT ["/usr/bin/echoserver-tftp"]
