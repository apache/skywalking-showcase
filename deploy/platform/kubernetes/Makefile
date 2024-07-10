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

include ../../../Makefile.in
include Makefile.in

features := $(subst $(comma), ,$(FEATURE_FLAGS))
features := $(foreach f,$(features),feature-$(f))

include check.mak

HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.fullnameOverride=$(RELEASE)
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.image.repository=$(BANYANDB_IMAGE) --set skywalking.banyandb.image.tag=$(BANYANDB_IMAGE_TAG)
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.etcd.persistence.storageClass=$(STORAGE_CLASS)
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.storage.persistentVolumeClaims[0].mountTargets[0]=stream
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.storage.persistentVolumeClaims[0].claimName=stream-data
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.storage.persistentVolumeClaims[0].size=10Gi
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.storage.persistentVolumeClaims[0].accessModes[0]=ReadWriteOnce
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.storage.persistentVolumeClaims[0].storageClass=$(STORAGE_CLASS)
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.storage.persistentVolumeClaims[0].volumeMode=Filesystem
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.storage.persistentVolumeClaims[1].mountTargets[0]=measure
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.storage.persistentVolumeClaims[1].claimName=measure-data
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.storage.persistentVolumeClaims[1].size=10Gi
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.storage.persistentVolumeClaims[1].accessModes[0]=ReadWriteOnce
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.storage.persistentVolumeClaims[1].storageClass=$(STORAGE_CLASS)
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.storage.persistentVolumeClaims[1].volumeMode=Filesystem
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.oap.image.repository=$(SW_OAP_IMAGE) --set skywalking.oap.image.tag=$(SW_OAP_IMAGE_TAG)
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.ui.image.repository=$(SW_UI_IMAGE) --set skywalking.ui.image.tag=$(SW_UI_IMAGE_TAG)
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.ui.env.SW_ZIPKIN_ADDRESS=http://$(RELEASE)-oap.$(NAMESPACE).svc:9412
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.satellite.image.repository=$(SW_SATELLITE_IMAGE) --set skywalking.satellite.image.tag=$(SW_SATELLITE_IMAGE_TAG)
HELM_OPTIONS := $(HELM_OPTIONS) --set swck.image.repository=$(SWCK_OPERATOR_IMAGE) --set swck.image.tag=$(SWCK_OPERATOR_IMAGE_TAG)
HELM_OPTIONS := $(HELM_OPTIONS) --set sampleServices.hub=$(HUB) --set sampleServices.tag=$(TAG) --set sampleServices.namespace=$(SAMPLE_SERVICES_NAMESPACE)
HELM_OPTIONS := $(HELM_OPTIONS) --set ciliumServices.hub=$(HUB) --set ciliumServices.tag=$(TAG) --set ciliumServices.namespace=$(CILIUM_SERVICES_NAMESPACE)
HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry-collector.image.repository=$(OTEL_COLLECTOR_IMAGE) --set opentelemetry-collector.image.tag=$(OTEL_COLLECTOR_IMAGE_TAG)
HELM_OPTIONS := $(HELM_OPTIONS) --set features.rover.swctl.image=$(SW_CLI_IMAGE)
HELM_OPTIONS := $(HELM_OPTIONS) --set features.traceProfiling.swctl.image=$(SW_CLI_IMAGE)
HELM_OPTIONS := $(HELM_OPTIONS) --set features.event.exporter.image=$(SW_EVENT_EXPORTER_IMAGE)
HELM_OPTIONS := $(HELM_OPTIONS) --set features.javaAgentInjector.agentImage=$(SW_AGENT_JAVA_IMAGE)
HELM_OPTIONS := $(HELM_OPTIONS) --set features.rover.image=$(SW_ROVER_IMAGE)
HELM_OPTIONS := $(HELM_OPTIONS) --set features.grafana.image=$(GRAFANA_IMAGE)
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.grafana.plugin.version=$(SW_GRAFANA_PLUGIN_VERSION)
HELM_OPTIONS := $(HELM_OPTIONS) --set features.r3.image=$(SW_R3_IMAGE):$(SW_R3_IMAGE_TAG)

ifeq ($(DEBUG),true)
	HELM_OPTIONS := $(HELM_OPTIONS) --dry-run --debug
endif

BACKEND_SERVICE := $(RELEASE)-oap.$(NAMESPACE).svc:11800
ifneq (,$(findstring satellite,$(features)))
	BACKEND_SERVICE := $(RELEASE)-satellite.$(NAMESPACE).svc:11800
endif

.PHONY: helm
helm:
	@helm version >/dev/null 2>&1 || (echo "No helm in PATH, please make sure helm is available in PATH."; exit 1)

# @feature: java-agent-injector; use the java agent injector to inject the java agent more natively
.PHONY: feature-java-agent-injector
feature-java-agent-injector:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.javaAgentInjector.enabled=true)

.PHONY: feature-single-node
feature-single-node:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.oap.replicas=1)

.PHONY: feature-cluster
feature-cluster:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.oap.replicas=2)

