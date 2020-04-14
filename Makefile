AWS_PROFILE ?= default
SOURCE_CODE_BUCKET ?= kalemiller-lambda-source-code

init:
	mkdir -p .build/lambda/
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
	@echo ""
	@echo "--> Building the inference lambda..."
	@cd lambdas/inference/ && \
		zip -r ../../.build/lambda/inference.zip . -x '*__pycache__/*' && \
	cd ../..

	@echo ""
	@echo "--> Building the writer lambda..."
	@cd lambdas/writer/ && \
		zip -r ../../.build/lambda/writer.zip . -x '*__pycache__/*' && \
	cd ../..

	@echo ""
	@echo "--> Building the reader lambda..."
	@cd lambdas/reader/ && \
		zip -r ../../.build/lambda/reader.zip . -x '*__pycache__/*' && \
	cd ../..
.PHONY: build

push:
	@aws s3 cp \
		--profile $(AWS_PROFILE) \
		.build/lambda/inference.zip \
		"s3://$(SOURCE_CODE_BUCKET)/real-time-wine/lambdas/inference.zip"
	@aws s3 cp \
		--profile $(AWS_PROFILE) \
		.build/lambda/reader.zip \
		"s3://$(SOURCE_CODE_BUCKET)/real-time-wine/lambdas/reader.zip"
	@aws s3 cp \
		--profile $(AWS_PROFILE) \
		.build/lambda/writer.zip \
		"s3://$(SOURCE_CODE_BUCKET)/real-time-wine/lambdas/writer.zip"
.PHONY: push



infrastructure:
	cd infrastructure/ && terraform apply
.PHONY: infrastructure

model:
	python scripts/train_model.py data/full.csv --k-folds=10
.PHONY: model

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