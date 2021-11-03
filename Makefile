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

# Build each project under services/*

services = $(wildcard services/*)

.PHONY: $(services)
$(services):
	$(MAKE) -C $@ build

.PHONY: build
build: $(services)

# Build Docker images

services_docker = $(foreach svc,$(services),$(svc).docker.build)

.PHONY: docker
docker: $(services_docker)

.PHONY: $(services_docker)
$(services_docker): %.docker.build: %
	$(MAKE) -C $< docker.build

.PHONY: docker.build
docker.build: $(services_docker)

# Deploy and Undeploy

## Docker Compose
.PHONY: deploy.docker
deploy.docker: undeploy.docker docker.build
	$(MAKE) -C deploy/platform/docker deploy

.PHONY: undeploy.docker
undeploy.docker:
	$(MAKE) -C deploy/platform/docker undeploy
