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
	@terraform -chdir=nextflow init -backend-config="envs/dev.backend.config.json"

.PHONY: plan
plan: ## Plan TF
	@terraform -chdir=nextflow plan -var-file="envs/dev.tfvars.json"

.PHONY: apply
apply: ## Apply TF
	@terraform -chdir=nextflow apply -var-file="envs/dev.tfvars.json" -auto-approve

.PHONY: deploy
deploy: ## Deploy TF
	@make init
	@make apply

.PHONY: decrypt
decrypt: ## Decrypt secrets
	@sops --output-type json --decrypt nextflow/envs/dev.backend.config.json.enc > nextflow/envs/dev.backend.config.json
	@sops --output-type json --decrypt nextflow/envs/dev.tfvars.json.enc > nextflow/envs/dev.tfvars.json
	@sops --output-type json --decrypt nextflow/envs/main.backend.config.json.enc > nextflow/envs/main.backend.config.json
	@sops --output-type json --decrypt nextflow/envs/main.tfvars.json.enc > nextflow/envs/main.tfvars.json

.PHONY: encrypt
encrypt: ## Encrypt secrets
	@sops --input-type json --encrypt nextflow/envs/dev.backend.config.json > nextflow/envs/dev.backend.config.json.enc
	@sops --input-type json --encrypt nextflow/envs/dev.tfvars.json > nextflow/envs/dev.tfvars.json.enc
	@sops --input-type json --encrypt nextflow/envs/main.backend.config.json > nextflow/envs/main.backend.config.json.enc
	@sops --input-type json --encrypt nextflow/envs/main.tfvars.json > nextflow/envs/main.tfvars.json.enc
