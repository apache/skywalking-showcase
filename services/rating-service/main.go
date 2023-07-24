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
	"encoding/json"
	"log"
	"net/http"
)

type SongRating struct {
	ID     int     `json:"id"`
	Rating float64 `json:"rating"`
}

var data = []*SongRating{
	{1, 7.99},
	{2, 8.99},
	{3, 9.99},
	{4, 9.99},
}

func main() {
	http.HandleFunc("/rating", func(writer http.ResponseWriter, request *http.Request) {
		marshal, err := json.Marshal(data)
		if err != nil {
			log.Printf("format data error: %v", err)
			writer.Write([]byte("[]"))
			return
		}
		writer.Write(marshal)
	})

	if err := http.ListenAndServe(":80", nil); err != nil {
		log.Fatalf("rating service start error: %v \n", err)
	}
}
