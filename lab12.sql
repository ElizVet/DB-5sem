ALTER PLUGGABLE DATABASE OPEN;
SET SERVEROUTPUT ON SIZE UNLIMITED;

-- 1 add two columns + fill them with values
ALTER TABLE TEACHER
ADD BIRTHDAY DATE;

ALTER TABLE TEACHER
ADD SALARY NUMBER(7,2);

DECLARE
CURSOR TEACHER_CURS IS SELECT * FROM TEACHER FOR UPDATE;
TEACHER_ROW TEACHER%ROWTYPE;
RAND_DATE DATE;
RAND_SAL NUMBER;
begin
    FOR TEACHER_ROW IN TEACHER_CURS
    LOOP
        SELECT TO_DATE(                                                                 -----
              TRUNC(                                                                                -----
                    DBMS_RANDOM.VALUE(
                          TO_CHAR(DATE '1950-01-01', 'J'),
                          TO_CHAR(DATE '2004-01-01', 'J')
                    )
              ), 'J') -- Julian Day 
         INTO RAND_DATE FROM DUAL;                                  -----
        
        SELECT DBMS_RANDOM.VALUE (1000,2500) INTO RAND_SAL FROM DUAL;
        
        UPDATE TEACHER SET BIRTHDAY = RAND_DATE, SALARY = TRUNC(RAND_SAL, 2)
        WHERE CURRENT OF TEACHER_CURS;
        
    end loop;
    
    exception when others
    then  dbms_output.put_line(sqlerrm);
END;

--SELECT * FROM TEACHER order by TEACHER.TEACHER;
commit;


SELECT TO_CHAR(DATE '1950-01-01', 'J') FROM DUAL;
SELECT TO_DATE(TO_CHAR(DATE '1950-01-01', 'J'), 'J') FROM DUAL;





-- 2 list of teachers in the form of Surname A.A.
declare
cursor teacher_curs is select * from teacher for update;
teacher_row teacher%rowtype;
rand_date date;
rand_sal number;
str nvarchar2(70);
name nvarchar2(20);
second_name nvarchar2(20);
patronym nvarchar2(20);
begin
    for teacher_row in teacher_curs
    LOOP
        select regexp_substr(teacher_row.teacher_name,                        -----
                    '[^ ]+', 1, 1) into second_name from dual;
                    
        select regexp_substr(teacher_row.teacher_name,
                    '[^ ]+', 1, 2) into name from dual;
                    
        select regexp_substr(teacher_row.teacher_name,
                    '[^ ]+', 1, 3) into patronym from dual;
        str := second_name || ' ' || substr(name, 1, 1) || '. ' || substr(patronym, 1, 1) || '.';  
        dbms_output.put_line(str);
    end loop;    
    exception
    when others
    THEN  DBMS_OUTPUT.PUT_LINE(SQLERRM);
end;

-- 3 list of teachers born on Monday
SELECT * 
FROM TEACHER 
WHERE (
      SELECT TO_CHAR(BIRTHDAY, 'DAY', 'NLS_DATE_LANGUAGE = ENGLISH')  
      FROM DUAL )
      LIKE '%FRIDAY%';

-- 4 list of teachers who were born in the following month
create or replace view teacher_with_bd_next_month as
    SELECT TEACHER_NAME, 
                    BIRTHDAY, 
                    (EXTRACT (MONTH FROM BIRTHDAY)) AS BIRTH_MONTH                                  -------
    from teacher
    where (extract (month from birthday)) = (extract (month from sysdate))+1;

select * from teacher_with_bd_next_month;

-- 5 the number of teachers who were born in each month
create or replace view teachers_count_by_month as
    select (extract (month from birthday)) as birth_month, count(*) as count
    from teacher
    group by (extract (month from birthday))
    order by birth_month;


select * from teachers_count_by_month;

-- 6 list of teachers who have an anniversary next year
declare
cursor teacher_curs is select * from teacher for update;
teacher_row teacher%rowtype;
teach_date date;
begin
    for teacher_row in teacher_curs
    LOOP
        if ( mod(extract(year from sysdate) - extract(year from teacher_row.birthday), 10) = 0) then                            -------
            dbms_output.put_line(teacher_row.teacher_name || ' ' || teacher_row.birthday);
        end if;
    end loop;    
    exception
    when others
    then  dbms_output.put_line(sqlerrm);
