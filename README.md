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

## 📝 Licencia

MIT - [LICENSE](LICENSE)
