// Licensed to Apache Software Foundation (ASF) under one or more contributor
// license agreements. See the NOTICE file distributed with
// this work for additional information regarding copyright
// ownership. Apache Software Foundation (ASF) licenses this file to you under
// the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/SkyAPM/go2sky"
	httpp "github.com/SkyAPM/go2sky/plugins/http"
	"github.com/SkyAPM/go2sky/reporter"
)

var url string

func init() {
	if v, ok := os.LookupEnv("URL"); ok {
		url = v
	} else {
		url = "http://openfunction.io.svc.cluster.local/default/function1"
	}
}

func main() {
	// Obtained by SW_AGENT_COLLECTOR_BACKEND_SERVICES
	r, err := reporter.NewGRPCReporter("")
	if err != nil {
		log.Fatal(err)
	}
	defer r.Close()

	tracer, err := go2sky.NewTracer("function-load-gen", go2sky.WithReporter(r))
	if err != nil {
		log.Fatalf("create tracer error %v \n", err)
	}

	client, err := httpp.NewClient(tracer)

	for {
		// call end service
		request, err := http.NewRequest("GET", url, nil)
		if err != nil {
			log.Fatalf("unable to create http request: %+v\n", err)
		}
		res, err := client.Do(request)
		if err != nil {
			log.Fatalf("unable to do http request: %+v\n", err)
		}
		body, err1 := ioutil.ReadAll(res.Body)
		if err1 != nil {
			log.Println(err1)
		}
		_ = res.Body.Close()
		fmt.Println(string(body))
		time.Sleep(time.Second)
	}
}
