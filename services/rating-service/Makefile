# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

include ../../Makefile.in

.PHONY: build
build:

.PHONY: docker docker.build docker.push

docker: docker.build

docker.build:
	docker build --build-arg SW_AGENT_GO_IMAGE=${SW_AGENT_GO_IMAGE} . -t $(HUB)/rating-service:$(TAG)
	docker build . -t $(HUB)/rating-service:$(TAG)-agentless -f Dockerfile.agentless

docker.push: docker.build
	docker push $(HUB)/rating-service:$(TAG)
	docker push $(HUB)/rating-service:$(TAG)-agentless
