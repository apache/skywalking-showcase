{{/*
Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with
this work for additional information regarding copyright ownership.
The ASF licenses this file to You under the Apache License, Version 2.0
(the "License"); you may not use this file except in compliance with
the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/}}

{{/*
The collector address, might be OAP or Satellite
*/}}
{{- define "skywalking.collector.address" -}}
{{- if index .Values "skywalking-helm" "satellite" "enabled" }}
{{- printf "%s-satellite.%s.svc.cluster.local:%d" (index .Values "skywalking-helm" "fullnameOverride") .Release.Namespace 11800 }}
{{- else }}
{{- printf "%s-oap.%s.svc.cluster.local:%d" (index .Values "skywalking-helm" "fullnameOverride") .Release.Namespace 11800 }}
{{- end -}}
{{- end -}}

{{- define "skywalking.oap.address.grpc" -}}
{{- printf "%s-oap.%s.svc.cluster.local:%d" (index .Values "skywalking-helm" "fullnameOverride") .Release.Namespace 11800 }}
{{- end -}}

{{- define "skywalking.oap.address.http" -}}
{{- printf "http://%s-oap.%s.svc.cluster.local:%d" (index .Values "skywalking-helm" "fullnameOverride") .Release.Namespace 12800 }}
{{- end -}}
