.PHONY: init tests build push infrastructure database simulation notebook-server

init:
	cd infrastructure/ && terraform init
tests:
	python -m pytest tests/ -rs
format:
	terraform fmt -recursive
	yapf lambdas/ \
		--style="google" \
		--recursive \
		--in-place \
		--parallel

build:
	cd lambdas/inference/ && zip -r ../../.build/lambda/inference.zip . && cd ../..
	cd lambdas/writer/ && zip -r ../../.build/lambda/writer.zip . && cd ../..
	cd lambdas/reader/ && zip -r ../../.build/lambda/reader.zip . && cd ../..
push:
	aws s3 cp \
		.build/lambda/inference.zip \
		s3://kale-miller-source-code/real-time-wine/lambdas/inference.zip
	aws s3 cp \
		.build/lambda/reader.zip \
		s3://kale-miller-source-code/real-time-wine/lambdas/reader.zip
	aws s3 cp \
		.build/lambda/writer.zip \
		s3://kale-miller-source-code/real-time-wine/lambdas/writer.zip

infrastructure:
	cd infrastructure/ && terraform apply
database:
	python scripts/fill_dynamodb.py
simulation:
	(exit 1) || echo "We haven't developed this script yet."

destroy:
	cd infrastructure/ && terraform destroy

notebook-server:
	jupyter lab --allow-root --no-browser