-- Oracle APEX Demo - Esquema de base de datos completo
-- Demo application para Oracle APEX con ejemplos avanzados de PL/SQL
-- Versión: 1.1.0

-- ============================================
-- TABLAS PRINCIPALES
-- ============================================

-- Tabla de empleados
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

-- Tabla de departamentos
CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(100) NOT NULL,
    manager_id NUMBER,
    location_id NUMBER,
    budget NUMBER(15,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de trabajos
CREATE TABLE jobs (
    job_id VARCHAR2(20) PRIMARY KEY,
    job_title VARCHAR2(100) NOT NULL,
    min_salary NUMBER(10,2),
    max_salary NUMBER(10,2),
    description VARCHAR2(500)
);

-- Tabla de ubicaciones
CREATE TABLE locations (
    location_id NUMBER PRIMARY KEY,
    street_address VARCHAR2(200),
    city VARCHAR2(100),
    state_province VARCHAR2(100),
    country_id CHAR(2),
    postal_code VARCHAR2(20)
);

-- Tabla de auditoría
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

-- ============================================
-- ÍNDICES PARA MEJORAR RENDIMIENTO
-- ============================================

CREATE INDEX idx_emp_dept ON employees(department_id);
CREATE INDEX idx_emp_manager ON employees(manager_id);
CREATE INDEX idx_emp_email ON employees(email);
CREATE INDEX idx_emp_job ON employees(job_id);
CREATE INDEX idx_emp_active ON employees(is_active);
CREATE INDEX idx_dept_location ON departments(location_id);

-- ============================================
-- SECUENCIAS
-- ============================================

CREATE SEQUENCE emp_seq START WITH 100;
CREATE SEQUENCE dept_seq START WITH 10;
CREATE SEQUENCE audit_seq;

-- ============================================
-- VISTAS
-- ============================================

-- Vista de detalles de empleados
CREATE OR REPLACE VIEW v_employee_details AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    e.email,
    e.phone_number,
    e.hire_date,
    j.job_title,
    e.salary,
    e.commission_pct,
    d.department_name,
    l.city,
    l.country_id,
    e.is_active,
    e.created_at,
    e.updated_at
FROM employees e
LEFT JOIN jobs j ON e.job_id = j.job_id
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN locations l ON d.location_id = l.location_id;

-- Vista de estructura organizacional
CREATE OR REPLACE VIEW v_org_chart AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.job_id,
    d.department_name,
    m.first_name || ' ' || m.last_name AS manager_name,
    LEVEL as org_level
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
LEFT JOIN departments d ON e.department_id = d.department_id
CONNECT BY PRIOR e.employee_id = e.manager_id
START WITH e.manager_id IS NULL;

-- Vista de salarios por departamento
CREATE OR REPLACE VIEW v_department_salary_summary AS
SELECT 
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) as employee_count,
    SUM(e.salary) as total_salary,
    AVG(e.salary) as avg_salary,
    MIN(e.salary) as min_salary,
    MAX(e.salary) as max_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id AND e.is_active = 1
GROUP BY d.department_id, d.department_name;

-- ============================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================

-- Procedimiento para agregar empleado
CREATE OR REPLACE PROCEDURE add_employee(
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_email IN VARCHAR2,
    p_job_id IN VARCHAR2,
    p_salary IN NUMBER,
    p_department_id IN NUMBER,
    p_manager_id IN NUMBER DEFAULT NULL
) AS
    v_emp_id NUMBER;
BEGIN
    INSERT INTO employees (first_name, last_name, email, job_id, salary, department_id, manager_id, hire_date)
    VALUES (p_first_name, p_last_name, p_email, p_job_id, p_salary, p_department_id, p_manager_id, SYSDATE)
    RETURNING employee_id INTO v_emp_id;
    
    -- Registrar en audit log
    INSERT INTO audit_log (table_name, action, new_values, user_name)
    VALUES ('employees', 'INSERT', 
            '{"employee_id": ' || v_emp_id || ', "email": "' || p_email || '"}',
            USER);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Empleado creado con ID: ' || v_emp_id);
END;
/

