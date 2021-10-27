include ../../../Makefile.in

.PHONY: deploy
deploy:
	export HUB=$(HUB); \
	export TAG=$(TAG); \
	docker-compose up -d

.PHONY: undeploy
undeploy:
	export HUB=$(HUB); \
	export TAG=$(TAG); \
	docker-compose down
