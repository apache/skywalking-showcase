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

.PHONY: istioctl
istioctl:
	@istioctl version >/dev/null 2>&1 || (echo "No istioctl in PATH, please make sure istioctl is available in PATH."; exit 1)

.PHONY: istio
istio: istioctl
	@istioctl install -y --set profile=demo \
		--set meshConfig.enableEnvoyAccessLogService=true `# @feature: als; enable Envoy access log service` \
		`# @feature: als; be careful to only emit wanted metrics otherwise the traffic is HUGE` \
		--set 'meshConfig.defaultConfig.proxyStatsMatcher.inclusionRegexps[0]=.*membership_healthy.*' \
		--set 'meshConfig.defaultConfig.proxyStatsMatcher.inclusionRegexps[1]=.*upstream_cx_active.*' \
		--set 'meshConfig.defaultConfig.proxyStatsMatcher.inclusionRegexps[2]=.*upstream_cx_total.*' \
		--set 'meshConfig.defaultConfig.proxyStatsMatcher.inclusionRegexps[3]=.*upstream_rq_active.*' \
		--set 'meshConfig.defaultConfig.proxyStatsMatcher.inclusionRegexps[4]=.*upstream_rq_total.*' \
		--set 'meshConfig.defaultConfig.proxyStatsMatcher.inclusionRegexps[5]=.*upstream_rq_pending_active.*' \
		--set 'meshConfig.defaultConfig.proxyStatsMatcher.inclusionRegexps[6]=.*lb_healthy_panic.*' \
		--set 'meshConfig.defaultConfig.proxyStatsMatcher.inclusionRegexps[7]=.*upstream_cx_none_healthy.*' \
		--set meshConfig.defaultConfig.envoyMetricsService.address=$(BACKEND_SERVICE).$(NAMESPACE):11800 `# @feature: als; set MetricsService address to Backend Service so Envoy emits metrics to Backend Service` \
		--set meshConfig.defaultConfig.envoyAccessLogService.address=$(BACKEND_SERVICE).$(NAMESPACE):11800 `# @feature: als; set AccessLogService address to Backend Service so Envoy emits logs to Backend Service`

.PHONY: namespace
namespace:
	@kubectl get namespace $(NAMESPACE)-agentless > /dev/null 2>&1 || kubectl create namespace $(NAMESPACE)-agentless
	@kubectl label namespace --overwrite $(NAMESPACE)-agentless istio-injection=enabled # @feature: als; label the namespace to allow Istio sidecar injection

.PHONY: prerequisites
prerequisites: istio namespace

feature-als:

.PHONY: deploy.feature-als
deploy.feature-als: prerequisites
	$(MAKE) deploy FEATURE_FLAGS=agent TAG=$(TAG)-agentless NAMESPACE=$(NAMESPACE)-agentless AGENTLESS=true SHOW_TIPS=false

.PHONY: undeploy.feature-als
undeploy.feature-als: istioctl
	$(eval TAG := $(TAG)-agentless)
	$(MAKE) undeploy FEATURE_FLAGS=agent TAG=$(TAG)-agentless NAMESPACE=$(NAMESPACE)-agentless AGENTLESS=true
	istioctl x uninstall --purge -y

.PHONY: feature-mesh-with-agent
feature-mesh-with-agent:

.PHONY: deploy.feature-mesh-with-agent
deploy.feature-mesh-with-agent: prerequisites install-cert-manager
	@curl -Ls https://archive.apache.org/dist/skywalking/swck/${SWCK_OPERATOR_VERSION}/skywalking-swck-${SWCK_OPERATOR_VERSION}-bin.tgz | tar -zxf - -O ./config/operator-bundle.yaml | kubectl apply -f -
	@kubectl label namespace --overwrite $(NAMESPACE) swck-injection=enabled
	@kubectl get configmap skywalking-swck-java-agent-configmap -n skywalking-swck-system -oyaml | sed "s/127.0.0.1/$(NAMESPACE)-$(BACKEND_SERVICE).$(NAMESPACE)/" | kubectl apply -f -
	@kubectl label namespace --overwrite $(NAMESPACE) istio-injection=enabled
	$(MAKE) deploy FEATURE_FLAGS=agent TAG=$(TAG) NAMESPACE=$(NAMESPACE) AGENTLESS=true SHOW_TIPS=false

.PHONY: undeploy.feature-mesh-with-agent
undeploy.feature-mesh-with-agent: istioctl
	@curl -Ls https://archive.apache.org/dist/skywalking/swck/${SWCK_OPERATOR_VERSION}/skywalking-swck-${SWCK_OPERATOR_VERSION}-bin.tgz | tar -zxf - -O ./config/operator-bundle.yaml | kubectl delete --ignore-not-found -f -
	@kubectl delete --ignore-not-found -f https://github.com/jetstack/cert-manager/releases/download/${CERT_MANAGER_VERSION}/cert-manager.yaml
	$(MAKE) undeploy FEATURE_FLAGS=agent TAG=$(TAG) NAMESPACE=$(NAMESPACE) AGENTLESS=true
	istioctl x uninstall --purge -y