-- Procedimiento para actualizar empleado
CREATE OR REPLACE PROCEDURE update_employee(
    p_employee_id IN NUMBER,
    p_salary IN NUMBER DEFAULT NULL,
    p_department_id IN NUMBER DEFAULT NULL,
    p_job_id IN VARCHAR2 DEFAULT NULL
) AS
    v_old_salary NUMBER;
    v_old_dept NUMBER;
    v_old_job VARCHAR2(20);
BEGIN
    -- Guardar valores anteriores
    SELECT salary, department_id, job_id
    INTO v_old_salary, v_old_dept, v_old_job
    FROM employees
    WHERE employee_id = p_employee_id;
    
    -- Actualizar
    UPDATE employees
    SET salary = NVL(p_salary, salary),
        department_id = NVL(p_department_id, department_id),
        job_id = NVL(p_job_id, job_id),
        updated_at = CURRENT_TIMESTAMP
    WHERE employee_id = p_employee_id;
    
    -- Registrar cambio
    INSERT INTO audit_log (table_name, action, old_values, new_values, user_name)
    VALUES ('employees', 'UPDATE',
            '{"salary": ' || v_old_salary || ', "department_id": ' || v_old_dept || '}',
            '{"salary": ' || NVL(p_salary, v_old_salary) || '}',
            USER);
    
    COMMIT;
END;
/

-- Procedimiento para desactivar empleado
CREATE OR REPLACE PROCEDURE deactivate_employee(p_employee_id IN NUMBER) AS
BEGIN
    UPDATE employees
    SET is_active = 0,
        updated_at = CURRENT_TIMESTAMP
    WHERE employee_id = p_employee_id;
    
    INSERT INTO audit_log (table_name, action, old_values, new_values, user_name)
    VALUES ('employees', 'DEACTIVATE', 
            '{"is_active": 1}', 
            '{"is_active": 0}',
            USER);
    
    COMMIT;
END;
/

-- ============================================
-- FUNCIONES
-- ============================================

-- Función para obtener salario total por departamento
CREATE OR REPLACE FUNCTION get_department_total_salary(p_department_id NUMBER)
RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT COALESCE(SUM(salary), 0)
    INTO v_total
    FROM employees
    WHERE department_id = p_department_id AND is_active = 1;
    
    RETURN v_total;
END;
/

-- Función para calcular salary con comisión
CREATE OR REPLACE FUNCTION calculate_total_compensation(
    p_salary NUMBER,
    p_commission_pct NUMBER
) RETURN NUMBER
IS
BEGIN
    RETURN p_salary + (p_salary * NVL(p_commission_pct, 0) / 100);
END;
/

-- Función para validar email
CREATE OR REPLACE FUNCTION is_valid_email(p_email VARCHAR2)
RETURN NUMBER
IS
BEGIN
    IF p_email LIKE '%@%.%' AND p_email NOT LIKE '%@%@%' THEN
        RETURN 1;
    END IF;
    RETURN 0;
END;
/

-- ============================================
-- TRIGGERS
-- ============================================

-- Trigger para updated_at automático
CREATE OR REPLACE TRIGGER trg_emp_updated
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- Trigger para validar salary
CREATE OR REPLACE TRIGGER trg_validate_salary
BEFORE INSERT OR UPDATE OF salary ON employees
FOR EACH ROW
DECLARE
    v_min_salary NUMBER;
    v_max_salary NUMBER;
BEGIN
    IF :NEW.job_id IS NOT NULL THEN
        SELECT min_salary, max_salary
        INTO v_min_salary, v_max_salary
        FROM jobs
        WHERE job_id = :NEW.job_id;
        
        IF :NEW.salary < v_min_salary OR :NEW.salary > v_max_salary THEN
            RAISE_APPLICATION_ERROR(-20001, 
                'Salario debe estar entre ' || v_min_salary || ' y ' || v_max_salary);
        END IF;
    END IF;
END;
/

-- Trigger para audit de deletes
CREATE OR REPLACE TRIGGER trg_emp_delete_audit
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action, old_values, user_name)
    VALUES ('employees', 'DELETE',
            '{"employee_id": ' || :OLD.employee_id || ', "email": "' || :OLD.email || '"}',
            USER);
END;
/

-- ============================================
-- PAQUETES (PACKAGES)
-- ============================================

