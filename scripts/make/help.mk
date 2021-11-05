##@ Other targets

define usage
  You can customize the settings in Makefile.in
  by specifying the variable in make command:

  $$ make deploy.docker FEATURE_FLAGS=agent,vm

  or via environment variable:

  $$ export FEATURE_FLAGS=single-node,agent,vm && make deploy.docker
  $$ export FEATURE_FLAGS=cluster,agent,vm && make deploy.docker
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
highlight:  ## Highlight the important points of a feature
	@if [ "$(FEATURE_FLAGS)" = "" ]; then \
	  echo 'FEATURE_FLAGS must be set in highlight target'; \
  	  exit 1; \
  	fi
	@grep --color -rnw . -e "$(features)"
