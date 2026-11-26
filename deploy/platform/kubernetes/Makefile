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
# Sanitize STORAGE_CLASS (remove quotes and whitespace), then conditionally include storageClass fields
STORAGE_CLASS_SANITIZED := $(strip $(subst ",,$(subst ',,$(STORAGE_CLASS))))
ifeq ($(STORAGE_CLASS_SANITIZED),)
PVC_STORAGE_CLASS_FIELD :=
else
PVC_STORAGE_CLASS_FIELD := ,"storageClass":"$(STORAGE_CLASS_SANITIZED)"
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.etcd.persistence.storageClass=$(STORAGE_CLASS_SANITIZED)
endif
HELM_OPTIONS := $(HELM_OPTIONS) --set-json 'skywalking.banyandb.storage.liaison.persistentVolumeClaims[0]={"mountTargets":["measure","stream","trace"],"claimName":"liaison-data","size":"10Gi","accessModes":["ReadWriteOnce"]$(PVC_STORAGE_CLASS_FIELD),"volumeMode":"Filesystem"}'
HELM_OPTIONS := $(HELM_OPTIONS) --set-json 'skywalking.banyandb.storage.data.persistentVolumeClaims[0]={"mountTargets":["stream"],"nodeRole":"hot","claimName":"hot-stream-data","size":"10Gi","accessModes":["ReadWriteOnce"]$(PVC_STORAGE_CLASS_FIELD),"volumeMode":"Filesystem"}'
HELM_OPTIONS := $(HELM_OPTIONS) --set-json 'skywalking.banyandb.storage.data.persistentVolumeClaims[1]={"mountTargets":["measure"],"nodeRole":"hot","claimName":"hot-measure-data","size":"10Gi","accessModes":["ReadWriteOnce"]$(PVC_STORAGE_CLASS_FIELD),"volumeMode":"Filesystem"}'
HELM_OPTIONS := $(HELM_OPTIONS) --set-json 'skywalking.banyandb.storage.data.persistentVolumeClaims[2]={"mountTargets":["property"],"nodeRole":"hot","claimName":"hot-property-data","size":"5Gi","accessModes":["ReadWriteOnce"]$(PVC_STORAGE_CLASS_FIELD),"volumeMode":"Filesystem"}'
HELM_OPTIONS := $(HELM_OPTIONS) --set-json 'skywalking.banyandb.storage.data.persistentVolumeClaims[3]={"mountTargets":["trace"],"nodeRole":"hot","claimName":"hot-trace-data","size":"50Gi","accessModes":["ReadWriteOnce"]$(PVC_STORAGE_CLASS_FIELD),"volumeMode":"Filesystem"}'
HELM_OPTIONS := $(HELM_OPTIONS) --set-json 'skywalking.banyandb.storage.data.persistentVolumeClaims[4]={"mountTargets":["schema-property"],"nodeRole":"hot","claimName":"hot-schema-property-data","size":"5Gi","accessModes":["ReadWriteOnce"]$(PVC_STORAGE_CLASS_FIELD),"volumeMode":"Filesystem"}'
HELM_OPTIONS := $(HELM_OPTIONS) --set-json 'skywalking.banyandb.storage.data.persistentVolumeClaims[5]={"mountTargets":["stream","measure","property","trace"],"nodeRole":"warm","claimName":"warm-data","size":"100Gi","accessModes":["ReadWriteOnce"]$(PVC_STORAGE_CLASS_FIELD),"volumeMode":"Filesystem"}'
HELM_OPTIONS := $(HELM_OPTIONS) --set-json 'skywalking.banyandb.storage.data.persistentVolumeClaims[6]={"mountTargets":["stream","measure","property","trace"],"nodeRole":"cold","claimName":"cold-data","size":"500Gi","accessModes":["ReadWriteOnce"]$(PVC_STORAGE_CLASS_FIELD),"volumeMode":"Filesystem"}'
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.oap.image.repository=$(SW_OAP_IMAGE) --set skywalking.oap.image.tag=$(SW_OAP_IMAGE_TAG)
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.ui.image.repository=$(SW_UI_IMAGE) --set skywalking.ui.image.tag=$(SW_UI_IMAGE_TAG)
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
HELM_OPTIONS := $(HELM_OPTIONS) --set features.baseline.image=$(SW_PREDICTOR_IMAGE)
HELM_OPTIONS := $(HELM_OPTIONS) --set features.asz.image=$(SW_ASZ_IMAGE):$(SW_ASZ_IMAGE_TAG)
HELM_OPTIONS := $(HELM_OPTIONS) --set features.asz.scenariosImage=$(SW_ASZ_SCENARIOS_IMAGE):$(SW_ASZ_SCENARIOS_IMAGE_TAG)
HELM_OPTIONS := $(HELM_OPTIONS) --set sampleServices.scaller.enabled=$(SCALLER_ENABLE)
# Horizon's TraceQL (Tempo API) endpoint. The chart computes the UI's query/admin/zipkin URLs itself but not this
# one, and the OAP host is derived from $(RELEASE), so it is set here rather than in values.yaml. Port =
# skywalking.oap.ports.traceql; Horizon probes OAP's default /skywalking, /zipkin and /otlp paths under it.
HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.ui.config.oap.traceql.url=http://$(RELEASE)-oap:3200

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

# The swck operator serves its admission webhooks -- the java agent injector among them
# -- over TLS from a certificate cert-manager mints, and the skywalking-swck chart
# expects cert-manager to already be in the cluster. (It used to arrive as a subchart of
# the operator chart; that chart dropped the dependency.)
#
# Installed out of band as its own release rather than as a chart dependency of the
# showcase, the same way `cilium` below is. cert-manager's six CRDs are cluster-scoped
# and NOT release-name-prefixed -- certificates.cert-manager.io and friends -- so a copy
# vendored into the showcase release refuses to install on any cluster that already runs
# cert-manager: "cannot be imported into the current release: invalid ownership
# metadata". A shared cluster commonly does run one already -- an ingress ClusterIssuer is
# the usual reason. Using the conventional release name and namespace means such an
# install is adopted as a no-op instead of collided with; keep CERT_MANAGER_VERSION in
# step with whatever version that cluster is on.
#
# Deliberately not torn down by `undeploy`: other releases on the cluster may hold
# Certificates that cert-manager has to keep renewing.
.PHONY: cert-manager
cert-manager:
# DEBUG=true puts `deploy` in --dry-run, so this must not touch the cluster either --
# otherwise a dry run silently installs cert-manager for real.
ifeq ($(DEBUG),true)
	@echo "DEBUG=true: skipping cert-manager (would install $(CERT_MANAGER_VERSION) as release 'cert-manager' in namespace 'cert-manager')"
else
	@helm upgrade --install cert-manager cert-manager \
		--repo https://charts.jetstack.io \
		--version $(CERT_MANAGER_VERSION) \
		--namespace cert-manager --create-namespace \
		--set crds.enabled=true \
		--wait --timeout=5m
endif

# @feature: java-agent-injector; use the java agent injector to inject the java agent more natively
# `cert-manager` runs first, as a prerequisite: the showcase release contains an Issuer
# and a Certificate, and those are rejected by admission until cert-manager's own webhook
# is serving. `--wait` above is what makes that ordering real.
.PHONY: feature-java-agent-injector
feature-java-agent-injector: cert-manager
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
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.elasticsearch.image=$(ES_IMAGE))
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.elasticsearch.imageTag=$(ES_IMAGE_TAG))
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.elasticsearch.enabled=true)

