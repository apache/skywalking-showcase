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
include scripts/make/help.mk

##@ Build targets
services = $(wildcard services/*)

.PHONY: $(services)
$(services):
	$(MAKE) -C $@ build

.PHONY: build
build: $(services) ## Build the services

services_docker = $(foreach svc,$(services),$(svc).docker.build)
.PHONY: docker
docker: $(services_docker) ## Build Docker images

.PHONY: $(services_docker)
$(services_docker): %.docker.build: %
	$(MAKE) -C $< docker.build

.PHONY: docker.build
docker.build: $(services_docker)

##@ Deploy targets

.PHONY: deploy.docker
deploy.docker: undeploy.docker ## Deploy the showcase with Docker Compose
	$(MAKE) -C deploy/platform/docker deploy

.PHONY: undeploy.docker
undeploy.docker: ## Undeploy the showcase from Docker Compose
	$(MAKE) -C deploy/platform/docker undeploy

.PHONY: deploy.kubernetes
deploy.kubernetes: undeploy.kubernetes ## Deploy the showcase to Kubernetes
	$(MAKE) -C deploy/platform/kubernetes deploy

.PHONY: undeploy.kubernetes
undeploy.kubernetes: ## Undeploy the showcase from Kubernetes
	$(MAKE) -C deploy/platform/kubernetes undeploy
