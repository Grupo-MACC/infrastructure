# Infrastructure Automation - Terraform & Ansible

Guía rápida para desplegar infraestructura en AWS sin necesidad de ser experto en Terraform o Ansible.

## 📋 Prerequisitos

- AWS CLI configurado con credenciales
- Terraform instalado
- Ansible instalado
- Acceso SSH a las instancias EC2 (ver ssh.config.example)

## 🚀 Inicio Rápido

### Desplegar todo desde cero

```bash
make all
```

Este comando ejecuta automáticamente:
1. ✅ Backend (S3 + DynamoDB para estado)
2. ✅ Red (VPC, subredes, NAT)
3. ✅ VPC Peering (conexión entre redes)
4. ✅ Seguridad (Security Groups)
5. ✅ Cómputo (Instancias EC2, RDS)
6. ✅ Servicios (Docker, microservicios, bases de datos)

### Desplegar sin VPC Peering

Si solo necesitas una VPC:

```bash
make all-1vpc
```

## 🎯 Comandos por Componente

### Terraform (Infraestructura)

```bash
# Crear cada componente individualmente
make backend       # S3 y DynamoDB
make network       # VPC y redes
make peering       # Conexión entre VPCs
make security      # Reglas de firewall
make compute       # Servidores EC2
```

### Ansible (Configuración de Servicios)

```bash
# Configurar servidores e inicializar
make setup         # Instala Docker, clona código, despliega servicios base

# Desplegar microservicios
make deploy-services   # Despliega auth, broker, etc.

# Proceso completo
make launch        # setup + deploy-services (con pausa automática)
```

## 🔥 Destruir Infraestructura

**⚠️ Cuidado: esto eliminará todos los recursos**

```bash
# Destruir todo (en orden inverso)
make destroy-all

# O destruir componentes específicos
make destroy-compute
make destroy-security
make destroy-network
```

## ⚙️ Configuración

### Cambiar cuenta o entorno (la cuenta va a condicionar que VPC crear)

```bash
# Sintaxis
make <comando> ACCOUNT=<cuenta> ENV=<entorno>

# Ejemplos
make all ACCOUNT=account-b ENV=dev
make network ACCOUNT=account-a ENV=prod
```

**Cuentas disponibles:** `account-a`, `account-b`  
**Entornos disponibles:** `dev`, `prod`

## 📁 Estructura del Proyecto

```
infrastructure/
├── terraform/          # Definición de infraestructura AWS
│   ├── accounts/       # Por cuenta y entorno
│   ├── modules/        # Componentes reutilizables
│   └── globals/        # Variables globales
├── ansible/            # Configuración de servidores
│   ├── playbooks/      # Scripts de automatización
│   ├── roles/          # Tareas específicas
│   └── inventories/    # Hosts y variables
└── Makefile           # Comandos automatizados
```

## 🛠️ Comandos Útiles

```bash
# Ver todos los comandos disponibles
make help

# Inicializar bases de datos manualmente
make ansible-db-init

# Registrar servicios en Consul
make ansible-consul-register

# Pausar ejecución (útil para esperar RDS)
make sleep
```

## 🐛 Solución de Problemas

### Error de permisos AWS
```bash
# Verifica tus credenciales
aws sts get-caller-identity
```

### Error de conexión SSH
```bash
# Verifica el archivo ssh.config (copia desde ssh.config.example)
cp ssh.config.example ~/.ssh/config
```

### Servicios no inician
```bash
# Reinicia el proceso de configuración
make setup
make deploy-services
```

## 📝 Flujo Típico de Trabajo

1. **Primera vez (infraestructura nueva):**
   ```bash
   make all
   ```

2. **Actualizar solo servicios:**
   ```bash
   make deploy-services
   ```

3. **Reiniciar todo:**
   ```bash
   make destroy-all
   make all
   ```

4. **Trabajar en otro entorno:**
   ```bash
   make all ACCOUNT=account-b ENV=prod
   ```

## 💡 Notas Importantes

- `make all` puede tardar 15-20 minutos la primera vez
- El comando `launch` incluye pausas automáticas para esperar que RDS esté listo
- Los cambios en Terraform requieren `terraform apply` (incluido en los comandos make)
- Los playbooks de Ansible son idempotentes (puedes ejecutarlos múltiples veces)

## 📞 ¿Necesitas Ayuda?

Ejecuta `make help` para ver la lista completa de comandos con descripciones detalladas.