.PHONY: feature-postgresql
feature-postgresql:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.oap.storageType=postgresql)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.postgresql.enabled=true)

# Horizon's login audit rides along with this feature, in the very BanyanDB the stack already
# runs for OAP: it keeps its records in groups of its own (horizon_audit, horizon_audit_metrics),
# so nothing it writes can collide with OAP's data. Wired here rather than in values.yaml because
# the liaison service name is derived from $(RELEASE), and because there is no BanyanDB to write
# to under the elasticsearch / postgresql storage features.
#   allowCleartext: the liaison is reached over the cluster network with no TLS, and a
#   non-loopback address without it is refused at boot (the records carry usernames and
#   source addresses). Fine for the showcase; not for anything reachable by anyone else.
#   retentionDays: 7, in the spirit of the short TTLs the demo gives OAP's own groups.
.PHONY: feature-banyandb
feature-banyandb:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.oap.storageType=banyandb)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.canopy.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.ui.config.audit.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.ui.config.audit.provider=banyandb)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.ui.config.audit.banyandb.address=$(RELEASE)-banyandb-grpc:17912)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.ui.config.audit.banyandb.allowCleartext=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.ui.config.audit.banyandb.retentionDays=7)

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

# The sidecars' traces go over OTLP to the OpenTelemetry Collector, which forwards every span to the OAP twice:
# as native OTLP, and converted to Zipkin, so the demo shows both trace views. Envoy reports to a single tracer,
# hence the collector in between. Outside the demo, pick one and skip the collector:
# - Zipkin only: drop opentelemetry.enabled, enableTracing and extensionProviders below, and send Zipkin to the OAP:
#     $(eval HELM_OPTIONS := $(HELM_OPTIONS) --set istiod.meshConfig.defaultConfig.tracing.zipkin.address=$(RELEASE)-oap.$(NAMESPACE).svc:9411)
# - OTLP only: point the extensionProviders entry at the OAP's gRPC port, $(RELEASE)-oap.$(NAMESPACE).svc.cluster.local:11800.
# The sidecars' service.namespace=mesh-svr (values.yaml) names their OTLP services mesh-svr::<service>.<namespace>,
# with SW_OTEL_RECEIVER_OTLP_SERVICE_GROUP below.
.PHONY: feature-als
feature-als:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.als.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set istio.enabled=true --set istiod.global.istioNamespace=$(NAMESPACE) --set base.global.istioNamespace=$(NAMESPACE))
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set istiod.meshConfig.enableTracing=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.oap.env.SW_OTEL_RECEIVER_OTLP_SERVICE_GROUP=service.namespace)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set-json 'istiod.meshConfig.extensionProviders=[{"name":"skywalking-mesh-otlp","opentelemetry":{"service":"$(RELEASE)-opentelemetry-collector.$(NAMESPACE).svc.cluster.local","port":4317,"resourceDetectors":{"environment":{}}}}]')
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

