# Oracle APEX Demo

Demo completo de aplicación Oracle APEX con base de datos, PL/SQL y más.

## 📋 Contenido

- **schema.sql** - Esquema de base de datos completo
- **Procedimientos** - PL/SQL almacenado
- **Funciones** - Functions de base de datos
- **Triggers** - Triggers automáticos
- **Vistas** - Vistas optimizadas
- **Secuencias** - Generadores de IDs

## 🎯 Características

- Diseño normalizado (3NF)
- Índices para optimización de consultas
- Constraints para integridad de datos
- Triggers para auditoría automática
- Procedimientos almacenados para lógica de negocio
- Paquetes PL/SQL modulares

## Estructura de Tablas

### employees
| Columna | Tipo | Descripción |
|---------|------|-------------|
| employee_id | NUMBER | ID auto-generado |
| first_name | VARCHAR2(50) | Nombre |
| last_name | VARCHAR2(50) | Apellido |
| email | VARCHAR2(100) | Email único |
| phone_number | VARCHAR2(20) | Teléfono |
| hire_date | DATE | Fecha de contratación |
| job_id | VARCHAR2(10) | Clave del puesto |
| salary | NUMBER | Salario |
| commission_pct | NUMBER | Comisión (%) |
| manager_id | NUMBER | ID del gerente |
| department_id | NUMBER | ID del departamento |

### departments
| Columna | Tipo | Descripción |
|---------|------|-------------|
| department_id | NUMBER | ID auto-generado |
| department_name | VARCHAR2(100) | Nombre del depto |
| manager_id | NUMBER | ID del gerente |
| location_id | NUMBER | ID de ubicación |

### jobs
| Columna | Tipo | Descripción |
|---------|------|-------------|
| job_id | VARCHAR2(10) | Clave primaria |
| job_title | VARCHAR2(100) | Título del puesto |
| min_salary | NUMBER | Salario mínimo |
| max_salary | NUMBER | Salario máximo |

### locations
| Columna | Tipo | Descripción |
|---------|------|-------------|
| location_id | NUMBER | ID auto-generado |
| street_address | VARCHAR2(200) | Dirección |
| city | VARCHAR2(100) | Ciudad |
| state_province | VARCHAR2(100) | Estado/Provincia |
| country_id | CHAR(2) | Código de país |

## 🔧 Uso en APEX

### Paso 1: Importar Esquema

1. Abrir Oracle APEX Workspace
2. Ir a **SQL Workshop** > **SQL Scripts**
3. Upload `schema.sql`
4. Ejecutar script

### Paso 2: Crear Aplicación

1. Ir a **App Builder**
2. Click **Create**
3. Seleccionar **New Application**
4. Elegir páginas:
   - Dashboard (Gráficos)
   - Employees (CRUD)
   - Departments (CRUD)
   - Reports (Reportes)
5. Crear aplicación

### Paso 3: Configurar security

```sql
-- Habilitar Row Security
ALTER TABLE employees ENABLE ROW SECURITY;
```

## 📦 Paquetes PL/SQL

### employee_pkg

```sql
-- Crear empleado
BEGIN
    employee_pkg.create_employee(
        p_first_name => 'Juan',
        p_last_name => 'Pérez',
        p_email => 'juan@example.com',
        p_job_id => 'DEV',
        p_salary => 75000,
        p_department_id => 20
    );
END;
/

-- Actualizar empleado
BEGIN
    employee_pkg.update_employee(
        p_employee_id => 100,
        p_salary => 80000
    );
END;
/

-- Obtener información
DECLARE
    v_emp employee_pkg.emp_info;
BEGIN
    v_emp := employee_pkg.get_employee(100);
    DBMS_OUTPUT.PUT_LINE(v_emp.full_name || ' - ' || v_emp.job_title);
END;
/
```

## 🔬 Funciones

### get_department_total_salary

```sql
SELECT get_department_total_salary(20) FROM dual;
-- Resultado: 150000

-- En PL/SQL
DECLARE
    v_total NUMBER;
BEGIN
    v_total := get_department_total_salary(p_department_id => 20);
    DBMS_OUTPUT.PUT_LINE('Total: ' || v_total);
END;
/
```

### calculate_bonus

```sql
SELECT employee_id, first_name, salary,
       calculate_bonus(salary, 'EXCELLENT') as bonus
FROM employees;
```

