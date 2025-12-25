# =========================
# Configuración
# =========================
ACCOUNT ?= account-a
ENV     ?= dev

BASE_DIR := terraform/accounts/$(ACCOUNT)/$(ENV)

BACKEND_DIR  := $(BASE_DIR)/backend-boostrap
NETWORK_DIR  := $(BASE_DIR)/network
PEERING_DIR  := $(BASE_DIR)/vpc-peering
SECURITY_DIR := $(BASE_DIR)/security
COMPUTE_DIR  := $(BASE_DIR)/compute

TF := terraform

# =========================
# Target por defecto
# =========================
.DEFAULT_GOAL := help

# =========================
# Ayuda
# =========================
.PHONY: help
help:
	@echo ""
	@echo "Uso:"
	@echo "  make <target> [ACCOUNT=account-a] [ENV=dev]"
	@echo ""
	@echo "Targets disponibles:"
	@echo "  help              Muestra esta ayuda"
	@echo "  all               Ejecuta todo en orden: backend → network → peering → security → compute"
	@echo "  backend           Despliega el backend (S3/Dynamo para Terraform state)"
	@echo "  network           Despliega la red (VPC)"
	@echo "  peering   		   Despliega el peering (VPC Peering)"
	@echo "  security          Despliega seguridad (security groups, etc.)"
	@echo "  compute           Despliega cómputo (EC2, bastion, etc.)"
	@echo "  aws-credentials   Abre ~/.aws/credentials"
	@echo ""
	@echo "Ejemplos:"
	@echo "  make all"
	@echo "  make network ACCOUNT=account-b ENV=dev"
	@echo "  make aws-credentials"
	@echo ""

# =========================
# Targets principales
# =========================
.PHONY: all backend network peering security compute ansible-launch

all: backend network peering security compute ansible-launch

all-1vpc: backend network security compute ansible-launch

backend:
	@echo ">>> Deploying backend"
	cd $(BACKEND_DIR) && \
	$(TF) init && \
	$(TF) apply -auto-approve

network:
	@echo ">>> Deploying network (VPC)"
	cd $(NETWORK_DIR) && \
	$(TF) init && \
	$(TF) apply -auto-approve

peering:
	@echo ">>> Deploying peering (VPC Peering)"
	cd $(PEERING_DIR) && \
	$(TF) init && \
	$(TF) apply -auto-approve

security:
	@echo ">>> Deploying security"
	cd $(SECURITY_DIR) && \
	$(TF) init && \
	$(TF) apply -auto-approve

compute:
	@echo ">>> Deploying compute"
	cd $(COMPUTE_DIR) && \
	$(TF) init && \
	$(TF) apply -auto-approve


# =========================
# Destroy (orden inverso)
# =========================
.PHONY: destroy-all destroy-backend destroy-network destroy-peering destroy-security destroy-compute

destroy-all: destroy-compute destroy-security destroy-peering destroy-network destroy-backend

destroy-compute:
	@echo ">>> Destroying compute"
	cd $(COMPUTE_DIR) && \
	$(TF) init && \
	$(TF) destroy -auto-approve

destroy-security:
	@echo ">>> Destroying security"
	cd $(SECURITY_DIR) && \
	$(TF) init && \
	$(TF) destroy -auto-approve

destroy-peering:
	@echo ">>> Destroying peering"
	cd $(PEERING_DIR) && \
	$(TF) init && \
	$(TF) destroy -auto-approve

destroy-network:
	@echo ">>> Destroying network"
	cd $(NETWORK_DIR) && \
	$(TF) init && \
	$(TF) destroy -auto-approve

destroy-backend:
	@echo ">>> Destroying backend"
	cd $(BACKEND_DIR) && \
	$(TF) init && \
	$(TF) destroy -auto-approve

# =========================
# Ansible
# =========================
INVENTORY = inventories/dev.ini
VARS_FILE = inventories/dev_vars.yaml

ansible-consul-register:
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/consul-register.yml

ansible-launch:
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/setup-docker.yml
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/load-repo.yml
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/deploy_microservice.yml -e "target_hosts=globalservices"
	cd ansible && ansible-playbook playbooks/sleep.yml
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/consul-register.yml -e "target_hosts=broker"
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/deploy_microservice.yml -e "target_hosts=operativeservices"
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/consul-register.yml -e "target_hosts=operativeservices,authentication"
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/deploy_microservice.yml -e "target_hosts=authentication"
