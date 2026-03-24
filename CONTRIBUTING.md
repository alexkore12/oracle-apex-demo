# 🤝 Guía de Contribución

¡Gracias por tu interés en contribuir al proyecto Oracle APEX Demo!

## 📋 Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [Primeros Pasos](#primeros-pasos)
- [Cómo Contribuir](#cómo-contribuir)
- [Estándares SQL](#estándares-sql)
- [Estructura de Carpetas](#estructura-de-carpetas)
- [Testing](#testing)
- [Deployment](#deployment)

## Código de Conducta

Mantén un ambiente respetuoso y profesional en todas las interacciones.

## Primeros Pasos

### Setup de Desarrollo

```bash
# Clonar repositorio
git clone https://github.com/alexkore12/oracle-apex-demo.git
cd oracle-apex-demo

# Iniciar ambiente con Docker
docker-compose up -d

# Verificar que todo está corriendo
./monitor.sh

# Conectar a SQL*Plus
docker-compose exec oracle-xe sqlplus demo/demo@//localhost:1521/XEPDB1
```

### Herramientas Recomendadas

- SQL Developer (desktop o web)
- Oracle APEX 23.x
- Docker Desktop
- Git

## Cómo Contribuir

### Tipos de Contribuciones

- 🗄️ **Schema Changes** - Nuevas tablas, índices, constraints
- 📊 **APEX Pages** - Nuevas páginas, regiones, procesos
- 🔧 **PL/SQL** - Procedimientos, funciones, triggers
- 📝 **Documentation** - Mejoras en README, guías
- 🐛 **Bug Fixes** - Corrección de errores
- 🔒 **Security** - Mejoras de seguridad

### Proceso

1. **Fork** el repositorio
2. **Crear branch**:
   ```bash
   git checkout -b feature/nueva-funcionalidad
   # o
   git checkout -b fix/correccion-bug
   ```
3. **Desarrollar** cambios
4. **Testear** localmente
5. **Commit**:
   ```bash
   git commit -m "feat: agregar nueva tabla deaudit log"
   ```
6. **Push** y crear PR

## Estándares SQL

### Naming Conventions

```sql
-- Tablas: PLURAL, UPPER_SNAKE_CASE
CREATE TABLE employees (...);
CREATE TABLE project_assignments (...);

-- Columnas: UPPER_SNAKE_CASE
employee_id, first_name, hire_date, salary_amount

-- Constraints: tabla_columna_tipo
employees_pk, employees_email_uk, employees_dept_fk

-- Secuencias: tabla_seq
employees_seq, departments_seq
```

### Buenas Prácticas

```sql
-- ✅ Usar con約束 (constraints) apropiadas
CREATE TABLE employees (
    id_empleado NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    email VARCHAR2(255) CONSTRAINT emp_email_uk UNIQUE,
    salario NUMBER(10,2) CONSTRAINT emp_salario_ck CHECK (salario > 0),
    dept_id NUMBER CONSTRAINT emp_dept_fk REFERENCES departments(id)
);

-- ✅ Usar comentários
COMMENT ON TABLE employees IS 'Tabla principal de empleados del sistema';
COMMENT ON COLUMN employees.id_empleado IS 'Identificador único auto-generado';

-- ✅ Incluir auditoría
CREATE TABLE employees (
    ...
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by VARCHAR2(100),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR2(100)
);
```

### Código PL/SQL

```sql
-- ✅ Usar PACKAGE para organizar
CREATE OR REPLACE PACKAGE emp_api AS
    PROCEDURE create_employee(
        p_nombre IN employees.nombre%TYPE,
        p_email IN employees.email%TYPE,
        p_salario IN employees.salario%TYPE
    );
    
    FUNCTION get_employee(p_id IN employees.id_empleado%TYPE)
        RETURN employees%ROWTYPE;
END emp_api;
/

CREATE OR REPLACE PACKAGE BODY emp_api AS
    PROCEDURE create_employee(...) IS
    BEGIN
        INSERT INTO employees (nombre, email, salario)
        VALUES (p_nombre, p_email, p_salario);
    END;
    
    FUNCTION get_employee(...) RETURN ... IS
    BEGIN
        SELECT * INTO ...
        RETURN emp_row;
    END;
END emp_api;
/
```

## Estructura de Carpetas

```
oracle-apex-demo/
├── schema/
│   ├── 01_tables.sql
│   ├── 02_sequences.sql
│   ├── 03_indexes.sql
│   ├── 04_constraints.sql
│   ├── 05_views.sql
│   ├── 06_packages.sql
│   ├── 07_functions.sql
│   ├── 08_procedures.sql
│   ├── 09_triggers.sql
│   └── 10_seed_data.sql
├── apex/
│   ├── export.sql
│   └── applications/
├── scripts/
│   ├── setup.sh
│   ├── backup.sh
│   └── restore.sh
├── docker-compose.yml
├── .env.example
└── README.md
```

## Testing

### Tests Manuales

```bash
# 1. Verificar que Docker está corriendo
docker-compose ps

# 2. Verificar acceso a APEX
curl -I http://localhost:8080

# 3. Verificar conexión a BD
docker-compose exec oracle-xe sqlplus -L demo/demo@//localhost:1521/XEPDB1 "SELECT * FROM global_name;"

# 4. Verificar schema
docker-compose exec oracle-xe sqlplus demo/demo@//localhost:1521/XEPDB1 @schema/verify.sql
```

### Tests Automatizados

```sql
-- Crear script de test
-- tests/test_employees.sql

SET SERVEROUTPUT ON
DECLARE
    v_count NUMBER;
BEGIN
    -- Test: Insertar empleado
    INSERT INTO employees (nombre, email, salario)
    VALUES ('Test', 'test@example.com', 50000);
    
    -- Verificar
    SELECT COUNT(*) INTO v_count 
    FROM employees 
    WHERE email = 'test@example.com';
    
    IF v_count = 1 THEN
        DBMS_OUTPUT.PUT_LINE('✅ Test passed');
    ELSE
        DBMS_OUTPUT.PUT_LINE('❌ Test failed');
    END IF;
    
    -- Cleanup
    DELETE FROM employees WHERE email = 'test@example.com';
    COMMIT;
END;
/
```

## Deployment

### Ambientes

| Ambiente | URL | Uso |
|----------|-----|-----|
| Local | http://localhost:8080 | Desarrollo |
| Dev | https://dev.example.com | Testing |
| Prod | https://apex.example.com | Producción |

### Scripts de Deployment

```bash
# Desarrollo
./scripts/setup.sh

# Backup antes de deploy
./scripts/backup.sh

# Deploy a producción
./scripts/deploy.sh --env=production
```

## 📧 Contacto

Para preguntas: abrir issue o contactar al maintainer.

---

¡Gracias por contribuir! 🙏
