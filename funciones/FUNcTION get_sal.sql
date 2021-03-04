CREATE OR REPLACE FUNCTION get_sal
	(id employees.employees_id%TYPE) RETURN NUMBER IS
	 sal employees.salary%TYPE := 0;
BEGIN
    SELECT salary
      INTO sal
      FROM employees
     WHERE employees_id = id;
     RETURN sal;
END get_sal;
/*************************************************************************
*************************************************************************/
CREATE OR REPLACE FUNCTION tax(value IN NUMBER)
    RETURN NUMBER IS
BEGIN
    RETURN (value * 0.08);
END tax;
/*************************************************************************
*************************************************************************/
SELECT employee_id,last_name, salary, tax(salary)
  FROM employees
 WHERE department_id = 100;
 /*************************************************************************
*************************************************************************/
SELECT employee_id, tax(salary)
  FROM employees
 WHERE tax(salary) > (SELECT MAX(tax(salary))
                        FROM employees
                       WHERE department_id = 30)
ORDER BY tax(salary) DESC;
 /*************************************************************************
*************************************************************************/
CREATE OR REPLACE FUNCTION dml_call_sql (sal NUMBER)
    RETURN NUMBER IS
BEGIN
    INSERT INTO employees (employee_id, last_name,
                    email, hire_date, job_id, salary)
    VALUES (1,'Frost', 'jfrost@company.com'
            SYSDATE, 'SAN_MAN', sal);
RETURN (sal + 100);
END;            
/-----------------------------------------------------------------------------/
UPDATE employees
   SET salary = dml_call_sql(2000)
 WHERE employee_id = 170;
/*-*--*---------------*-------------*--------*------------*------------*------
Error que empieza en la línea: 1 del comando :
UPDATE employees
   SET salary = dml_call_sql(2000)
 WHERE employee_id = 170
Informe de error -
ORA-04091: table HR.EMPLOYEES is mutating, trigger/function may not see it
ORA-06512: at "HR.DML_CALL_SQL", line 4
/*-*--*---------------*-------------*--------*------------*------------*------ 
 /*************************************************************************
*************************************************************************/
CREATE OR REPLACE FUNCTION query_call_sql (a NUMBER)
    RETURN NUMBER IS
    s NUMBER;
BEGIN
    SELECT salary INTO s FROM employees
    WHERE  employee_id = 170;
    RETURN (s + a);
END;
/-----------------------------------------------------------------------------/
UPDATE employees SET salary = query_call_sql(100)
WHERE employee_id = 170;   
/*-*--*---------------*-------------*--------*------------*------------*------
Error que empieza en la línea: 1 del comando :
UPDATE employees SET salary = query_call_sql(100)
WHERE employee_id = 170
Informe de error -
ORA-04091: table HR.EMPLOYEES is mutating, trigger/function may not see it
ORA-06512: at "HR.QUERY_CALL_SQL", line 5
/*-*--*---------------*-------------*--------*------------*------------*------
 /*************************************************************************
 ************************PRÁCTICA 2****************************************
*************************************************************************/

CREATE OR REPLACE FUNCTION  get_job (ID jobs.job_id%TYPE) 
    RETURN jobs.job_title%TYPE IS
    TITLE  jobs.job_title%TYPE;
BEGIN
    SELECT JOB_TITLE
    INTO   TITLE
    FROM   jobs
    WHERE  job_id = ID;
    RETURN TITLE;
END get_job;

 /*************************************************************************
*************************************************************************/

DECLARE
 v_title VARCHAR2(35);
BEGIN
   v_title:= get_job('SA_REP');
   dbms_output.put_line('TITLE: ' || v_title);
END;
/*-*--*---------------*-------------*--------*------------*------------*------
 /*************************************************************************
*************************************************************************/
CREATE OR REPLACE FUNCTION  get_annual_comp (
    salary employees.salary%TYPE,
    commission_pct employees.commission_pct%TYPE) 
    RETURN NUMBER IS
BEGIN
    RETURN  (NVL(salary,0) * 12 + (NVL(commission_pct,0) * NVL(salary,0) * 12));
END get_annual_comp;
 /*************************************************************************
*************************************************************************/
SELECT employee_id, last_name, get_annual_comp(salary,commission_pct) "Annual Compensation"
FROM   employees
WHERE  department_id=30;
/*-*--*---------------*-------------*--------*------------*------------*------
 /*************************************************************************
*********************************3**************************************/
create or replace FUNCTION  valid_deptid (deptid departments.department_id%TYPE)
    RETURN BOOLEAN IS
    dummy PLS_INTEGER;
BEGIN
    SELECT 1
    INTO   dummy
    FROM   departments
    WHERE  department_id = deptid;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END valid_deptid;
/*-*--*---------------*-------------*--------*------------*------------*------
 /******************************3****************************************
*************************************************************************/
CREATE OR REPLACE PROCEDURE add_employee (
    first_name employees.first_name%TYPE,
    last_name  employees.last_name%TYPE,
    email      employees.email%TYPE,
    job        employees.job_id%TYPE         DEFAULT 'SA_REP',
    mgr        employees.manager_id%TYPE     DEFAULT 145,
    sal        employees.salary%TYPE         DEFAULT 1000,
    comm       employees.commission_pct%TYPE DEFAULT 0,
    deptid     employees.department_id%TYPE  DEFAULT 30) IS
    
BEGIN

    IF VALID_DEPTID(deptid) THEN

      INSERT INTO employees (employee_id, first_name, last_name, email, job_id,
                            manager_id, hire_date, salary, commission_pct, department_id)
      VALUES (EMPLOYEES_SEQ.NEXTVAL, first_name, last_name, email, job, mgr, TRUNC(SYSDATE),
              sal, comm, deptid);
    ELSE
    
        RAISE_APPLICATION_ERROR(-20204, 'Invalid department ID. Try again.');
        
    END IF;
END add_employee;