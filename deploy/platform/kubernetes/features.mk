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

# This file contains the targets to deploy features that are not
# applicable to deploy via manifest, we can deploy them via command
# line interface here, for better maintainability.

include ../../../Makefile.in

ifeq (, $(shell which istioctl))
	$(error "No istioctl in PATH, please make sure istioctl is available in PATH")
endif

.PHONY: istio
istio:
ifeq (, $(shell istioctl version | grep "control plane version"))
	$(info Istio control plane is not installed)
	$(eval install ?= true)
endif
ifeq (, $(shell istioctl version | grep "data plane version"))
	$(info Istio dataplane plane is not installed)
	$(eval install ?= true)
endif
	@if [ "$(install)" == "true" ]; then \
		echo "No Istio is installed, installing Istio..." ; \
		istioctl install -y --set profile=demo \
			--set meshConfig.enableEnvoyAccessLogService=true `# @feature: als; enable Envoy access log service` \
			--set meshConfig.defaultConfig.envoyAccessLogService.address=oap:11800 `# @feature: als; set ALS address to OAP so Envoy emits logs to OAP`; \
	fi
	@kubectl label namespace --overwrite $(NAMESPACE) istio-injection=enabled # @feature: als; label the namespace to allow Envoy sidecar injection

.PHONY: prerequisites
prerequisites: istio

feature-als:

.PHONY: deploy.feature-als
deploy.feature-als: prerequisites
	$(eval TAG := $(TAG)-agentless)
	$(MAKE) deploy FEATURE_FLAGS=agent

.PHONY: undeploy.feature-als
undeploy.feature-als:
	$(eval TAG := $(TAG)-agentless)
	$(MAKE) undeploy FEATURE_FLAGS=agent
