// Copyright 2020 Authors of Cilium
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"flag"
	"log"
	"net"
	"os"
	"text/template"

	"pack.ag/tftp"
)

const response = `
Hostname: {{or .Hostname "N/A"}}

Request Information:
	client_address={{.ClientAddr}}
	client_port={{.ClientPort}}
	real path=/{{.File}}
	request_scheme=tftp

`

type values struct {
	Hostname string

	ClientAddr net.IP
	ClientPort int
	File       string
}

var hostname = os.Getenv("HOSTNAME")
var tmpl = template.Must(template.New("response").Parse(response))

func echoHandler(w tftp.ReadRequest) {
	log.Printf("Read %q requested from %s\n", w.Name(), w.Addr())
	err := tmpl.Execute(w, values{
		Hostname:   hostname,
		ClientAddr: w.Addr().IP,
		ClientPort: w.Addr().Port,
		File:       w.Name(),
	})

	if err != nil {
		w.WriteError(tftp.ErrCodeNotDefined, err.Error())
	}
}

func main() {
	var listen string
	var singlePort bool

	flag.StringVar(&listen, "listen", ":69", "host:port pair to listen on")
	flag.BoolVar(&singlePort, "single-port", true, "use single UDP port")
	flag.Parse()

	opts := tftp.ServerSinglePort(singlePort)
	server, err := tftp.NewServer(listen, opts)
	if err != nil {
		log.Fatal(err)
	}

	server.ReadHandler(tftp.ReadHandlerFunc(echoHandler))
	log.Printf("Listening on: %q\n", listen)
	log.Fatal(server.ListenAndServe())
}
