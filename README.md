# Oracle APEX Demo

Demo completo de aplicación Oracle APEX con base de datos, PL/SQL avanzado y más.

## 📋 Descripción

Este proyecto contiene un esquema de base de datos completo para Oracle APEX con tablas, procedimientos, funciones, triggers y vistas para gestionar empleados, departamentos, trabajos y ubicaciones.

## 📋 Contenido

### Esquema de Base de Datos

| Tabla | Descripción |
|-------|-------------|
| `employees` | Empleados de la empresa |
| `departments` | Departamentos |
| `jobs` | Posiciones/tipos de trabajo |
| `locations` | Ubicaciones geográficas |
| `audit_log` | Auditoría de cambios |

### Columnas de Employees

| Columna | Tipo | Descripción |
|---------|------|-------------|
| employee_id | NUMBER | ID auto-generado |
| first_name | VARCHAR2 | Nombre |
| last_name | VARCHAR2 | Apellido |
| email | VARCHAR2 | Email único |
| phone_number | VARCHAR2 | Teléfono |
| hire_date | DATE | Fecha de contratación |
| job_id | VARCHAR2 | ID del trabajo |
| salary | NUMBER | Salario |
| commission_pct | NUMBER | Porcentaje de comisión |
| manager_id | NUMBER | ID del manager |
| department_id | NUMBER | ID del departamento |
| is_active | NUMBER | Estado activo/inactivo |
| created_at | TIMESTAMP | Fecha de creación |
| updated_at | TIMESTAMP | Última actualización |

## 🚀 Instalación

### Prerrequisitos

- Oracle Database 19c o superior
- Oracle APEX 21.x o superior

### Pasos

1. **Abrir Oracle APEX Workspace**
   - Accede a tu instancia de Oracle APEX
   - Inicia sesión con tus credenciales

2. **Importar el esquema**
   - Ve a **SQL Workshop** > **SQL Commands**
   - Copia y ejecuta el contenido de `schema.sql`
   - O usa **SQL Workshop** > **Object Browser** > **Run Script**

3. **Verificar tablas**
   ```sql
   SELECT table_name FROM user_tables;
   ```

4. **Crear aplicación APEX**
   - Ve a **App Builder**
   - Nueva > From Scratch > Blank
   - Follow the wizard

## 📦 Procedimientos PL/SQL

### add_employee

Inserta nuevo empleado con parámetros:

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

### update_employee

Actualiza información del empleado:

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

### deactivate_employee

Desactiva un empleado (soft delete):

```sql
BEGIN
    deactivate_employee(p_employee_id => 5);
END;
/
```

## 📊 Funciones

### get_department_total_salary

Obtiene suma de salarios por departamento:

```sql
SELECT get_department_total_salary(20) FROM dual;
```

### calculate_total_compensation

Calcula salary + comisión:

```sql
SELECT calculate_total_compensation(75000, 15) FROM dual;
-- Resultado: 86250
```

### is_valid_email

Valida formato de email:

```sql
SELECT is_valid_email('test@example.com') FROM dual;
-- Resultado: 1 (true)
```

## 👁️ Vistas

### v_employee_details

Vista completa de empleados con información relacionada:

```sql
SELECT * FROM v_employee_details WHERE department_id = 20;
```

### v_org_chart

Estructura organizacional jerárquica:

```sql
SELECT * FROM v_org_chart;
```

### v_department_salary_summary

Resumen de salarios por departamento:

```sql
SELECT * FROM v_department_salary_summary;
```

## ⚡ Triggers

- `trg_emp_updated` - Actualiza timestamp en cambios
- `trg_validate_salary` - Valida salary contra rango del job
- `trg_emp_delete_audit` - Registra deletes en audit log

## 📦 Paquete employee_pkg

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

## 🛠️ Requisitos

- Oracle Database 19c+
- Oracle APEX 21+

## 📝 Uso en Oracle APEX

### Crear Interactive Grid

1. Ir a SQL Workshop > Object Browser
2. Seleccionar tabla `employees`
3. Crear Interactive Grid
4. Configurar columnas y validaciones

### Crear Form

1. Ir a App Builder
2. Nueva página > Form
3. Seleccionar tabla `employees`
4. Configurar elementos

## 🔒 Seguridad

- Usar secuencias para IDs
- Constraints apropiados (UNIQUE, NOT NULL, CHECK)
- Índices para búsquedas
- Triggers para auditoría
- Validación de salary contra rangos de jobs

## 🧪 Funciones de Prueba

```sql
-- Ver empleados activos
SELECT * FROM employees WHERE is_active = 1;

-- Ver historial de cambios
SELECT * FROM audit_log ORDER BY change_date DESC;

-- Ver empleados por departamento
SELECT d.department_name, COUNT(e.employee_id) as empleados
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;
```

## 📁 Estructura del Proyecto

```
oracle-apex-demo/
├── schema.sql          # Esquema completo de base de datos
├── README.md           # Este archivo
└── .gitignore         # Archivos ignorados
```

## 🤝 Contribuir

1. Fork el repositorio
2. Crea una rama (`git checkout -b feature/nueva-caracteristica`)
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## 📝 Changelog

- **v1.1.0** - Esquema completo con todas las tablas
- **v1.0.0** - Versión inicial

## 📄 Licencia

MIT License

---

## 🇬🇧 English

Complete Oracle APEX demo application with database schema, advanced PL/SQL procedures, functions, triggers, and views for managing employees, departments, jobs, and locations.
