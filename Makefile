help: ## Show this manual
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-10s\033[0m%s\n",$$1,$$2}' $(MAKEFILE_LIST)



init: ## Initialize the workspace
	@python -m virtualenv .venv
	@.venv/bin/pip install -r requirements.txt
	@source .venv/bin/activate



build: ## Build the container image
	@[ -d .build ] && rm -rf .build
	@mkdir .build
	@cp src/* .builds/
	@docker build -t gcr.io/aleroxac/panaceia:v1 -f infra/docker/Dockerfile .build/



run: ## Run the application locally
	@python src/app.py