.PHONY: feature-banyandb-monitor
feature-banyandb-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.banyandbMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

.PHONY: feature-banyandb-backup
feature-banyandb-backup:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.cluster.data.roles.hot.backupSidecar.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.cluster.data.roles.hot.restoreInitContainer.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.cluster.data.roles.warm.backupSidecar.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.cluster.data.roles.warm.restoreInitContainer.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.cluster.data.roles.cold.backupSidecar.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.banyandb.cluster.data.roles.cold.restoreInitContainer.enabled=true)

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

# @feature: otlp-trace; the OpenTelemetry Astronomy Shop, installed by `deploy` as its own release in its own namespace,
# since its services take fixed names (frontend, kafka, otel-collector, ...). Its collector sends every span to the OAP.
.PHONY: feature-otlp-trace
feature-otlp-trace:
	$(eval OTEL_DEMO_HELM_OPTIONS := --version $(OTEL_DEMO_CHART_VERSION) -f ../config/opentelemetry-demo/values.yaml)
	$(eval OTEL_DEMO_HELM_OPTIONS := $(OTEL_DEMO_HELM_OPTIONS) --set default.image.repository=$(OTEL_DEMO_IMAGE) --set default.image.tag=$(OTEL_DEMO_IMAGE_TAG))
	$(eval OTEL_DEMO_HELM_OPTIONS := $(OTEL_DEMO_HELM_OPTIONS) --set opentelemetry-collector.alternateConfig.exporters.otlp_grpc/oap.endpoint=$(RELEASE)-oap.$(NAMESPACE).svc:11800)
	$(eval OTEL_DEMO_HELM_OPTIONS := $(OTEL_DEMO_HELM_OPTIONS) $(if $(filter true,$(DEBUG)),--dry-run --debug))
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set skywalking.oap.env.SW_OTEL_RECEIVER_OTLP_SERVICE_GROUP=service.namespace)