CREATE OR REPLACE PACKAGE employee_pkg AS
    -- Cursor para empleados activos
    CURSOR c_active_employees RETURN employees%ROWTYPE;
    
    -- Funciones públicas
    FUNCTION get_employee_count(p_department_id NUMBER DEFAULT NULL) RETURN NUMBER;
    FUNCTION get_employee_by_email(p_email VARCHAR2) RETURN employees%ROWTYPE;
    
    -- Procedimientos públicos
    PROCEDURE hire_employee(
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_department_id NUMBER
    );
    
    PROCEDURE fire_employee(p_employee_id NUMBER);
END employee_pkg;
/

CREATE OR REPLACE PACKAGE BODY employee_pkg AS
    FUNCTION get_employee_count(p_department_id NUMBER DEFAULT NULL)
    RETURN NUMBER
    IS
        v_count NUMBER;
    BEGIN
        IF p_department_id IS NULL THEN
            SELECT COUNT(*) INTO v_count FROM employees WHERE is_active = 1;
        ELSE
            SELECT COUNT(*) INTO v_count 
            FROM employees 
            WHERE department_id = p_department_id AND is_active = 1;
        END IF;
        RETURN v_count;
    END;
    
    FUNCTION get_employee_by_email(p_email VARCHAR2)
    RETURN employees%ROWTYPE
    IS
        v_employee employees%ROWTYPE;
    BEGIN
        SELECT * INTO v_employee
        FROM employees
        WHERE email = p_email AND is_active = 1;
        RETURN v_employee;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END;
    
    PROCEDURE hire_employee(
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_department_id NUMBER
    ) IS
    BEGIN
        add_employee(p_first_name, p_last_name, p_email, p_job_id, p_salary, p_department_id);
    END;
    
    PROCEDURE fire_employee(p_employee_id NUMBER) IS
    BEGIN
        deactivate_employee(p_employee_id);
    END;
END employee_pkg;
/

-- ============================================
-- DATOS DE EJEMPLO
-- ============================================

-- Departamentos
INSERT INTO departments VALUES (10, 'Executive', NULL, 1000, 500000);
INSERT INTO departments VALUES (20, 'Engineering', NULL, 1000, 300000);
INSERT INTO departments VALUES (30, 'Sales', NULL, 1000, 200000);
INSERT INTO departments VALUES (40, 'Human Resources', NULL, 2000, 100000);

-- Trabajos
INSERT INTO jobs VALUES ('CEO', 'Chief Executive Officer', 150000, 300000, 'Top executive');
INSERT INTO jobs VALUES ('DEV', 'Developer', 50000, 150000, 'Software developer');
INSERT INTO jobs VALUES ('MGR', 'Manager', 80000, 200000, 'Department manager');
INSERT INTO jobs VALUES ('SAL', 'Sales Representative', 40000, 120000, 'Sales professional');
INSERT INTO jobs VALUES ('HR', 'HR Specialist', 45000, 100000, 'Human resources');

-- Ubicaciones
INSERT INTO locations VALUES (1000, '500 Oracle Blvd', 'Redwood City', 'CA', 'US', '94065');
INSERT INTO locations VALUES (2000, '100 Main St', 'Austin', 'TX', 'US', '78701');

-- Empleados
INSERT INTO employees (first_name, last_name, email, job_id, salary, department_id, manager_id)
VALUES ('John', 'Smith', 'john.smith@example.com', 'CEO', 200000, 10, NULL);

INSERT INTO employees (first_name, last_name, email, job_id, salary, department_id, manager_id)
VALUES ('Jane', 'Doe', 'jane.doe@example.com', 'MGR', 120000, 20, 1);

INSERT INTO employees (first_name, last_name, email, job_id, salary, department_id, manager_id)
VALUES ('Bob', 'Wilson', 'bob.wilson@example.com', 'DEV', 95000, 20, 2);

INSERT INTO employees (first_name, last_name, email, job_id, salary, department_id, manager_id)
VALUES ('Alice', 'Brown', 'alice.brown@example.com', 'DEV', 85000, 20, 2);

INSERT INTO employees (first_name, last_name, email, job_id, salary, department_id, manager_id, commission_pct)
VALUES ('Charlie', 'Davis', 'charlie.davis@example.com', 'SAL', 60000, 30, 1, 15);

COMMIT;

-- Habilitar output
SET SERVEROUTPUT ON;
