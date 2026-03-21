-- Oracle APEX Demo - Esquema de base de datos
-- Demo application para Oracle APEX

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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de departamentos
CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(100) NOT NULL,
    manager_id NUMBER,
    location_id NUMBER
);

-- Tabla de trabajos
CREATE TABLE jobs (
    job_id VARCHAR2(20) PRIMARY KEY,
    job_title VARCHAR2(100) NOT NULL,
    min_salary NUMBER(10,2),
    max_salary NUMBER(10,2)
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

-- Índices
CREATE INDEX idx_emp_dept ON employees(department_id);
CREATE INDEX idx_emp_manager ON employees(manager_id);
CREATE INDEX idx_emp_email ON employees(email);

-- Secuencias
CREATE SEQUENCE emp_seq START WITH 100;

-- Vistas
CREATE OR REPLACE VIEW v_employee_details AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    e.email,
    e.phone_number,
    e.hire_date,
    j.job_title,
    e.salary,
    d.department_name,
    l.city,
    l.country_id
FROM employees e
LEFT JOIN jobs j ON e.job_id = j.job_id
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN locations l ON d.location_id = l.location_id;

-- Procedimientos almacenados
CREATE OR REPLACE PROCEDURE add_employee(
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_email IN VARCHAR2,
    p_job_id IN VARCHAR2,
    p_salary IN NUMBER,
    p_department_id IN NUMBER
) AS
BEGIN
    INSERT INTO employees (first_name, last_name, email, job_id, salary, department_id, hire_date)
    VALUES (p_first_name, p_last_name, p_email, p_job_id, p_salary, p_department_id, SYSDATE);
    COMMIT;
END;
/

-- Funciones
CREATE OR REPLACE FUNCTION get_department_total_salary(p_department_id NUMBER)
RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT COALESCE(SUM(salary), 0)
    INTO v_total
    FROM employees
    WHERE department_id = p_department_id;
    
    RETURN v_total;
END;
/

-- Trigger para updated_at
CREATE OR REPLACE TRIGGER trg_emp_updated
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- Insertar datos de ejemplo
INSERT INTO departments VALUES (10, 'Executive', NULL, 1000);
INSERT INTO departments VALUES (20, 'Engineering', NULL, 1000);
INSERT INTO departments VALUES (30, 'Sales', NULL, 1000);

INSERT INTO jobs VALUES ('DEV', 'Developer', 50000, 150000);
INSERT INTO jobs VALUES ('MGR', 'Manager', 80000, 200000);
INSERT INTO jobs VALUES ('SAL', 'Sales Representative', 40000, 120000);

INSERT INTO locations VALUES (1000, '500 Oracle Blvd', 'Redwood City', 'CA', 'US', '94065');
INSERT INTO locations VALUES (2000, '100 Main St', 'Austin', 'TX', 'US', '78701');

INSERT INTO employees (first_name, last_name, email, job_id, salary, department_id)
VALUES ('John', 'Smith', 'john.smith@example.com', 'MGR', 120000, 10);

INSERT INTO employees (first_name, last_name, email, job_id, salary, department_id)
VALUES ('Jane', 'Doe', 'jane.doe@example.com', 'DEV', 95000, 20);

COMMIT;
