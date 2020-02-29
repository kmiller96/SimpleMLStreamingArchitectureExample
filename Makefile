.PHONY: init tests build push deploy database simulation notebook-server

init:
	cd infrastructure/ && terraform init
tests:
	python -m pytest tests/
format:
	terraform fmt -recursive
	# yapf

build:
	(exit 1) || echo "We haven't developed this script yet."
push:
	(exit 1) || echo "We haven't developed this script yet."

deploy:
	cd infrastructure/ && terraform apply
database:
	(exit 1) || echo "We haven't developed this script yet."
simulation:
	(exit 1) || echo "We haven't developed this script yet."

notebook-server:
	jupyter lab --allow-root --no-browser