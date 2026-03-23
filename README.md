# Oracle APEX Demo

Demo completo de aplicación Oracle APEX con base de datos, PL/SQL avanzado y más.

## Esquema de Base de Datos

### Tablas Principales

| Tabla | Descripción |
|-------|-------------|
| `employees` | Empleados de la empresa |
| `departments` | Departamentos |
| `jobs` | Posiciones/tipos de trabajo |
| `locations` | Ubicaciones geográficas |
| `audit_log` | Auditoría de cambios |

### Estructura de Employees

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `employee_id` | NUMBER | ID auto-generado |
| `first_name` | VARCHAR2 | Nombre |
| `last_name` | VARCHAR2 | Apellido |
| `email` | VARCHAR2 | Email único |
| `phone_number` | VARCHAR2 | Teléfono |
| `hire_date` | DATE | Fecha de contratación |
| `job_id` | VARCHAR2 | ID del trabajo |
| `salary` | NUMBER | Salario |
| `commission_pct` | NUMBER | Porcentaje de comisión |
| `manager_id` | NUMBER | ID del manager |
| `department_id` | NUMBER | ID del departamento |
| `is_active` | NUMBER | Estado activo/inactivo |
| `created_at` | TIMESTAMP | Fecha de creación |
| `updated_at` | TIMESTAMP | Última actualización |

## Instalación

1. Abrir Oracle APEX Workspace
2. Importar este código en SQL Workshop
3. Ejecutar `schema.sql`
4. Crear nueva aplicación basada en las tablas

## Uso de Procedimientos

### Agregar Empleado

```sql
BEGIN
    add_employee(
        p_first_name => 'Juan',
        p_last_name => 'Pérez',
        p_email => 'juan@example.com',
        p_job_id => 'DEV',
        p_salary => 75000,
        p_department_id => 20
    );
END;
/
```

### Actualizar Empleado

```sql
BEGIN
    update_employee(
        p_employee_id => 1,
        p_salary => 80000,
        p_department_id => 20
    );
END;
/
```

### Desactivar Empleado (Soft Delete)

```sql
BEGIN
    deactivate_employee(p_employee_id => 5);
END;
/
```

## Funciones

### Obtener Salario Total por Departamento

```sql
SELECT get_department_total_salary(20) FROM dual;
```

### Calcular Compensación Total

```sql
SELECT calculate_total_compensation(75000, 15) FROM dual;
-- Resultado: 86250
```

### Validar Email

```sql
SELECT is_valid_email('test@example.com') FROM dual;
-- Resultado: 1 (true)
```

## Vistas

### Detalles de Empleados

```sql
SELECT * FROM v_employee_details WHERE department_id = 20;
```

### Organigrama Jerárquico

```sql
SELECT * FROM v_org_chart;
```

### Resumen de Salarios por Departamento

```sql
SELECT * FROM v_department_salary_summary;
```

## Triggers

| Trigger | Descripción |
|---------|-------------|
| `trg_emp_updated` | Actualiza timestamp en cambios |
| `trg_validate_salary` | Valida salary contra rango del job |
| `trg_emp_delete_audit` | Registra deletes en audit log |

## Paquete employee_pkg

### Métodos Disponibles

```sql
-- Contar empleados
SELECT employee_pkg.get_employee_count(20) FROM dual;

-- Obtener empleado por email
SELECT * FROM TABLE(employee_pkg.get_employee_by_email('juan@example.com'));

-- Contratar empleado
BEGIN
    employee_pkg.hire_employee(
        p_first_name => 'Nuevo',
        p_last_name => 'Empleado',
        p_email => 'nuevo@example.com',
        p_job_id => 'DEV',
        p_salary => 70000,
        p_department_id => 20
    );
END;
/

-- Despedir empleado
BEGIN
    employee_pkg.fire_employee(p_employee_id => 5);
END;
/
```

## Requisitos

- Oracle Database 19c+
- Oracle APEX 21+

## Crear aplicación en APEX

1. Ir a SQL Workshop > Object Browser
2. Seleccionar tabla `employees`
3. Crear Interactive Grid
4. Configurar columnas y validaciones

### Crear Forms

1. Ir a App Builder
2. Nueva página > Form
3. Seleccionar tabla `employees`
4. Configurar elementos

## Mejores Prácticas

- ✅ Usar secuencias para IDs
- ✅ Constraints apropiados (UNIQUE, NOT NULL, CHECK)
- ✅ Índices para búsquedas
- ✅ Triggers para auditoría
- ✅ Validación de salary contra rangos de jobs

## Consultas Útiles

### Ver empleados activos

```sql
SELECT * FROM employees WHERE is_active = 1;
```

### Ver historial de cambios

```sql
SELECT * FROM audit_log ORDER BY change_date DESC;
```

### Ver empleados por departamento

```sql
SELECT d.department_name, COUNT(e.employee_id) as empleados
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;
```

## Estructura del Proyecto

```
oracle-apex-demo/
├── schema.sql           # Esquema completo de base de datos
├── procedures.sql       # Procedimientos almacenados
├── functions.sql        # Funciones
├── triggers.sql         # Triggers
├── views.sql           # Vistas
├── package.sql         # Paquete employee_pkg
├── .github/
│   └── workflows/
│       └── ci.yml      # GitHub Actions
└── README.md           # Este archivo
```

## GitHub Actions

```yaml
name: Oracle APEX CI/CD

on:
  push:
    branches: [main]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Validate SQL syntax
        run: |
          echo "Validating SQL files..."
          # Add SQL validation steps
```

## Changelog

- ✅ v2.0 - Package completo, vistas optimizadas
- ✅ v1.0 - Esquema base

## Licencia

MIT

## Autor

GitHub: [alexkore12](https://github.com/alexkore12)

OpenClaw AI Assistant - 2026-03-22
