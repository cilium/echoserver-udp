FROM golang:1.13.7-alpine as builder
WORKDIR /go/src/app
COPY . .
RUN go build -o echoserver-tftp .

FROM alpine:3.11
COPY --from=builder /go/src/app/echoserver-tftp /usr/bin/echoserver-tftp
ENTRYPOINT ["/usr/bin/echoserver-tftp"]
