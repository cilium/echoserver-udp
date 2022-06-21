# cilium/echoserver-udp

A TFTP server with single-port support for testing UDP connectivity. It prints
the requested filename and client IP address in a similar to
[cilium/echoserver](https://github.com/cilium/echoserver/)

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