## ⚡ Triggers

### trg_emp_audit

```sql
-- Auditoría de cambios
CREATE OR REPLACE TRIGGER trg_emp_audit
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO audit_log (table_name, action, old_value, new_value, changed_by, change_date)
        VALUES ('employees', 'INSERT', NULL, :NEW.employee_id, USER, SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO audit_log (table_name, action, old_value, new_value, changed_by, change_date)
        VALUES ('employees', 'UPDATE', :OLD.employee_id, :NEW.employee_id, USER, SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO audit_log (table_name, action, old_value, new_value, changed_by, change_date)
        VALUES ('employees', 'DELETE', :OLD.employee_id, NULL, USER, SYSDATE);
    END IF;
END;
/
```

### trg_emp_salary_check

```sql
-- Validar salario dentro del rango del puesto
CREATE OR REPLACE TRIGGER trg_emp_salary_check
BEFORE INSERT OR UPDATE OF salary ON employees
FOR EACH ROW
DECLARE
    v_min_sal jobs.min_salary%TYPE;
    v_max_sal jobs.max_salary%TYPE;
BEGIN
    SELECT min_salary, max_salary
    INTO v_min_sal, v_max_sal
    FROM jobs
    WHERE job_id = :NEW.job_id;
    
    IF :NEW.salary < v_min_sal OR :NEW.salary > v_max_sal THEN
        RAISE_APPLICATION_ERROR(-20001, 
            'Salary must be between ' || v_min_sal || ' and ' || v_max_sal);
    END IF;
END;
/
```

## 👁️ Vistas

### v_employee_details

```sql
-- Vista completa de empleados
SELECT * FROM v_employee_details
WHERE department_name = 'Engineering'
ORDER BY hire_date;
```

### v_department_stats

```sql
-- Estadísticas por departamento
SELECT * FROM v_department_stats
ORDER BY total_employees DESC;
```

## 📊 Índices

```sql
-- Índices para optimización
CREATE INDEX idx_emp_dept ON employees(department_id);
CREATE INDEX idx_emp_job ON employees(job_id);
CREATE INDEX idx_emp_manager ON employees(manager_id);
CREATE INDEX idx_emp_email ON employees(email) UNIQUE;
CREATE INDEX idx_emp_name ON employees(last_name, first_name);
```

## 🛡️ Seguridad

### Row Level Security (RLS)

```sql
-- Política de seguridad por departamento
CREATE OR REPLACE FUNCTION emp_secURITY_func(
    p_schema VARCHAR2, p_object VARCHAR2
) RETURN VARCHAR2 AS
BEGIN
    RETURN 'department_id = SYS_CONTEXT(''USERENV'', ''SESSION_USER'')';
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'employees',
        policy_name => 'emp_dept_policy',
        function_schema => 'HR',
        policy_function => 'emp_security_func'
    );
END;
/
```

## ✅ Mejores Prácticas

1. **Usar secuencias** para IDs auto-incrementales
2. **Constraints** apropiados (PK, FK, UNIQUE, CHECK)
3. **Índices** para búsquedas frecuentes
4. **Triggers** para auditoría y validación
5. **Paquetes** para organizar código PL/SQL
6. **Excepciones** personalizadas para errores
7. **Transacciones** apropiadas (COMMIT/ROLLBACK)
8. **Bind variables** para mejor rendimiento

## 🔧 Mantenimiento

### Recopilar estadísticas

```sql
-- Después de carga masiva de datos
EXEC DBMS_STATS.GATHER_TABLE_STATS('HR', 'EMPLOYEES');
```

### Analizar tabla

```sql
-- Ver tamaño y fragmentation
SELECT * FROM USER_TABLES WHERE TABLE_NAME = 'EMPLOYEES';
```

## 📋 Scripts de Ejemplo

### Insertar datos de prueba

```sql
-- Insertar departamento
INSERT INTO departments (department_name, location_id)
VALUES ('Engineering', 1000);

-- Insertar puesto
INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
VALUES ('DEV', 'Developer', 50000, 150000);
```

## Requisitos

- Oracle Database 19c+
- Oracle APEX 21+
- Privilegios: CREATE TABLE, CREATE PROCEDURE, CREATE TRIGGER

## Contributing

Pull requests bienvenidos.

## License

MIT
