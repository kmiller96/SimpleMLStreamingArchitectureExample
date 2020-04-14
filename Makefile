AWS_PROFILE ?= default
SOURCE_CODE_BUCKET ?= kalemiller-lambda-source-code

BUILD_DIRECTORY ?= ${PWD}/.build
export TF_VAR_build_directory=$(BUILD_DIRECTORY)

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

notebook-server:
	jupyter lab --allow-root --no-browser
.PHONY: notebook-server



build:
	@echo ""
	@echo "--> Building the ML model lambda..."
	@cd lambdas/model/ && \
		zip -r ../../.build/lambda/model.zip . -x '*__pycache__/*' && \
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
	aws s3 cp \
		--profile $(AWS_PROFILE) \
		.build/lambda/model.zip \
		s3://kalemiller-lambda-source-code/real-time-wine/lambdas/model.zip
	aws s3 cp \
		--profile $(AWS_PROFILE) \
		.build/lambda/reader.zip \
		s3://kalemiller-lambda-source-code/real-time-wine/lambdas/reader.zip
	aws s3 cp \
		--profile $(AWS_PROFILE) \
		.build/lambda/writer.zip \
		s3://kalemiller-lambda-source-code/real-time-wine/lambdas/writer.zip
.PHONY: push



infrastructure:
	cd infrastructure/ && terraform apply
.PHONY: infrastructure

model:
	python scripts/train_model.py data/full.csv --k-folds=10
.PHONY: model

one:
	python scripts/fill_dynamodb.py -n 1
.PHONY: database

database:
	python scripts/fill_dynamodb.py -n 200
.PHONY: database

database-full:
	python scripts/fill_dynamodb.py -n 100000
.PHONY: database-full

peturb:
	(exit 1) || echo "We haven't developed this script yet."
.PHONY: database

simulation:
	(exit 1) || echo "We haven't developed this script yet."
.PHONY: simulation


deploy: build push infrastructure database
.PHONY: deploy

destroy:
	cd infrastructure/ && terraform destroy 
.PHONY: destroy
