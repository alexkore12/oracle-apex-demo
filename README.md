# 🗄️ Oracle APEX Demo

[![Oracle APEX](https://img.shields.io/badge/Oracle%20APEX-23.x-orange.svg)](https://apex.oracle.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com)

## 📋 Descripción

Demo completo de aplicación Oracle APEX con estructura de base de datos completa, configuración de setup automática y scripts de deployment.

## ✨ Características

- 🗄️ **SQL Schema** - Estructura completa de base de datos Oracle
- 📦 **Setup Script** - Inicialización automática de esquemas
- 🐳 **Docker** - Contenedorizable con docker-compose
- 🔧 **Health Check** - Script de verificación de salud
- 📚 **Documentación** - README completo
- 🛡️ **Seguridad** - Políticas y configuración de seguridad

## 🚀 Inicio Rápido

### Docker Compose

```bash
# Iniciar servicios
docker-compose up -d

# Ver estado
docker-compose ps

# Ver logs
docker-compose logs -f
```

### Configuración Manual

```bash
# Ejecutar script de setup
chmod +x setup.sh
./setup.sh

# Conectar a Oracle
sqlplus usuario/password@//localhost:1521/XEPDB1 @schema.sql
```

## 📁 Estructura del Proyecto

```
oracle-apex-demo/
├── schema.sql              # Definición de esquemas y tablas
├── setup.sh               # Script de configuración
├── health_check.py       # Script de health check
├── docker-compose.yml    # Orquestación Docker
├── Dockerfile            # Imagen Oracle APEX
├── .dockerignore
├── .env.example
├── .gitignore
├── LICENSE
├── CODEOWNERS
├── CONTRIBUTING.md
├── SECURITY.md
├── CODE_OF_CONDUCT.md
└── README.md
```

## 🛠️ Requisitos

- Oracle Database 21c o superior
- Oracle APEX 23.x
- Docker (opcional)

## 📄 Configuración de Base de Datos

```sql
-- Conectar como SYSDBA
sqlplus / as sysdba

-- Crear tablespace
CREATE TABLESPACE apex_data
DATAFILE 'apex_data.dbf'
SIZE 100M AUTOEXTEND ON;

-- Crear usuario
CREATE USER apexuser IDENTIFIED BY password
DEFAULT TABLESPACE apex_data
QUOTA UNLIMITED ON apex_data;
```

## 🔧 Scripts Disponibles

| Script | Descripción |
|--------|-------------|
| `schema.sql` | Define estructura de BD |
| `setup.sh` | Inicialización automática |

## 🌐 Referencias

- [Oracle APEX Documentation](https://docs.oracle.com/en/database/oracle/apex/)
- [Oracle Live SQL](https://livesql.oracle.com/)
- [Docker Hub - Oracle Database](https://hub.docker.com/_/oracle-database)

## 📝 Licencia

## 🐳 Docker
>>>>>>> f3b8ad25eeed36d6866dde9159e92c4847719e49

### Variables de Entorno

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| `ORACLE_PWD` | Password de SYS | oracle |
| `ORACLE_DATABASE` | Nombre PDB | XEPDB1 |
| `ORACLE_CHARSET` | Charset | AL32UTF8 |
| `APEX_ADMIN_EMAIL` | Email admin | admin@example.com |
| `APEX_ADMIN_PASSWORD` | Password admin | apex123 |

### Puertos

| Puerto | Servicio |
|--------|----------|
| 1521 | Oracle Listener |
| 5500 | Oracle EM Express |

### Build Personalizado

```bash
docker build -t oracle-apex-demo .
docker run -d -p 1521:1521 -p 5500:5500 oracle-apex-demo
```

## 🗄️ Schema SQL

### Tablas Principales

El archivo `schema.sql` contiene:

- Definición de tablespaces
- Creación de usuarios/esquemas
- Tablas de aplicación
- Sequences, triggers
- Procedures y functions
- Vistas de soporte

### Ejecutar SQL Manual

```bash
# Con docker exec
docker exec -it oracle-apex-demo sqlplus / as sysdba

# Ejecutar script
@schema.sql
```

## 🔧 Health Check

```bash
python3 health_check.py
```

Verifica:
- Conexión a Oracle
- Estado del listener
- Tablespaces disponibles
- Esquemas existentes

## 🔐 Seguridad

### Configuración de Credenciales

```bash
# Usar variables de entorno
export ORACLE_PWD="tu_password_seguro"
export ORACLE_DATABASE="XEPDB1"
```

### Mejores Prácticas

1. **No** exponer Oracle directamente a internet
2. Usar password complejo para SYS/SYSTEM
3. Limitar privilegios de usuarios de aplicación
4. Habilitar audit trail
5. Mantener Oracle patched

## ☁️ Deployment

### Oracle Cloud

```bash
# Crear ATP (Autonomous Transaction Processing)
oci db autonomous-database create \
    --compartment-id $COMPARTMENT_ID \
    --display-name "apex-demo" \
    --db-name "apexdemo" \
    --cpu-core-count 1 \
    --storage-tb 1
```

### On-Premise

Requisitos:
- Oracle Database 19c+
- 8GB RAM mínimo
- 50GB disco

## 📝 Changelog

### v2.0.0 (2026-03-23)
- ✅ health_check.py añadido
- ✅ setup.sh mejorado
- ✅ README completo
- ✅ CODEOWNERS añadido
- ✅ Docker Compose optimizado

### v1.0.0 (2026-03-21)
- ✅ Schema SQL inicial
- ✅ Docker support básico

## 🤝 Contributing

Ver [CONTRIBUTING.md](CONTRIBUTING.md) para guidelines.

## 📄 Licencia

MIT - ver [LICENSE](LICENSE) para detalles.

## 👤 Autor

**alexkore12** - https://github.com/alexkore12

## 🤖 Actualizado por

OpenClaw AI Assistant - 2026-03-23
*Mejoras: health check, setup script, documentación completa*
