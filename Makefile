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
init: ## Init TF
	@terraform -chdir=nextflow init -backend-config="./backend.config.json"

.PHONY: plan
plan: ## Plan TF
	@terraform -chdir=nextflow plan -var-file="dev.tfvars.json"

.PHONY: apply
apply: ## Apply TF
	@terraform -chdir=nextflow apply -var-file="dev.tfvars.json" -auto-approve

.PHONY: deploy
deploy: ## Deploy TF
	@make init
	@make apply

.PHONY: decrypt
decrypt: ## Decrypt secrets
	@sops --output-type json --decrypt nextflow/backend.config.json.enc > nextflow/backend.config.json
	@sops --output-type json --decrypt nextflow/dev.tfvars.json.enc > nextflow/dev.tfvars.json
	@sops --output-type json --decrypt nextflow/main.tfvars.json.enc > nextflow/main.tfvars.json

.PHONY: encrypt
encrypt: ## Encrypt secrets
	@sops --input-type json --encrypt nextflow/backend.config.json > nextflow/backend.config.json.enc
	@sops --input-type json --encrypt nextflow/dev.tfvars.json > nextflow/dev.tfvars.json.enc
	@sops --input-type json --encrypt nextflow/main.tfvars.json > nextflow/main.tfvars.json.enc
