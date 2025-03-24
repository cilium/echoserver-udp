# cilium/echoserver-udp

A TFTP server with single-port support for testing UDP connectivity. It prints
the requested filename and client IP address in a similar to
[cilium/echoserver](https://github.com/cilium/echoserver/)

## Container Image

The container image is available on Quay: `quay.io/cilium/echoserver-udp`

## Example Usage

Start the server:
```console
./echoserver-udp

# Alternatively, start it on a non-privileged port:
./echoserver-udp -listen :6969

# Alternatively, with hostname:
HOSTNAME=deathstar ./echoserver-udp

# Alternatively, via Makefile
HOSTNAME=deathstar make run

# Alternatively, via container image:
docker run --rm -it --name echoserver-udp -p 69:69/udp quay.io/cilium/echoserver-udp
```

Example request:

```console
$ curl tftp://localhost:69/hello

Hostname: deathstar

Request Information:
	client_address=::1
	client_port=50797
	real path=/hello
	request_scheme=tftp
```

## Available Flags

```console
Usage of ./echoserver-udp:
  -listen string
        host:port pair to listen on (default ":69")
  -single-port
        use single UDP port (default true)
```
