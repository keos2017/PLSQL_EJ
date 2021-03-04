DECLARE
CURSOR c_major IS
    SELECT DISTINCT major
    FROM students
    WHERE major = 'Computer Science';
    
CURSOR c_students(p_major students.major%type) IS  
    SELECT id, first_name, last_name, current_credits
    FROM   students
    WHERE major = p_major
    FOR UPDATE NOWAIT;
    
 BEGIN 
 FOR r_major IN c_major LOOP
    dbms_output.put_line('');
    dbms_output.put_line(r_major.major);
    FOR r_students IN c_students(r_major.major) LOOP
        dbms_output.put_line(r_students.first_name ||' '|| r_students.last_name
                             ||':'|| r_students.current_credits);
    UPDATE students SET current_credits = current_credits + 3 WHERE id = r_students.id;
    END LOOP;
        FOR r_students IN c_students(r_major.major) LOOP
            dbms_output.put_line(r_students.first_name ||' '|| r_students.last_name
                                    ||':'|| r_students.current_credits);
        END LOOP;
 END LOOP;
END;