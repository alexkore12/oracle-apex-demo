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
- 📚 **Documentación** - README completo + DEPLOYMENT.md
- 🛡️ **Seguridad** - Políticas y configuración de seguridad
- 💾 **Backup/Restore** - Scripts de backup y recuperación

## 🚀 Inicio Rápido

### Docker Compose

```bash
# Iniciar servicios
docker-compose up -d

# Ver estado
docker-compose ps

# Cargar schema
docker exec -i oracle-apex-demo_sql_1 sqlplus sys/<password>@localhost:1521/FREE as sysdba < schema.sql

# Verificar health
python health_check.py
```

### Acceder a Oracle APEX

Una vez corriendo:
- **APEX**: http://localhost:8080/apex
- **Oracle DB**: localhost:1521/FREE

### Configuración Inicial de APEX

1. Ir a http://localhost:8080/apex
2. Workspace interno: `INTERNAL`
3. Usuario: `admin`
4. Seguir el wizard de configuración inicial

## 📁 Estructura del Proyecto

```
oracle-apex-demo/
├── .dockerignore
├── .github/
├── .gitignore
├── CODEOWNERS
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── DEPLOYMENT.md             # Guía detallada de despliegue
├── LICENSE
├── README.md
├── SECURITY.md
├── backup_restore.sh        # Script de backup y restore
├── deploy.sh                # Script de despliegue
├── docker-compose.yml       # Oracle DB + APEX
├── health_check.py          # Verificación de salud
├── monitor.sh               # Script de monitoreo
├── schema.sql               # Schema de base de datos completo
└── setup.sh                 # Script de inicialización
```

## 🗄️ Schema de Base de Datos

El archivo `schema.sql` contiene:
- Definición de tablas principales
- Índices para optimización de consultas
- Vistas para reportes
- Secuencias y triggers
- Datos de ejemplo (seed data)

Para recargar el schema:
```bash
docker exec -i oracle-apex-demo_sql_1 sqlplus sys/<password>@localhost:1521/FREE as sysdba < schema.sql
```

## 🔧 Scripts Disponibles

| Script | Descripción |
|--------|-------------|
| `setup.sh` | Inicializa el ambiente |
| `deploy.sh` | Despliega la aplicación |
| `monitor.sh` | Monitorea servicios |
| `backup_restore.sh` | Backup y recuperación |

```bash
chmod +x setup.sh deploy.sh monitor.sh backup_restore.sh
./setup.sh
```

## 🛡️ Seguridad

Ver [SECURITY.md](SECURITY.md) para:
- Configuración de políticas de seguridad
- Gestión de usuarios y roles
- Vault de contraseñas
- Auditoría

## 📚 Documentación

- [DEPLOYMENT.md](DEPLOYMENT.md) - Guía completa de despliegue
- [SECURITY.md](SECURITY.md) - Configuración de seguridad

## 🤝 Contribuir

Lee [CONTRIBUTING.md](CONTRIBUTING.md) antes de contribuir.

## 📝 Licencia

MIT - vea [LICENSE](LICENSE)
