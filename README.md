# 🗄️ Oracle APEX Demo

[![Oracle APEX](https://img.shields.io/badge/Oracle%20APEX-23.x-orange.svg)](https://apex.oracle.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com)

## 📋 Descripción

Demo de aplicación Oracle APEX con estructura de base de datos y configuración de setup.

## ✨ Características

- 🗄️ **SQL Schema**: Estructura de base de datos
- 📦 **Setup Script**: Inicialización automática
- 🐳 **Docker**: Contenedorizable
- 📚 **Documentación**: READMEs completos

## 🚀 Uso

### Docker

```bash
docker-compose up -d
```

### Manual

```bash
sqlplus usuario/password@//localhost:1521/XEPDB1 @schema.sql
```

## 📁 Estructura

```
oracle-apex-demo/
├── .dockerignore
├── .github/
├── .gitignore
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── SECURITY.md
├── docker-compose.yml
├── schema.sql
└── setup.sh
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

MIT - [LICENSE](LICENSE)
