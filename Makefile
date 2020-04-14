AWS_PROFILE ?= default

init:
	conda env update --file environment.yaml --name real-time-wine --prune 
	cd infrastructure/ && terraform init
	@echo ""
	@echo "==> Make sure you activate the conda environment 'real-time-wine' <=="
	@echo ""
.PHONY: init

export:
	conda env export > environment.yaml
.PHONY: export

tests:
	python -m pytest tests/ -rs --all 
.PHONY: tests

format:
	terraform fmt -recursive
	black lambdas/ scripts/
.PHONY: format



build:
	cd lambdas/inference/ && zip -r ../../.build/lambda/inference.zip . && cd ../..
	cd lambdas/writer/ && zip -r ../../.build/lambda/writer.zip . && cd ../..
	cd lambdas/reader/ && zip -r ../../.build/lambda/reader.zip . && cd ../..
.PHONY: build

push:
	aws s3 cp \
		--profile $(AWS_PROFILE) \
		.build/lambda/inference.zip \
		s3://kale-miller-source-code/real-time-wine/lambdas/inference.zip
	aws s3 cp \
		--profile $(AWS_PROFILE) \
		.build/lambda/reader.zip \
		s3://kale-miller-source-code/real-time-wine/lambdas/reader.zip
	aws s3 cp \
		--profile $(AWS_PROFILE) \
		.build/lambda/writer.zip \
		s3://kale-miller-source-code/real-time-wine/lambdas/writer.zip
.PHONY: push



infrastructure:
	cd infrastructure/ && terraform apply
.PHONY: infrastructure

database:
	python scripts/fill_dynamodb.py -n 200
.PHONY: database

database-full:
	python scripts/fill_dynamodb.py -n 100000
.PHONY: database-full

simulation:
	(exit 1) || echo "We haven't developed this script yet."
.PHONY: simulation



destroy:
	cd infrastructure/ && terraform destroy 
.PHONY: destroy



notebook-server:
	jupyter lab --allow-root --no-browser
.PHONY: notebook-server