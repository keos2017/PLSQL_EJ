DECLARE
CURSOR c_major IS
    SELECT DISTINCT major
    FROM students;
    
CURSOR c_students(p_major students.major%type) IS  
    SELECT first_name
          ,last_name
    FROM   students
    WHERE major = p_major;
    
 BEGIN 
    FOR r_major IN c_major LOOP
        dbms_output.put_line('');
        dbms_output.put_line(r_major.major);
        FOR r_students IN c_students(r_major.major) LOOP
            dbms_output.put_line(r_students.first_name ||' '|| r_students.last_name);                                     
        END LOOP;
    END LOOP;
END;