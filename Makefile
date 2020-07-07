
.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

proxy-with-mock: ## Start a prism proxy (port 8080) targeting a local mock api (port 4010)
	docker-compose up -d

proxy-with-mock-stop: ## Stop the proxy with mock docker services
	docker-compose down

validate-proxy: ## Run Postman collection against local proxy with validation
	TARGET_API=http://localhost:8080 npm test

.sleep:
	sleep 3

validate-proxy-with-mock: proxy-with-mock .sleep validate-proxy## Lauch proxy-with-mock, run validate-proxy, then stop services
	docker-compose down