end;

-- 7 -- average salary for departments rounded down to whole
        -- average totals for each faculty and for all faculties as a whole
declare
    cursor fac_curs is
    select * from faculty;
    
    cursor pulp_curs(faculty_row fac_curs%rowtype) is
    select * from pulpit where faculty = faculty_row.faculty;
    
    faculty_row fac_curs%rowtype;
    pulpit_row pulp_curs%rowtype;
    
    counter int;
    salsum number(12,2);
    pulpitavg number(10,2);
    
    fac_counter int := 0;
    fac_avg number(14,2) := 0;
begin
    for faculty_row in fac_curs
    loop
        salsum := 0; 
        counter := 0;
        dbms_output.put_line('faculty ' || faculty_row.faculty || ':');
        for pulpit_row in pulp_curs(faculty_row)
        LOOP
            select FLOOR(avg(salary)) into pulpitavg from teacher where pulpit = pulpit_row.pulpit;                       ---------
            -- didnt find a proper way to check salary for actual value in case when there are no salaries, but the one below;
            if (pulpitavg > 0 ) then
                dbms_output.put_line(CHR(9) || 'pulpit ' || pulpit_row.pulpit || ': ' || pulpitavg );
                salsum := salsum + pulpitavg;
                counter := counter + 1;
                continue;
            end if;
            
            dbms_output.put_line(CHR(9) || 'pulpit ' || pulpit_row.pulpit || ': ' || 'N/A' );

        end loop;
        dbms_output.put_line('======');
        
        if (salsum > 0 AND counter > 0) then
                dbms_output.put_line('avg: ' || FLOOR(salsum/counter));
                fac_avg := fac_avg + salsum/counter;
                fac_counter := fac_counter + 1;
                dbms_output.put_line('======');
                continue;
        end if;
        dbms_output.put_line('avg: N/A');
        dbms_output.put_line('======');
    end loop;
    dbms_output.put_line('==============');
    dbms_output.put_line('SUMMARY');
    dbms_output.put_line('==============');

    if (fac_counter > 0 AND fac_avg > 0) then
                dbms_output.put_line('avg: ' || FLOOR(fac_avg/fac_counter));
                dbms_output.put_line('==============');
    else
        dbms_output.put_line('avg: N/A');
        dbms_output.put_line('==============');
    end if;
    exception
    when others
    THEN  DBMS_OUTPUT.PUT_LINE(SQLERRM);
end;

-- 8 -- native PL/SQL record type (record)
        -- working with nested records
        -- assignment operation
declare 
      type auditorium_type_t is record (
        audtype auditorium_type.auditorium_type%type,
        typename auditorium_type.auditorium_typename%type
      );  
     type auditorium_t is record (
        name auditorium.auditorium_name%type,
        audtype auditorium_type_t
      );
     
     REC             AUDITORIUM_T;
     auditorium_type_row             auditorium_type_t;
     name auditorium.auditorium_name%type;
     audtype auditorium.auditorium_type%type;
 begin
    
    select auditorium_name, auditorium_type into name, audtype
    from auditorium
    fetch first 1 row only;
    
    select auditorium_type, auditorium_typename 
    into auditorium_type_row
    from auditorium_type
    where auditorium_type = audtype
    fetch first 1 row only;
    
    rec.name := name;
    rec.audtype := auditorium_type_row;
    
    dbms_output.put_line(rec.name || ' ' || rec.audtype.typename);
    exception
    when others
    THEN  DBMS_OUTPUT.PUT_LINE(SQLERRM);
 end;





-----
BEGIN
DBMS_OUTPUT.PUT_LINE(trunc(-10.25));
DBMS_OUTPUT.PUT_LINE(trunc(-10.5));
DBMS_OUTPUT.PUT_LINE(trunc(10.25));
DBMS_OUTPUT.PUT_LINE(trunc(10.5));
end;