# @feature: prometheus; upgrade the existing `prometheus` release in PROMETHEUS_NAMESPACE in place (`helm upgrade`, no
# --install). The scrape jobs come from deploy/platform/config/prometheus/scrape/ according to FEATURE_FLAGS and go to the chart's
# extraScrapeConfigs; the generated files go to generated/, which every `deploy` empties first.
# With the prometheus-slack feature the Secret PROMETHEUS_SLACK_SECRET must hold a non-empty `slack-bot-token`; it is
# checked here, before `deploy` upgrades the main release, and the Alertmanager gets the Slack receiver and message
# template; otherwise its root receiver sends nowhere. The Prometheus release itself is upgraded at the end of `deploy`.
# The variables that end up in sed, a values file or a kubectl/amtool command (Slack, namespace, release and
# duration settings) are validated against a whitelist first.
# The StatefulSet name follows the alertmanager subchart's `alertmanager.fullname`.
PROMETHEUS_ALERTMANAGER_STS = $(if $(findstring alertmanager,$(PROMETHEUS_RELEASE)),$(PROMETHEUS_RELEASE),$(PROMETHEUS_RELEASE)-alertmanager)
# Service names follow the chart's `prometheus.server.fullname` and the subchart's `alertmanager.fullname`.
PROMETHEUS_SERVER_SVC = $(if $(findstring prometheus,$(PROMETHEUS_RELEASE)),$(PROMETHEUS_RELEASE)-server,$(PROMETHEUS_RELEASE)-prometheus-server)
# Shell function: a duration such as 30m in seconds.
PROMETHEUS_SECONDS = to_seconds() { n=$${1%[smh]}; case "$$1" in *h) echo $$((n * 3600));; *m) echo $$((n * 60));; *) echo $$n;; esac; };

# Names that YAML reads as a number, boolean or null. The chart writes the Secret name unquoted into the
# manifest, so such a name would not reach Kubernetes as a string.
PROMETHEUS_YAML_NON_STRING = ^([0-9][0-9.e+_]*|0[xob][0-9a-f_]+|true|false|yes|no|on|off|y|n|null)$$

# check: fails unless the variable named by the first argument matches the extended regex of the second. reject: fails when
# it matches. Values are read from the environment, not the command line.
define PROMETHEUS_VALIDATE
check() { v=$$(printenv "$$1"); [ "$$v" = "$$(printf '%s' "$$v" | tr -d '\n')" ] && printf '%s\n' "$$v" | grep -Eq "$$2" || { printf '%s\n' "$$1='$$v' is invalid: $$3" >&2; exit 1; }; }; \
reject() { v=$$(printenv "$$1"); if printf '%s\n' "$$v" | grep -Eq "$$2"; then printf '%s\n' "$$1='$$v' is invalid: $$3" >&2; exit 1; fi; }; \
$(if $(filter feature-prometheus-slack,$(features)),check PROMETHEUS_SLACK_CHANNEL '^([#][a-z0-9_-]+|[CGD][A-Z0-9]+)$$' 'a channel name (# and lowercase letters, digits, - and _) or a channel ID'; \
check PROMETHEUS_SLACK_SECRET '^[a-z0-9]([-a-z0-9.]*[a-z0-9])?$$' 'not a DNS-1123 name'; \
reject PROMETHEUS_SLACK_SECRET '$(PROMETHEUS_YAML_NON_STRING)' 'YAML would read it as a number or boolean instead of a string'; \
)check NAMESPACE '^[a-z0-9]([-a-z0-9]*[a-z0-9])?$$' 'not a DNS-1123 label'; \
check RELEASE '^[a-z0-9]([-a-z0-9]*[a-z0-9])?$$' 'not a DNS-1123 label'; \
check PROMETHEUS_NAMESPACE '^[a-z0-9]([-a-z0-9]*[a-z0-9])?$$' 'not a DNS-1123 label'; \
check PROMETHEUS_RELEASE '^[a-z0-9]([-a-z0-9]{0,38}[a-z0-9])?$$' 'letters, digits and - only, at most 40 characters'; \
check PROMETHEUS_DEPLOY_SILENCE_MAX '^[1-9][0-9]*[smh]$$' 'not a duration such as 40m'; \
check PROMETHEUS_DEPLOY_SILENCE '^[1-9][0-9]*[smh]$$' 'not a duration such as 17m'; \
check PROMETHEUS_DEPLOY_ROLLOUT_TIMEOUT '^[1-9][0-9]*[smh]$$' 'not a duration such as 30m'; \
$(PROMETHEUS_SECONDS) \
[ "$$(to_seconds "$$PROMETHEUS_DEPLOY_SILENCE")" -ge 960 ] || { echo "PROMETHEUS_DEPLOY_SILENCE=$$PROMETHEUS_DEPLOY_SILENCE is too short: at least 16m, because BanyanDBNodeRestarted looks at resets over 15m and the silence must outlast them" >&2; exit 1; }; \
[ "$$(to_seconds "$$PROMETHEUS_DEPLOY_SILENCE_MAX")" -ge $$(( $$(to_seconds "$$PROMETHEUS_DEPLOY_ROLLOUT_TIMEOUT") + 900 )) ] || { echo "PROMETHEUS_DEPLOY_SILENCE_MAX=$$PROMETHEUS_DEPLOY_SILENCE_MAX must be at least PROMETHEUS_DEPLOY_ROLLOUT_TIMEOUT=$$PROMETHEUS_DEPLOY_ROLLOUT_TIMEOUT plus 15m for the steps before the rollout wait and the Prometheus upgrade" >&2; exit 1; }
endef