.PHONY: feature-elasticsearch
feature-elasticsearch:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.oap.storageType=elasticsearch)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.elasticsearch.enabled=true)

.PHONY: feature-postgresql
feature-postgresql:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.oap.storageType=postgresql)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.postgresql.enabled=true)

.PHONY: feature-banyandb
feature-banyandb:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.oap.storageType=banyandb)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.enabled=true)

.PHONY: feature-so11y
feature-so11y:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.so11y.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: feature-vm-monitor
feature-vm-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.vmMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: feature-event
feature-event:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.event.enabled=true)

.PHONY: feature-istiod-monitor
feature-istiod-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.istiodMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set istio.enabled=true --set istiod.global.istioNamespace=$(NAMESPACE) --set base.global.istioNamespace=$(NAMESPACE))
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: feature-als
feature-als:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.als.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set istio.enabled=true --set istiod.global.istioNamespace=$(NAMESPACE) --set base.global.istioNamespace=$(NAMESPACE))
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set istiod.meshConfig.defaultConfig.tracing.zipkin.address=$(RELEASE)-oap.$(NAMESPACE).svc:9411)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set istiod.meshConfig.defaultConfig.envoyMetricsService.address=$(BACKEND_SERVICE))
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set istiod.meshConfig.defaultConfig.envoyAccessLogService.address=$(BACKEND_SERVICE))

.PHONY: feature-satellite
feature-satellite:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.satellite.enabled=true)

.PHONY: feature-rover
feature-rover:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.rover.enabled=true)

.PHONY: feature-trace-profiling
feature-trace-profiling:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.traceProfiling.enabled=true)

.PHONY: feature-mysql-monitor
feature-mysql-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.mysqlMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: feature-postgresql-monitor
feature-postgresql-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.postgresqlMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: feature-nginx-monitor
feature-nginx-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.nginxMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: feature-apisix-monitor
feature-apisix-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.apisixMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

# @feature: kubernetes-monitor; extra resources to install for kubernetes monitoring, standard kube-state-metrics
.PHONY: feature-kubernetes-monitor
feature-kubernetes-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.kubernetesMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set kube-state-metrics.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: feature-elasticsearch-monitor
feature-elasticsearch-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.elasticsearchMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set prometheus-elasticsearch-exporter.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: feature-rabbitmq-monitor
feature-rabbitmq-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.rabbitmqMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set rabbitmq.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: feature-mongodb-monitor
feature-mongodb-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.mongodbMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set mongodb.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: feature-grafana
feature-grafana:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.grafana.enabled=true)
	@mkdir -p ./generated/dashboard-configs/
	@cp ../config/grafana/dashboards/*.json ./generated/dashboard-configs/

.PHONY: feature-mesh-with-agent
feature-mesh-with-agent:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.meshWithAgent.enabled=true)

.PHONY: feature-r3
feature-r3:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.r3.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.oap.env.SW_AI_PIPELINE_URI_RECOGNITION_SERVER_ADDR=r3)

.PHONY: feature-rocketmq-monitor
feature-rocketmq-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.rocketmqMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: feature-pulsar-monitor
feature-pulsar-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.pulsarMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: feature-activemq-monitor
feature-activemq-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.activemqMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: cilium
cilium:
ifeq (, $(shell which cilium))
	$(error "No cilium in PATH, please make sure cilium CLI is available in PATH")
endif
ifeq (,$(findstring $(CILIUM_CLI_VERSION),$(shell cilium version --client)))
	$(error "Cilium CLI version is not $(CILIUM_CLI_VERSION), please make sure cilium CLI is $(CILIUM_CLI_VERSION))")
endif
	@INSTALL_OR_UPDATE=$$(cilium status 2>&1 | grep -q "daemonsets.apps \"cilium\" not found" && echo "install" || echo "upgrade"); \
	echo "Cilium will be $$INSTALL_OR_UPDATE"; \
	cilium $$INSTALL_OR_UPDATE --version $(CILIUM_VERSION) --set cni.exclusive=false --set socketLB.hostNamespaceOnly=true --set hubble.tls.enabled=false

# @feature: function; install open function resources
.PHONY: feature-cilium
feature-cilium: cilium
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.cilium.enabled=true --set skywalking.oap.env.SW_CILIUM_FETCHER=default)

.PHONY: deploy
deploy: $(features)
	helm dep up .
	helm -n $(NAMESPACE) upgrade --install $(RELEASE) . --create-namespace --timeout=20m $(HELM_OPTIONS)
ifneq ($(DEBUG),true)
	$(info rollout restart to allow the new sidecar to be injected.)
	kubectl -n $(SAMPLE_SERVICES_NAMESPACE) get deployments -o name | xargs kubectl -n $(SAMPLE_SERVICES_NAMESPACE) rollout restart
endif

.PHONY: undeploy
undeploy:
	helm -n $(NAMESPACE) delete $(RELEASE) --wait || true
ifneq ($(findstring cilium,$(FEATURE_FLAGS)),)
	cilium uninstall
endif
