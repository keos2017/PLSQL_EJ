CREATE OR REPLACE PROCEDURE add_department(
    name VARCHAR2, mgr NUMBER, loc NUMBER) IS

BEGIN
      INSERT INTO departments (department_id,
      department_name, manager_id, location_id)
      VALUES (DEPARTMENTS_SEQ.NEXTVAL, name, mgr, loc);
      dbms_output.put_line('Added Dept:' || name);
EXCEPTION
 WHEN OTHERS THEN
       dbms_output.put_line('Err: adding dept: ' || name);
END add_department;