# The deploy silence on BanyanDBNodeRestarted and BanyanDBNodeMissing: S1 is added before the main release is upgraded and its
# id kept in generated/; after the Prometheus upgrade S2 is added first and S1 is expired only if that worked (expiring
# fails when the Alertmanager was recreated, as its silences are gone). A failed silence command only prints a warning.
PROMETHEUS_AMTOOL = kubectl -n $(PROMETHEUS_NAMESPACE) exec sts/$(PROMETHEUS_ALERTMANAGER_STS) -c alertmanager -- amtool --alertmanager.url=http://localhost:9093
PROMETHEUS_SILENCE_ADD = silence add 'alertname=~"BanyanDBNode(Restarted|Missing)"' --comment='showcase deploy' --author=showcase
PROMETHEUS_SILENCE_ID = ./generated/prometheus-deploy-silence-id

define PROMETHEUS_DEPLOY_SILENCE_START
out=$$(kubectl -n $(PROMETHEUS_NAMESPACE) get sts '$(PROMETHEUS_ALERTMANAGER_STS)' -o name 2>&1); rc=$$?; \
if [ $$rc -eq 0 ]; then \
	id=$$(kubectl -n $(PROMETHEUS_NAMESPACE) wait --for=condition=Ready pod -l 'app.kubernetes.io/name=alertmanager,app.kubernetes.io/instance=$(PROMETHEUS_RELEASE)' --timeout=60s >/dev/null && $(PROMETHEUS_AMTOOL) $(PROMETHEUS_SILENCE_ADD) --duration=$(PROMETHEUS_DEPLOY_SILENCE_MAX)) && [ -n "$$id" ] \
		&& echo "$$id" > $(PROMETHEUS_SILENCE_ID) && echo "silenced BanyanDBNodeRestarted and BanyanDBNodeMissing for up to $(PROMETHEUS_DEPLOY_SILENCE_MAX): $$id" \
		|| echo "warning: could not add the deploy silence; the rollout may send BanyanDBNodeRestarted and BanyanDBNodeMissing" >&2; \
else \
	case "$$out" in \
		*'(NotFound)'*) echo "Alertmanager StatefulSet '$(PROMETHEUS_ALERTMANAGER_STS)' not found (first deploy): skipping the deploy silence before the rollout";; \
		*) echo "warning: cannot read StatefulSet '$(PROMETHEUS_ALERTMANAGER_STS)': $$out; skipping the deploy silence, the rollout may send BanyanDBNodeRestarted and BanyanDBNodeMissing" >&2;; \
	esac; \
fi
endef

define PROMETHEUS_DEPLOY_SILENCE_END
if $(PROMETHEUS_AMTOOL) $(PROMETHEUS_SILENCE_ADD) --duration=$(PROMETHEUS_DEPLOY_SILENCE) >/dev/null; then \
	echo "silenced BanyanDBNodeRestarted and BanyanDBNodeMissing for $(PROMETHEUS_DEPLOY_SILENCE)"; \
	if [ -f $(PROMETHEUS_SILENCE_ID) ]; then \
		$(PROMETHEUS_AMTOOL) silence expire "$$(cat $(PROMETHEUS_SILENCE_ID))" >/dev/null || echo "warning: could not expire the deploy silence $$(cat $(PROMETHEUS_SILENCE_ID)); it ends by itself" >&2; \
	fi; \