# @feature: kubernetes-monitor; extra resources to install for kubernetes monitoring, standard kube-state-metrics
.PHONY: feature-kubernetes-monitor
feature-kubernetes-monitor:

.PHONY: deploy.feature-kubernetes-monitor
deploy.feature-kubernetes-monitor:
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/v2.2.4/examples/standard/service-account.yaml
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/v2.2.4/examples/standard/cluster-role.yaml
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/v2.2.4/examples/standard/cluster-role-binding.yaml
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/v2.2.4/examples/standard/service.yaml
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/v2.2.4/examples/standard/deployment.yaml

.PHONY: undeploy.feature-kubernetes-monitor
undeploy.feature-kubernetes-monitor:
	@kubectl delete --ignore-not-found -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/v2.2.4/examples/standard/service-account.yaml
	@kubectl delete --ignore-not-found -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/v2.2.4/examples/standard/cluster-role.yaml
	@kubectl delete --ignore-not-found -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/v2.2.4/examples/standard/cluster-role-binding.yaml
	@kubectl delete --ignore-not-found -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/v2.2.4/examples/standard/service.yaml
	@kubectl delete --ignore-not-found -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/v2.2.4/examples/standard/deployment.yaml

# @feature: java-agent-injector; use the java agent injector to inject the java agent more natively
.PHONY: feature-java-agent-injector
feature-java-agent-injector:

# @feature: java-agent-injector; the swck operator depends on the certificate management of the cert-manager
.PHONY: install-cert-manager
install-cert-manager:
	@kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/${CERT_MANAGER_VERSION}/cert-manager.yaml
	@sh ../../../scripts/wait-cert-manager-ready.sh

# @feature: java-agent-injector; the java agent injector is a component of the swck operator, so we need to deploy the swck operator firstly
.PHONY: deploy.feature-java-agent-injector
deploy.feature-java-agent-injector: install-cert-manager
	@curl -Ls https://archive.apache.org/dist/skywalking/swck/${SWCK_OPERATOR_VERSION}/skywalking-swck-${SWCK_OPERATOR_VERSION}-bin.tgz | tar -zxf - -O ./config/operator-bundle.yaml | kubectl apply -f -
	@kubectl label namespace --overwrite $(NAMESPACE) swck-injection=enabled
	# @feature: java-agent-injector; we can update the agent's backend address in a single-node cluster firstly so that we don't need to add the same backend env for every java agent
	@kubectl get configmap skywalking-swck-java-agent-configmap -n skywalking-swck-system -oyaml | sed "s/127.0.0.1/$(NAMESPACE)-$(BACKEND_SERVICE).$(NAMESPACE)/" | kubectl apply -f -
	$(MAKE) deploy FEATURE_FLAGS=agent AGENTLESS=false SHOW_TIPS=false BACKEND_SERVICE=$(BACKEND_SERVICE)

# @feature: java-agent-injector; uninstall the swck operator and cert-manager
.PHONY: undeploy.feature-java-agent-injector
undeploy.feature-java-agent-injector:
	@curl -Ls https://archive.apache.org/dist/skywalking/swck/${SWCK_OPERATOR_VERSION}/skywalking-swck-${SWCK_OPERATOR_VERSION}-bin.tgz | tar -zxf - -O ./config/operator-bundle.yaml | kubectl delete --ignore-not-found -f -
	@kubectl delete --ignore-not-found -f https://github.com/jetstack/cert-manager/releases/download/${CERT_MANAGER_VERSION}/cert-manager.yaml
	$(MAKE) undeploy FEATURE_FLAGS=agent AGENTLESS=false SHOW_TIPS=false BACKEND_SERVICE=$(BACKEND_SERVICE)

.PHONY: helm
helm:
	@helm version >/dev/null 2>&1 || (echo "No helm in PATH, please make sure helm is available in PATH."; exit 1)

.PHONY: open-function
open-function: helm
	@helm repo add openfunction https://openfunction.github.io/charts/
	@helm repo update
	@helm upgrade openfunction openfunction/openfunction -n openfunction --version 0.3.1 --install --create-namespace \
		--set global.ShipwrightBuild.enabled=false \
		--set global.TektonPipelines.enabled=false \
		--set global.Keda.enabled=false \
		--set global.Dapr.enabled=false \
		--set contour.envoy.useHostPort=false \
		--set contour.envoy.service.type=ClusterIP \
		--set contour.envoy.service.externalTrafficPolicy="" \
		--wait

# @feature: function; install open function resources
.PHONY: deploy.feature-function
deploy.feature-function: open-function
	@echo "deploy.feature-function"

.PHONY: feature-function
feature-function:

.PHONY: undeploy.feature-function
undeploy.feature-function: helm
	@helm uninstall openfunction -n openfunction
