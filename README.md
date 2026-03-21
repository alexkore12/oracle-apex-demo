# Oracle APEX Demo

Demo completo de aplicación Oracle APEX con base de datos, PL/SQL y más.

## Contenido

- **schema.sql** - Esquema de base de datos completo
- **Procedimientos** - PL/SQL almacenado
- **Funciones** - Functions de base de datos
- **Triggers** - Triggers automáticos
- **Vistas** - Vistas optimizadas

## Estructura de Tablas

### employees
| Columna | Tipo | Descripción |
|---------|------|-------------|
| employee_id | NUMBER | ID auto-generado |
| first_name | VARCHAR2 | Nombre |
| last_name | VARCHAR2 | Apellido |
| email | VARCHAR2 | Email único |
| salary | NUMBER | Salario |

### departments
Departamentos de la empresa.

### jobs
Posiciones/tipos de trabajo.

### locations
Ubicaciones geográficas.

## Uso en APEX

1. Abrir Oracle APEX Workspace
2. Importar este código en SQL Workshop
3. Ejecutar schema.sql
4. Crear nueva aplicación basada en las tablas

## Procedimientos PL/SQL

### add_employee
Inserta nuevo empleado con parámetros.

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
```

### get_department_total_salary
Obtiene suma de salarios por departamento.

```sql
SELECT get_department_total_salary(20) FROM dual;
```

## Triggers

- **trg_emp_updated** - Actualiza timestamp en cambios

## Vistas

- **v_employee_details** - Vista completa de empleados

## Mejores Prácticas

- Usar secuencias para IDs
- Constraints apropiados
- Índices para búsquedas
- Triggers para auditoria

## Requisitos

- Oracle Database 19c+
- Oracle APEX 21+

## Contributing

Pull requests bienvenidos.

## License

MIT
