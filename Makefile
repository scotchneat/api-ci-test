
.PHONY: help

PRISM_DOCKER_CMD = docker run -it --rm -d --name prism-base -p 8080:4010 -v $(PWD):/prism stoplight/prism:latest
PROXY_TARGET ?= http://mock:4010

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

proxy-with-mock: ## Start a prism proxy (port 8080) targeting a local mock api (port 4010)
	PROXY_TARGET=$(PROXY_TARGET) docker-compose up -d

stop-services: ## Stop the proxy with mock docker services
	docker-compose down

proxy-to-prod: ## Start a proxy to the production 
	 PROXY_TARGET=https://api.digitalocean.com/v2 docker-compose up proxy
	#  $(PRISM_DOCKER_CMD) proxy -h 0.0.0.0 /prism/DigitalOcean-public.v2.yaml $(PROXY_TARGET)

validate-proxy: ## Run Postman collection against local proxy with validation
	TARGET_API=http://localhost:8080 npm test

.sleep:
	sleep 3
