TFVARS_FILE := terraform.tfvars

.PHONY: init validate fmt plan apply destroy output clean

install:
	scoop install terraform
	pip install pre-commit
	pip install checkov
	pre-commit install

init:
	terraform init

validate: init
	terraform validate

fmt:
	terraform fmt -recursive

plan: init
	terraform plan -var-file=$(TFVARS_FILE)

apply: init
	terraform apply -var-file=$(TFVARS_FILE)

apply-auto: init
	terraform apply -var-file=$(TFVARS_FILE) -auto-approve

destroy: init
	terraform destroy -var-file=$(TFVARS_FILE)

destroy-auto: init
	terraform destroy -var-file=$(TFVARS_FILE) -auto-approve

output:
	terraform output

clean:
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate.backup

help:
	@grep -E '^##' $(MAKEFILE_LIST) | sed 's/## //'
