# 🗄️ Oracle APEX Demo

Aplicación demo completa para Oracle APEX con ejemplos avanzados de PL/SQL y diseño de base de datos empresarial.

## 📋 Descripción

Este proyecto contiene un esquema de base de datos completo para Oracle APEX con ejemplos de:
- Tablas relacionales con jerarquías
- Procedures y funciones PL/SQL
- Triggers para auditoría
- Vistas materializadas
- Índices optimizados

## 🛠️ Componentes

### Tablas Principales

| Tabla | Descripción |
|-------|-------------|
| `employees` | Empleados con datos personales y laborales |
| `departments` | Departamentos organizacionales |
| `jobs` | Catálogo de puestos |
| `locations` | Ubicaciones geográficas |
| `audit_log` | Auditoría de cambios |

### Características

- ✅ **IDENTITY Columns** - Auto-increment nativos
- ✅ **Auditoría Completa** - Tracking de cambios
- ✅ **Índices Optimizados** - Para mejor rendimiento
- ✅ **Relaciones** - Foreign keys bien definidas
- ✅ **Tipos de Datos** - VARCHAR2, NUMBER, DATE, TIMESTAMP, CLOB

## 🚀 Instalación

### Prerrequisitos

- Oracle Database 12c+
- Oracle APEX 18.1+
- SQL*Plus o SQL Developer

### Pasos

1. **Conectar a Oracle:**

```bash
sqlplus system/password@localhost:1521/orclpdb1
```

2. **Ejecutar el esquema:**

```sql
@schema.sql
```

3. **Verificar tablas:**

```sql
SELECT table_name FROM user_tables ORDER BY table_name;
```

4. **Crear aplicación APEX:**

- Abre APEX (`http://localhost:8080/apex`)
- Crea una nueva aplicación
- Usa las tablas creadas como fuente de datos

## 📊 Estructura del Esquema

### Diagrama Entidad-Relación

```
┌──────────────┐       ┌──────────────┐
│  departments │       │    jobs      │
├──────────────┤       ├──────────────┤
│ department_id│◄──────│   job_id     │
│ dept_name    │       │ job_title    │
│ manager_id   │       │ min_salary   │
│ location_id  │       │ max_salary   │
└──────┬───────┘       └──────────────┘
       │
       │ 1:N
       ▼
┌──────────────┐       ┌──────────────┐
│  employees   │       │  locations   │
├──────────────┤       ├──────────────┤
│ employee_id  │       │ location_id  │
│ first_name   │       │ city         │
│ last_name    │       │ country_id   │
│ email        │       │ postal_code  │
│ department_id│──────►│              │
│ job_id       │       └──────────────┘
│ salary       │
└──────────────┘
```

## 📝 Tablas Detalladas

### employees

```sql
CREATE TABLE employees (
    employee_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone_number VARCHAR2(20),
    hire_date DATE DEFAULT SYSDATE,
    job_id VARCHAR2(20),
    salary NUMBER(10,2),
    commission_pct NUMBER(5,2),
    manager_id NUMBER,
    department_id NUMBER,
    is_active NUMBER(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### audit_log

```sql
CREATE TABLE audit_log (
    audit_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name VARCHAR2(50),
    action VARCHAR2(20),
    old_values CLOB,
    new_values CLOB,
    user_name VARCHAR2(100),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR2(50)
);
```

## 🔧 Procedures y Funciones

El esquema incluye procedures para:

- `create_employee` - Crear empleado
- `update_employee` - Actualizar empleado
- `delete_employee` - Eliminar empleado (soft delete)
- `get_employee_details` - Obtener detalles
- `calculate_bonus` - Calcular bono

## 📈 Índices

```sql
CREATE INDEX idx_emp_dept ON employees(department_id);
CREATE INDEX idx_emp_manager ON employees(manager_id);
CREATE INDEX idx_emp_email ON employees(email);
CREATE INDEX idx_emp_job ON employees(job_id);
CREATE INDEX idx_emp_active ON employees(is_active);
```

## 🧪 Queries de Ejemplo

### Lista de empleados por departamento

```sql
SELECT e.first_name, e.last_name, d.department_name, j.job_title
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id
WHERE e.is_active = 1
ORDER BY d.department_name, e.last_name;
```

### Total salarial por departamento

```sql
SELECT d.department_name,
       COUNT(e.employee_id) as employees,
       SUM(e.salary) as total_salary,
       ROUND(AVG(e.salary), 2) as avg_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY total_salary DESC;
```

## 🔐 Seguridad

- Emails únicos con constraint UNIQUE
- Validación de datos con CHECK constraints
- Auditoría de todos los cambios
- Soft deletes (is_active)

## 📁 Archivos

```
oracle-apex-demo/
├── schema.sql     # Esquema completo
└── README.md      # Este archivo
```

## 🔨 Integración con APEX

### Crear Reporte

1. App Builder → New Application
2. Add Page → Report
3. Select table: EMPLOYEES
4. Follow wizard

### Crear Form

1. Add Page → Form
2. Select table: EMPLOYEES
3. Add on page: EMPLOYEE_ID
4. Follow wizard

## 📝 Changelog

- **v1.0.0** - Esquema básico
- **v1.1.0** - Auditoría, índices, mejoras
- **v1.2.0** - Mejoras de seguridad PL/SQL

## 🔒 Seguridad

### Mejores prácticas para Oracle APEX

- **Autenticación**: Usar autenticación de APEX con roles
- **Authorization**: Definir esquemas de autorización por grupo
- **SQL Injection**: Usar binds (`:VAR`) en lugar de concatenación
- **PL/SQL**: Validar entrada en procedimientos almacenados
- **Auditoría**: Tabla de auditoría habilitada (`audit_log`)
- **OWA**: Protecciones contra OWA Injection

## 🤝 Contribución

¡Mejoras bienvenidas! Abre un issue o PR.

## 📄 Licencia

MIT License - Uso libre.
