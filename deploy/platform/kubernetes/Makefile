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

include Makefile.in
include ../../../Makefile.in

features := $(subst $(comma), ,$(FEATURE_FLAGS))
features := $(foreach f,$(features),feature-$(f))

# Deploy
deploy_features := $(foreach r,$(features),deploy.$(r))
.PHONY: $(deploy_features)
$(deploy_features): %: %.resources

deploy_resources := $(foreach r,$(deploy_features),$(r).resources)
.PHONY: $(deploy_resources)
$(deploy_resources): deploy.%.resources: %
	$(eval resources := $(wildcard $(shell pwd)/$</*))
	@$(foreach resource, $(resources), docker run --rm -v "$(pwd)/$(resource)":/input \
		$(foreach v,$(EXPORTED_VARS),-e $(v)) \
		bhgedigital/envsubst sh -c "envsubst < /input" | kubectl apply -f - ; \
	)

.PHONY: deploy
deploy: $(deploy_features)

# Undeploy
undeploy_features := $(foreach r,$(features),undeploy.$(r))
.PHONY: $(undeploy_features)
$(undeploy_features): %: %.resources

undeploy_resources := $(foreach r,$(undeploy_features),$(r).resources)
.PHONY: $(undeploy_resources)
$(undeploy_resources): undeploy.%.resources: %
	$(eval resources := $(wildcard $(shell pwd)/$</*))
	@$(foreach resource, $(resources), docker run --rm -v "$(pwd)/$(resource)":/input \
		$(foreach v,$(EXPORTED_VARS),-e $(v)) \
		bhgedigital/envsubst sh -c "envsubst < /input" | kubectl delete --ignore-not-found -f - ; \
	)

.PHONY: undeploy
undeploy: $(undeploy_features)

include features.mk
