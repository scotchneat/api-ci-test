
.PHONY: help

PROXY_TARGET ?= http://mock:4010
SPEC_FILE = DigitalOcean-public.v2.yaml
NEWMAN_CMD = newman run tests/DigitalOcean.postman_collection.json

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	npm install && npm ls --depth=0 && ls -la node_modules/.bin

start-mockedproxy: ## Start a prism proxy (port 8080) targeting a local mock api (port 4010)
	PROXY_TARGET=$(PROXY_TARGET) docker-compose up -d

stop-services: ## Stop the proxy with mock docker services
	docker-compose down

start-prodproxy: ## Start a proxy to the production 
	 PROXY_TARGET=https://api.digitalocean.com/v2 docker-compose up proxy

test: ## Run Postman collection against local proxy with validation
	@$(NEWMAN_CMD) \
		--env-var baseUrl=http://localhost:8080 \
		--env-var accessToken=${DO_TOKEN} \
		--reporters json,cli \
		--reporter-json-export newman-results.json

bundle-spec: .install_openapi
	openapi bundle $(SPEC_FILE) -o DigitalOcean-public.v2.json

.sleep:
	sleep 3

.install_openapi:
	npm install openapi-cli