else \
	echo "warning: could not add the deploy silence; BanyanDBNodeRestarted and BanyanDBNodeMissing may be sent, and the earlier silence is left to end by itself" >&2; \
fi
endef

# Waits for every BanyanDB StatefulSet in turn; PROMETHEUS_DEPLOY_ROLLOUT_TIMEOUT is one deadline for all of them, each
# `rollout status` gets the seconds left. Running out of time only prints a warning.
define PROMETHEUS_ROLLOUT_WAIT
$(PROMETHEUS_SECONDS) \
deadline=$$(( $$(date +%s) + $$(to_seconds '$(PROMETHEUS_DEPLOY_ROLLOUT_TIMEOUT)') )); \
names=$$(kubectl -n $(NAMESPACE) get sts -l app.kubernetes.io/name=banyandb -o name) || { echo "warning: cannot list the BanyanDB StatefulSets, not waiting for the rollout" >&2; exit 0; }; \
for name in $$names; do \
	left=$$(( deadline - $$(date +%s) )); \
	if [ $$left -le 0 ]; then echo "warning: $(PROMETHEUS_DEPLOY_ROLLOUT_TIMEOUT) are used up, not waiting for $$name and the StatefulSets after it" >&2; break; fi; \
	kubectl -n $(NAMESPACE) rollout status $$name --timeout=$${left}s || echo "warning: $$name did not finish rolling out within the $(PROMETHEUS_DEPLOY_ROLLOUT_TIMEOUT) deadline" >&2; \
done
endef

.PHONY: feature-prometheus
feature-prometheus: clean-generated
	@$(PROMETHEUS_VALIDATE)
	@errf=$$(mktemp) || exit 1; trap 'rm -f "$$errf"' EXIT; \
	if ! out=$$(helm -n $(PROMETHEUS_NAMESPACE) list --all --filter '^$(PROMETHEUS_RELEASE)$$' -o json 2>"$$errf"); then \
		echo "cannot read helm release '$(PROMETHEUS_RELEASE)' in namespace '$(PROMETHEUS_NAMESPACE)': $$(cat "$$errf")" >&2; exit 1; \
	fi; \
	chart=$$(printf '%s' "$$out" | sed -n 's/.*"chart":"\([^"]*\)".*/\1/p'); \
	if [ -z "$$chart" ]; then \
		echo "helm release '$(PROMETHEUS_RELEASE)' not found in namespace '$(PROMETHEUS_NAMESPACE)'; the feature upgrades an existing release. Install it first:" >&2; \
		echo "  helm -n $(PROMETHEUS_NAMESPACE) install $(PROMETHEUS_RELEASE) prometheus --repo $(PROMETHEUS_CHART_REPO) --version $(PROMETHEUS_CHART_VERSION) --create-namespace" >&2; exit 1; \
	fi; \
	case "$$chart" in prometheus-[0-9]*) ;; *) echo "helm release '$(PROMETHEUS_RELEASE)' in namespace '$(PROMETHEUS_NAMESPACE)' is chart '$$chart', not the prometheus chart; the feature only upgrades a prometheus release" >&2; exit 1;; esac
ifneq ($(filter feature-prometheus-slack,$(features)),)
ifeq ($(DEBUG),true)
	@echo "DEBUG=true: skipping the check for the slack-bot-token key of secret '$(PROMETHEUS_SLACK_SECRET)' in namespace '$(PROMETHEUS_NAMESPACE)'"
else
	@errf=$$(mktemp) || exit 1; trap 'rm -f "$$errf"' EXIT; \
	if tok=$$(kubectl -n $(PROMETHEUS_NAMESPACE) get secret $(PROMETHEUS_SLACK_SECRET) -o jsonpath='{.data.slack-bot-token}' 2>"$$errf"); then \
		[ -n "$$tok" ] && exit 0; \
		echo "secret '$(PROMETHEUS_SLACK_SECRET)' in namespace '$(PROMETHEUS_NAMESPACE)' has no non-empty key 'slack-bot-token'; the Alertmanager reads the Slack bot token from it." >&2; \
	else \
		case "$$(cat "$$errf")" in \
			*'(NotFound)'*) echo "secret '$(PROMETHEUS_SLACK_SECRET)' not found in namespace '$(PROMETHEUS_NAMESPACE)'; the Alertmanager reads the Slack bot token from its key 'slack-bot-token'." >&2;; \
			*) echo "cannot read secret '$(PROMETHEUS_SLACK_SECRET)' in namespace '$(PROMETHEUS_NAMESPACE)': $$(cat "$$errf")" >&2; exit 1;; \
		esac; \
	fi; \
	echo "Create it first:" >&2; \
	echo "  kubectl create secret generic $(PROMETHEUS_SLACK_SECRET) -n $(PROMETHEUS_NAMESPACE) --from-literal=slack-bot-token=\"\$$SLACK_BOT_TOKEN\"" >&2; \
	exit 1
