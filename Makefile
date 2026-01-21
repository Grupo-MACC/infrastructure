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
SCALE_DIR	 := $(BASE_DIR)/scale

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
	@echo
	@echo "🚀 Infraestructura - Gestión con Terraform y Ansible"
	@echo
	@echo "Uso:"
	@echo "  make <target> [ACCOUNT=account-a] [ENV=dev]"
	@echo
	@echo "📌 Variables (opcionales):"
	@echo "  ACCOUNT   Cuenta de AWS (por defecto: account-a)"
	@echo "  ENV       Entorno (por defecto: dev)"
	@echo
	@echo "🔧 Terraform - Despliegue"
	@echo "  all            : Backend → Red → Peering → Seguridad → Cómputo → Servicios"
	@echo "  all-1vpc       : Backend → Red → Seguridad → Cómputo → Servicios (sin peering)"
	@echo "  backend        : Crea bucket S3 + DynamoDB para estado de Terraform"
	@echo "  network        : Despliega VPC, subredes, rutas, NAT, etc."
	@echo "  peering        : Configura VPC Peering (entre cuentas o regiones)"
	@echo "  security       : Grupos de seguridad (Security Groups)"
	@echo "  compute        : Instancias EC2, bastion, microservicios"
	@echo
	@echo "🔥 Terraform - Destrucción (orden inverso)"
	@echo "  destroy-all    : Destruye todo (cómputo → seguridad → peering → red → backend)"
	@echo "  destroy-compute|security|peering|network|backend"
	@echo
	@echo "🐳 Ansible - Configuración y despliegue"
	@echo "  setup          : Configura Docker + clona repos + despliega globalservices + init DB"
	@echo "  deploy-services: Despliega y registra servicios en Consul (broker, auth, etc.)"
	@echo "  launch         : Ejecuta 'setup', espera y luego 'deploy-services'"
	@echo
	@echo "🔍 Utilidades"
	@echo "  load-repo      : Clona repositorio del microservicio"
	@echo "  sleep          : Pausa para esperar servicios (ej: RDS listo)"
	@echo "  ansible-db-init: Inicializa bases de datos en RDS (order, auth, payment, etc.)"
	@echo "  ansible-consul-register: Registra servicios actuales en Consul"
	@echo "  ansible-consul-register-rds: Registra RDS en Consul usando endpoint dinámico"
	@echo
	@echo "💡 Ejemplos:"
	@echo "  make all"
	@echo "  make network ACCOUNT=account-b ENV=dev"
	@echo "  make destroy-all ACCOUNT=account-a"
	@echo

# =========================
# Targets principales
# =========================
.PHONY: all backend network peering security compute launch

all: backend network peering security compute launch
all+scale: backend network peering security compute launch scale

all-1vpc: backend network security compute launch
all-1vpc+scale: backend network security compute launch scale


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

scale:
	@echo ">>> Scaling compute"
	cd $(SCALE_DIR) && \
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

destroy-scale:
	@echo ">>> Destroying scale"
	cd $(SCALE_DIR) && \
	$(TF) init && \
	$(TF) destroy -auto-approve

# =========================
# Ansible
# =========================
INVENTORY = inventories/dev.ini
VARS_FILE = inventories/dev_vars.yaml


setup:
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/setup-docker.yml
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/load-repo.yml
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/deploy_microservice.yml -e "target_hosts=dns"
	$(MAKE) create-rabbit-cluster
	$(MAKE) ansible-db-init

sleep:
	cd ansible && ansible-playbook playbooks/sleep.yml

deploy-services:
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/consul-register.yml -e "target_hosts=broker"
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/deploy_microservice.yml -e "target_hosts=operativeservices"
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/consul-register.yml -e "target_hosts=operativeservices,authentication"
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/deploy_microservice.yml -e "target_hosts=authentication"

# =========================
# Launch all services
# =========================
launch:
	$(MAKE) setup
	$(MAKE) sleep
	$(MAKE) deploy-services

# =========================	
# Utils
# =========================

# Utils para registro en consul
ansible-consul-register-rds:
# Debe tener permisos de ejecución: chmod +x ansible/roles/db/scripts/get-rds-host.sh
	@RDS_HOST=$$(ansible/roles/db/scripts/get-rds-host.sh); \
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" --extra-vars "rds_host=$$RDS_HOST" playbooks/consul-register-rds.yml
consul-register:
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/consul-register.yml -e "target_hosts=microservices"

# =========================
# Utils para debugging
setup-docker:
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/setup-docker.yml

load-repo:
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/load-repo.yml

# =========================
# Utils para inicialización de base de datos
ansible-db-init:
	@RDS_HOST=$$(ansible/roles/db/scripts/get-rds-host.sh); \
	echo "RDS_HOST=$$RDS_HOST"; \
	$(MAKE) ansible-consul-register-rds RDS_HOST=$$RDS_HOST; \
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" --extra-vars "rds_host=$$RDS_HOST" playbooks/db-init.yml


# =========================
# Crear clusters específicos
# =========================

create-rabbit-cluster:
#	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/setup-docker.yml
#	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/load-repo.yml
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/rabbit-node-resolution.yml
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/deploy_microservice.yml -e "target_hosts=rabbitmq_service" --extra-vars "compose_file=docker-compose-node1.yaml"
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/deploy_microservice.yml -e "target_hosts=rabbitmq_service2" --extra-vars "compose_file=docker-compose-node2.yaml"
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/rabbit-connect-cluster.yml

create-consul-cluster:
#	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/setup-docker.yml
#	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/load-repo.yml
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/deploy_microservice.yml -e "target_hosts=consul_service" --extra-vars "compose_file=docker-compose-node1.yaml"
	cd ansible && ansible-playbook -i $(INVENTORY) --extra-vars "@$(VARS_FILE)" playbooks/deploy_microservice.yml -e "target_hosts=consul_service2" --extra-vars "compose_file=docker-compose-node2.yaml"