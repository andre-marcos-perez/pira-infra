.PHONY: help
help: ## Show this help message
	@grep -h -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: format
format: ## Format code
	@terraform -chdir=nextflow fmt -recursive

.PHONY: lint
lint: ## Lint code
	@terraform -chdir=nextflow validate

.PHONY: init
init: ## Init Terraform
	@terraform -chdir=nextflow init -backend-config="./backend.config"
