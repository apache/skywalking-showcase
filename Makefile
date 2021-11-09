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
	@$(MAKE) -C $@ build

.PHONY: build
build: $(services) ## Build the services if needed (e.g.: compiling Java files, build Go binary), do nothing if no need (e.g.: Python)

services_docker = $(foreach svc,$(services),$(svc).docker.build)
.PHONY: docker
docker: $(services_docker) ## Build Docker images

.PHONY: $(services_docker)
$(services_docker): %.docker.build: %
	@$(MAKE) -C $< docker.build

services_push = $(foreach svc,$(services),$(svc).docker.push)
.PHONY: push
push: $(services_push) ## Build and push Docker images

.PHONY: $(services_push)
$(services_push): %.docker.push: %
	@$(MAKE) -C $< docker.push

##@ Deploy targets

.PHONY: deploy.docker
deploy.docker: ## Deploy the showcase with Docker Compose
	@$(MAKE) -C deploy/platform/docker deploy

.PHONY: undeploy.docker
undeploy.docker: ## Undeploy the showcase from Docker Compose
	@$(MAKE) -C deploy/platform/docker undeploy

.PHONY: redeploy.docker
redeploy.docker: undeploy.docker deploy.docker

.PHONY: deploy.kubernetes
deploy.kubernetes: ## Deploy the showcase to Kubernetes
	@$(MAKE) -C deploy/platform/kubernetes deploy

.PHONY: undeploy.kubernetes
undeploy.kubernetes: ## Undeploy the showcase from Kubernetes
	@$(MAKE) -C deploy/platform/kubernetes undeploy

.PHONY: redeploy.kubernetes
redeploy.kubernetes: undeploy.kubernetes deploy.kubernetes
