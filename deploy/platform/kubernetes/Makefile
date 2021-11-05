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

ifeq ($(FEATURE_FLAGS),all)
  features := $(wildcard feature-*)
else
  features := $(subst $(comma), ,$(FEATURE_FLAGS))
  features := $(foreach f,$(features),feature-$(f))
endif

resources := $(foreach dir,$(features),$(wildcard $(dir)/*))

resources_deploy := $(foreach r,$(resources),$(r).deploy)
.PHONY: $(resources_deploy)
$(resources_deploy): %.deploy: %
	@docker run --rm -v "$(shell pwd)/$<":/input \
		$(foreach v,$(EXPORTED_VARS),-e $(v)) \
		bhgedigital/envsubst sh -c "envsubst < /input" | kubectl apply -f -

.PHONY: deploy
deploy: $(resources_deploy)

resources_undeploy := $(foreach r,$(resources),$(r).undeploy)
.PHONY: $(resources_undeploy)
$(resources_undeploy): %.undeploy: %
	@docker run --rm -v "$(shell pwd)/$<":/input \
		$(foreach v,$(EXPORTED_VARS),-e $(v)) \
		bhgedigital/envsubst sh -c "envsubst < /input" | kubectl delete --ignore-not-found -f -

.PHONY: undeploy
undeploy: $(resources_undeploy)
