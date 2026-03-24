# 🗄️ Oracle APEX Demo

> Demo completo de aplicación Oracle Application Express (APEX) con estructura de base de datos, configuración automática y scripts de deployment.

[![Oracle APEX](https://img.shields.io/badge/Oracle%20APEX-23.x-orange.svg)](https://apex.oracle.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com)

## 📋 Descripción

Aplicación demo que demuestra las capacidades de Oracle APEX 23.x incluyendo:
- Esquema de base de datos completo
- Aplicación web interactiva
- Reportes y gráficos
- Autenticación y autorización
- REST API integration
- Configuración de deployment automatizada

## ✨ Características

- 🗄️ **SQL Schema** - Estructura completa con tablas, vistas, secuencias
- 📦 **Setup Script** - Inicialización automática del esquema
- 🐳 **Docker** - Oracle XE oORDS en contenedores
- 🔧 **Health Check** - Verificación de salud del sistema
- 📚 **Documentación** - Guía completa de uso
- 🛡️ **Seguridad** - VPD, políticas de seguridad
- 📊 **Reporting** - Dashboards y reportes
- 🔄 **REST Services** - Publicación de REST APIs
- 📱 **Responsive** - Diseño adaptativo

## 🚀 Inicio Rápido

### Docker Compose (Recomendado)

```bash
# Clonar repositorio
git clone https://github.com/alexkore12/oracle-apex-demo.git
cd oracle-apex-demo

# Iniciar servicios
docker-compose up -d

# Ver estado
docker-compose ps

# Esperar a que Oracle esté listo (~5 min)
docker-compose logs -f oracle-xe

# Acceder a APEX
# URL: http://localhost:8080
# Workspace: INTERNAL
# User: ADMIN
# Password: Ver en docker-compose.yml o logs
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
├── schema.sql              # Definición completa del esquema
├── setup.sh               # Script de setup
├── docker-compose.yml     # Oracle XE + ORDS
├── monitor.sh             # Health check
├── .github/
│   ├── dependabot.yml     # Actualizaciones automáticas
│   └── CODEOWNERS         # Propietarios
├── SECURITY.md            # Política de seguridad
├── CONTRIBUTING.md        # Guía de contribución
├── CODE_OF_CONDUCT.md
├── LICENSE
└── README.md
```

## 🗄️ Esquema de Base de Datos

### Tablas Principales

```sql
-- Tabla de ejemplo: EMPLEADOS
CREATE TABLE empleados (
    id_empleado NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    apellido VARCHAR2(100) NOT NULL,
    email VARCHAR2(255) UNIQUE NOT NULL,
    departamento_id NUMBER,
    salario NUMBER(10,2),
    fecha_contratacion DATE DEFAULT SYSDATE,
    activo CHAR(1) DEFAULT 'Y',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: DEPARTAMENTOS
CREATE TABLE departamentos (
    id_departamento NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    ubicacion VARCHAR2(200),
    presupuesto NUMBER(12,2)
);

-- Tabla: PROYECTOS
CREATE TABLE proyectos (
    id_proyecto NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(200) NOT NULL,
    descripcion CLOB,
    fecha_inicio DATE,
    fecha_fin DATE,
    estado VARCHAR2(50),
    lead_id NUMBER REFERENCES empleados(id_empleado)
);
```

## 🌐 Acceso a la Aplicación

### URLs

| Servicio | URL | Puerto |
|----------|-----|--------|
| Oracle APEX | http://localhost:8080 | 8080 |
| ORDS Admin | http://localhost:8080/ords | 8080 |
| SQL Developer Web | http://localhost:8080/ords/sql-developer | 8080 |

### Credenciales

```
Workspace: DEMO_WORKSPACE
User: ADMIN
Password: Oracle123! (cambiar en producción)
```

## 🐳 Docker Configuration

### Servicios

```yaml
services:
  oracle-xe:
    image: container-registry.oracle.com/database/express:21.3.0
    ports:
      - "1521:1521"
    environment:
      ORACLE_PWD: Oracle123!
      
  ords:
    image: container-registry.oracle.com/database/ords:23.2
    ports:
      - "8080:8080"
    depends_on:
      - oracle-xe
```

### Comandos Útiles

```bash
# Iniciar
docker-compose up -d

# Ver logs
docker-compose logs -f

# Backup de BD
docker-compose exec oracle-xe expdp user/password full=Y

# Restaurar
docker-compose exec oracle-xe impdp user/password full=Y
```

## 📊 Desarrollo APEX

### Importar Aplicación

1. Acceder a APEX Workspace
2. Ir a: Application Builder → Import
3. Subir archivo `f100.sql`
4. Configurar workspaces y autenticación

### Crear REST API

```sql
-- Habilitar ORDS
BEGIN
    ORDS.ENABLE_OBJECT(p_object => 'EMPLOYEES');
    COMMIT;
END;
/

-- Crear módulo REST
BEGIN
    ORDS.DEFINE_MODULE(
        p_module_name => 'demo-api',
        p_base_path => '/demo/',
        p_items_per_page => 25
    );
    
    ORDS.DEFINE_TEMPLATE(
        p_module_name => 'demo-api',
        p_pattern => 'employees',
        p_priority => 0,
        p_etag_type => 'HASH'
    );
    
    ORDS.DEFINE_HANDLER(
        p_module_name => 'demo-api',
        p_pattern => 'employees',
        p_method => 'GET',
        p_source_type => 'JSON_QUERY'
    );
END;
/
```

## 🔒 Seguridad

### Mejores Prácticas

- ✅ Cambiar contraseñas por defecto
- ✅ Usar Oracle Wallet para credenciales
- ✅ Habilitar VPD (Virtual Private Database)
- ✅ Configurar Audit Vault
- ✅ Usar HTTPS en producción
- ✅ Sanitizar inputs (SQL injection prevention)

Ver [SECURITY.md](SECURITY.md) para detalles completos.

## 📈 Monitoreo

```bash
# Health check
./monitor.sh

# Ver sesiones
sqlplus system/password@//localhost:1521/XEPDB1 @check_sessions.sql

# Ver tablaspace usage
sqlplus system/password@//localhost:1521/XEPDB1 @tablespace_usage.sql
```

## 🤝 Contribuir

1. Fork → Branch → Commit → PR
2. Scripts SQL deben seguir coding standards
3. Tests de integración incluidos
4. Documentación actualizada

## 📄 Licencia

MIT - ver [LICENSE](LICENSE)

## 🔗 Recursos

- [Oracle APEX Documentation](https://docs.oracle.com/en/database/oracle/application-express/)
- [Oracle Live SQL](https://livesql.oracle.com/)
- [APEX Community](https://apex.oracle.com/community)