endif
endif
	@mkdir -p ./generated/
	$(eval PROMETHEUS_SCRAPE_FILES := ../config/prometheus/scrape/base.yaml $(if $(filter feature-banyandb,$(features)),../config/prometheus/scrape/banyandb.yaml) $(if $(filter feature-so11y,$(features)),../config/prometheus/scrape/so11y.yaml))
	@raw=$$(for f in $(PROMETHEUS_SCRAPE_FILES); do cat "$$f" || exit 1; done) || { echo "cannot read the scrape fragments" >&2; exit 1; }; \
	printf '%s\n' "$$raw" | grep -v -e '^[#]' -e '^$$' | sed -e "s|__NAMESPACE__|$$NAMESPACE|g" -e "s|__RELEASE__|$$RELEASE|g" > ./generated/prometheus-scrape.yaml
ifneq ($(filter feature-prometheus-slack,$(features)),)
	@{ echo 'alertmanager:'; echo '  config:'; sed 's/^/    /' ../config/prometheus/alertmanager/alertmanager-slack.yml; } > ./generated/prometheus-alertmanager-config.yaml
	@sed -e "s|__SLACK_CHANNEL__|$$PROMETHEUS_SLACK_CHANNEL|" -e "s|__SLACK_SECRET__|$$PROMETHEUS_SLACK_SECRET|" \
		-e "s|__PROMETHEUS_NAMESPACE__|$$PROMETHEUS_NAMESPACE|g" -e "s|__PROMETHEUS_SERVER_SVC__|$(PROMETHEUS_SERVER_SVC)|g" -e "s|__PROMETHEUS_ALERTMANAGER_SVC__|$(PROMETHEUS_ALERTMANAGER_STS)|g" \
		../config/prometheus/alertmanager/kubernetes-slack.yaml > ./generated/prometheus-alertmanager-slack.yaml
else
	@{ echo 'alertmanager:'; echo '  config:'; sed 's/^/    /' ../config/prometheus/alertmanager/alertmanager.yml; } > ./generated/prometheus-alertmanager-config.yaml
endif
	$(eval PROMETHEUS_HELM_OPTIONS := --repo $(PROMETHEUS_CHART_REPO) --version $(PROMETHEUS_CHART_VERSION) -f ../config/prometheus/values.yaml)
ifneq ($(filter feature-banyandb,$(features)),)
	@{ echo 'serverFiles:'; echo '  alerting_rules.yml:'; sed 's/^/    /' ../config/prometheus/rules/banyandb.yaml; } > ./generated/prometheus-banyandb-rules.yaml
	$(eval PROMETHEUS_HELM_OPTIONS := $(PROMETHEUS_HELM_OPTIONS) -f ./generated/prometheus-banyandb-rules.yaml)
endif
	$(eval PROMETHEUS_HELM_OPTIONS := $(PROMETHEUS_HELM_OPTIONS) -f ./generated/prometheus-alertmanager-config.yaml)
ifneq ($(filter feature-prometheus-slack,$(features)),)
	$(eval PROMETHEUS_HELM_OPTIONS := $(PROMETHEUS_HELM_OPTIONS) -f ./generated/prometheus-alertmanager-slack.yaml --set-file 'alertmanager.templates.slack\.tmpl=../config/prometheus/alertmanager/slack.tmpl')
endif
	$(eval PROMETHEUS_HELM_OPTIONS := $(PROMETHEUS_HELM_OPTIONS) --set-file extraScrapeConfigs=./generated/prometheus-scrape.yaml)
# Network and template failures happen here, before S1 is added.
	helm -n $(PROMETHEUS_NAMESPACE) template $(PROMETHEUS_RELEASE) prometheus $(PROMETHEUS_HELM_OPTIONS) > /dev/null
