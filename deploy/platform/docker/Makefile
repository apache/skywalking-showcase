include ../../../Makefile.in

.PHONY: deploy
deploy:
	docker-compose up -d

.PHONY: undeploy
undeploy:
	docker-compose --log-level ERROR down
