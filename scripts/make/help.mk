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

##@ Other targets

define usage
  You can customize the settings in Makefile.in
  by specifying the variable in make command:

  $$ make deploy.docker FEATURE_FLAGS=agent,vm,mysql

  or via environment variable:

  $$ export FEATURE_FLAGS=single-node,agent,vm,mysql && make deploy.docker
  $$ export FEATURE_FLAGS=cluster,agent,vm,mysql && make deploy.docker
endef

export usage

.PHONY: help
help:  ## Display this help
	@echo ''
	@echo 'Usage:'
	@echo "$$usage"
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
			/^[.a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m \t%s\n", $$1, $$2 } \
			/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)

features := $(subst $(comma), ,$(FEATURE_FLAGS))
features := $(foreach f,$(features),@feature: *$(f)*)

.PHONY: highlight
highlight:  ## Highlight the important contents of a feature
	@if [ "$(FEATURE_FLAGS)" = "" ]; then \
	  echo 'FEATURE_FLAGS must be set in highlight target'; \
  	  exit 1; \
  	fi
	@grep --color -rnw . -e "$(features)"