ifneq ($(DEBUG),true)
	@$(PROMETHEUS_DEPLOY_SILENCE_START)
endif

# @feature: prometheus-slack; make the Alertmanager of the `prometheus` feature post the alerts to Slack. It only switches
# the Slack parts of `feature-prometheus` on and needs `prometheus` in FEATURE_FLAGS (in any order).
.PHONY: feature-prometheus-slack
feature-prometheus-slack:
ifeq ($(filter feature-prometheus,$(features)),)
	@echo "the prometheus-slack feature needs the prometheus feature; add prometheus to FEATURE_FLAGS" >&2; exit 1
endif
	@:

# @feature: asz; deploy the SkyWalking AI Sessionizer. No real Claude Code runs in the showcase, so
# asz's scenario feed generates the conversations, and asz collects them and pushes them to the OAP
# under the AI_AGENT layer.
.PHONY: feature-asz
feature-asz:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.asz.enabled=true)

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

.PHONY: feature-baseline
feature-baseline:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.baseline.enabled=true --set skywalking.oap.env.SW_API_PIPELINE_BASELINE_SERVICE_HOST=$(RELEASE)-baseline.$(NAMESPACE).svc.cluster.local)

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

.PHONY: feature-flink-monitor
feature-flink-monitor:
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set features.flinkMonitor.enabled=true)
	$(eval HELM_OPTIONS := $(HELM_OPTIONS) --set opentelemetry.enabled=true)

# generated/ holds the copies that feature targets make for Helm, which reads files only inside the
# chart. It starts empty on every deploy: a file deleted from its source must not linger, and a copy
# left by a disabled feature would still ride in the Helm release as a chart file.
.PHONY: clean-generated
clean-generated:
	@rm -rf ./generated/

feature-grafana: clean-generated

# Remove everything a deploy generates: the copies for Helm, and the charts `helm dep up` downloads.
.PHONY: clean
clean: clean-generated
	@rm -rf ./charts/ ./tmpcharts/ ./tmpcharts-*/ ./Chart.lock

.PHONY: deploy
deploy: clean-generated $(features)
	@rm -rf ./charts/ ./tmpcharts/ ./tmpcharts-*/ ./Chart.lock
	helm dep up .
	helm -n $(NAMESPACE) upgrade --install $(RELEASE) . --create-namespace --timeout=20m $(HELM_OPTIONS)
ifneq ($(findstring otlp-trace,$(FEATURE_FLAGS)),)
	helm -n $(OTEL_DEMO_NAMESPACE) upgrade --install $(OTEL_DEMO_RELEASE) $(OTEL_DEMO_CHART) --create-namespace --timeout=20m $(OTEL_DEMO_HELM_OPTIONS)
endif
ifneq ($(DEBUG),true)
	$(info rollout restart to allow the new sidecar to be injected.)
	kubectl -n $(SAMPLE_SERVICES_NAMESPACE) get deployments -o name | xargs kubectl -n $(SAMPLE_SERVICES_NAMESPACE) rollout restart
endif
ifneq ($(filter feature-prometheus,$(features)),)
ifneq ($(DEBUG),true)
ifneq ($(filter feature-banyandb,$(features)),)
	@$(PROMETHEUS_ROLLOUT_WAIT)
endif
endif
	helm -n $(PROMETHEUS_NAMESPACE) upgrade $(PROMETHEUS_RELEASE) prometheus --wait --timeout=5m $(PROMETHEUS_HELM_OPTIONS) $(if $(filter true,$(DEBUG)),--dry-run --debug)
ifneq ($(DEBUG),true)
	@$(PROMETHEUS_DEPLOY_SILENCE_END)
endif
endif

.PHONY: undeploy
undeploy:
	helm -n $(NAMESPACE) delete $(RELEASE) --wait || true
# The `prometheus` release is kept: deleting it would delete its PVC and the metrics.
ifneq ($(findstring otlp-trace,$(FEATURE_FLAGS)),)
	helm -n $(OTEL_DEMO_NAMESPACE) delete $(OTEL_DEMO_RELEASE) --wait || true
endif
ifneq ($(findstring cilium,$(FEATURE_FLAGS)),)
	cilium uninstall
endif
