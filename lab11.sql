ALTER PLUGGABLE DATABASE OPEN;
set SERVEROUTPUT on size unlimited;

-------------------------------- IMPLICIT CURSORS --------------------------------
-- 1 with accurate sampling
declare f faculty%rowtype;
begin 
      select * into f from faculty where faculty = 'IEF';
      DBMS_OUTPUT.PUT_LINE(f.faculty ||chr(9)||f.faculty_name);
      
      exception when too_many_rows
      then DBMS_OUTPUT.PUT_LINE(sqlerrm);
end;


-- 2 inaccurate sampling + WHEN OTHERS
begin 
      for f in (select * from FACULTY) -- cursor
      LOOP
            DBMS_OUTPUT.PUT_LINE(f.FACULTY ||chr(9)||f.FACULTY_NAME);
      END LOOP;
      
      EXCEPTION when OTHERS
      then DBMS_OUTPUT.PUT_LINE(SQLERRM || chr(9) || SQLCODE);
end;


-- 3 inaccurate sampling + too many rows
declare f faculty%rowtype;
begin 
      select * into f from faculty;
      DBMS_OUTPUT.PUT_LINE(f.faculty ||chr(9)||f.faculty_name);
      
      EXCEPTION when TOO_MANY_ROWS
      then DBMS_OUTPUT.PUT_LINE('too many rows. not one. this is  inaccurate sampling.');
end;


-- 4 no data found
declare F FACULTY%ROWTYPE;
begin 
      select * into f from faculty where faculty = '&&&';
      DBMS_OUTPUT.PUT_LINE(f.faculty ||chr(9)||f.faculty_name);
      
      EXCEPTION when NO_DATA_FOUND
      then DBMS_OUTPUT.PUT_LINE('damn, there was no such line.');
end;

-- cursor attributes
declare 
F FACULTY%ROWTYPE;
vFOUND BOOLEAN;
vISOPEN BOOLEAN;
VNOTFOUND BOOLEAN;
VROWCOUNT pls_integer;

begin 
      select * into F from FACULTY where FACULTY = 'IEF';
      DBMS_OUTPUT.PUT_LINE(F.FACULTY ||CHR(9)||F.FACULTY_NAME);
      
      VFOUND := sql%FOUND;
      vISOPEN := sql%ISOPEN;
      VNOTFOUND := sql%NOTFOUND;
      VROWCOUNT := sql%ROWCOUNT;
      
      if VFOUND then DBMS_OUTPUT.PUT_LINE('%found = true');
      else DBMS_OUTPUT.PUT_LINE('%found = false');
      end if;
      if VISOPEN then DBMS_OUTPUT.PUT_LINE('%isopen = true');
      else DBMS_OUTPUT.PUT_LINE('%isopen = false');
      end if;
      if VNOTFOUND then DBMS_OUTPUT.PUT_LINE('%NOTFOUND = true');
      else DBMS_OUTPUT.PUT_LINE('%NOTFOUND = false');
      end if;
      DBMS_OUTPUT.PUT_LINE('ROWCOUNT = ' || VROWCOUNT);
      
      EXCEPTION when OTHERS
      then DBMS_OUTPUT.PUT_LINE(SQLERRM || chr(9) || SQLCODE);
end;


-- 5 UPDATE
declare
    f FACULTY%ROWTYPE;
begin
    select * into f from FACULTY where FACULTY = 'IDiP';
    DBMS_OUTPUT.PUT_LINE('row: ' || f.FACULTY || ' ' || f.FACULTY_NAME);
    
    update FACULTY 
    set FACULTY_NAME = 'IDiP' where FACULTY = 'IDiP'
    returning FACULTY, FACULTY_NAME into F.FACULTY, F.FACULTY_NAME ;
    DBMS_OUTPUT.PUT_LINE('row-updated: ' || f.FACULTY || ' ' || f.FACULTY_NAME);
    
    rollback;
    
    select * into f from FACULTY where FACULTY = 'IDiP';
    DBMS_OUTPUT.PUT_LINE('row-rollbacked: ' || f.FACULTY || ' ' || f.FACULTY_NAME);
end;


-- 6 UPDATE with violation of database integrity
begin    
    update PULPIT set FACULTY = 'DAMN' where FACULTY = 'IDiP';
    EXCEPTION when OTHERS
        then DBMS_OUTPUT.PUT_LINE(SQLERRM);
end;


-- 7 INSERT
declare f faculty%rowtype;
begin
    insert into faculty values ('IT', 'Inform Technol');
    
    select * into f from FACULTY where FACULTY = 'IT';
    DBMS_OUTPUT.PUT_LINE('row-inserted: ' || f.FACULTY || ' ' || f.FACULTY_NAME);
    
    rollback;
 
    select * into f from FACULTY where FACULTY = 'IT';
    DBMS_OUTPUT.PUT_LINE('row-rollbacked: ' || f.FACULTY || ' ' || f.FACULTY_NAME);
    
    EXCEPTION when NO_DATA_FOUND
        then dbms_output.put_line('IT - ' || sqlerrm);
end;


-- 8 INSERT with violation of database integrity
begin
    insert into FACULTY values ('Inform Technol', 'IT');
    exception when others
        then dbms_output.put_line( sqlerrm);
end;


-- 9 DELETE 
declare VROWCOUNT PLS_INTEGER;
begin 
      delete AUDITORIUM where AUDITORIUM = '320-4';
      VROWCOUNT := sql%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('rowcount= ' || VROWCOUNT);
      
      rollback;
      VROWCOUNT := sql%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('rowcount= ' || VROWCOUNT);
     
      EXCEPTION when OTHERS 
              then DBMS_OUTPUT.PUT_LINE(SQLERRM);
end;
select count(*) from AUDITORIUM;

-- 10 DELETE with violation of database integrity
begin    
    delete from FACULTY where FACULTY = 'HTiT';
    exception when others
        then dbms_output.put_line(sqlerrm);
end;

-------------------------------- EXPLICIT CURSORS --------------------------------
-- 11 print table TEACHER with LOOP-cycle and %TYPE
declare
    V_TEACHER TEACHER.TEACHER%TYPE;
    V_TEACHER_NAME TEACHER.TEACHER_NAME%TYPE;
    V_PULPIT TEACHER.PULPIT%TYPE;
    CURSOR TEACHER_CURSOR IS SELECT * FROM TEACHER;
begin
    OPEN TEACHER_CURSOR;
    LOOP
        FETCH TEACHER_CURSOR INTO V_TEACHER, V_TEACHER_NAME, V_PULPIT;
        EXIT WHEN TEACHER_CURSOR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_TEACHER || ' - ' || V_TEACHER_NAME || ' - ' || V_PULPIT);
    END LOOP;
    CLOSE TEACHER_CURSOR;
end;


-- 12 print table SUBJECT with WHILE-cycle and %ROWTYPE
declare
    subject_row subject%rowtype;
    cursor subject_cursor is select * from subject;
begin
    open subject_cursor;
    fetch subject_cursor into subject_row;
    while (subject_cursor%found)
    loop
        dbms_output.put_line(subject_row.subject || ' - ' || subject_row.subject_name || ' - ' || subject_row.pulpit);
        fetch subject_cursor into subject_row;
    end loop;
    close subject_cursor;
end;


-- 13 print PULPIT(inner join)TEACHER with FOR-cycle
declare
    cursor teacher_pulpit_cursor
    is select p.PULPIT, t.TEACHER_NAME from PULPIT p inner join TEACHER t on p.PULPIT = t.PULPIT;
    cursor_row teacher_pulpit_cursor%rowtype;
begin
    for cursor_row in teacher_pulpit_cursor
    loop
        dbms_output.put_line(teacher_pulpit_cursor%rowcount || ': ' || cursor_row.teacher_name || ' - ' || cursor_row.pulpit);
    end loop;

    exception when others
        THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
end;


-- 14 several auditories lists + cursor with parameters
declare
    CURSOR auditorium_cursor (
        capacity_lower auditorium.auditorium_capacity%TYPE,
        capacity_upper auditorium.auditorium_capacity%TYPE) 
    IS SELECT auditorium_name, auditorium_capacity FROM auditorium
    WHERE auditorium_capacity >= capacity_lower AND auditorium_capacity <= capacity_upper;
    
    cursor_row auditorium_cursor%rowtype;
    
    procedure print_auditoriums(
        capacity_lower auditorium.auditorium_capacity%TYPE,
        capacity_upper auditorium.auditorium_capacity%TYPE
        ) as
        begin
            dbms_output.put_line('between ' || capacity_lower || ' and ' || capacity_upper);
            for cursor_row in auditorium_cursor(capacity_lower,capacity_upper)
            loop
                dbms_output.put_line(auditorium_cursor%rowcount || ': ' || cursor_row.auditorium_name || ' - ' || cursor_row.auditorium_capacity );
            end loop;
        end;
begin
    print_auditoriums(0, 20);
    print_auditoriums(21, 30);
    print_auditoriums(31, 60);
    print_auditoriums(61, 80);
    print_auditoriums(81, 1000);
    
    exception when others
        then dbms_output.put_line(sqlerrm);
end;


-- 15 refcursor - cursor variable
declare
    v_cursor sys_refcursor;
    v_auditorium auditorium%rowtype;
begin
    open v_cursor for select * from auditorium;
    loop
        fetch v_cursor into v_auditorium;
        EXIT WHEN V_CURSOR%NOTFOUND;
        dbms_output.put_line(v_auditorium.auditorium || ' ' || v_auditorium.auditorium_capacity);
    end loop;
    exception when others
        then dbms_output.put_line(sqlerrm);
end;


-- 16 cursor subquery
declare
cursor out_cursor is
    select  auditorium_typename, 
            cursor (
            select auditorium_name 
            from auditorium inaud 
            where inaud.auditorium_type = outaud.auditorium_type
            )
    from auditorium_type outaud;
    
    auditorium_typename auditorium_type.auditorium_typename%type;
    auditorium_name auditorium.auditorium_name%type;

    in_cursor sys_refcursor;
    txt nvarchar2(1000);
begin
    open out_cursor;
    loop
        fetch out_cursor into auditorium_typename, in_cursor;
        exit when out_cursor%notfound;
        txt := auditorium_typename || ': ';
        loop
            fetch in_cursor into auditorium_name;
            exit when in_cursor%notfound;
            txt := txt || auditorium_name || ', ';
        end loop;
        dbms_output.put_line(txt);
    end loop;
    exception
            when others
            then dbms_output.put_line(sqlerrm);
end;


-- 17 update current of
declare
    subtype aud_cap is auditorium.auditorium_capacity%type;
     
    cursor aud_cursor (lowercap aud_cap, uppercap aud_cap) is
    select * from auditorium
    where auditorium_capacity >= lowercap AND auditorium_capacity <= uppercap
    for update;
    curs_row aud_cursor%rowtype;
begin
    for curs_row in aud_cursor(40, 80)
    loop
        update auditorium
        SET AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY * 1.1
        where current of aud_cursor;          -- defines the string that has just been read
    end loop;
end;
select * from auditorium;
rollback;


-- 18 update current of
declare
    subtype aud_cap is auditorium.auditorium_capacity%type;
     
    cursor aud_cursor (lowercap aud_cap, uppercap aud_cap) is
    select auditorium_capacity from auditorium
    where auditorium_capacity >= lowercap AND auditorium_capacity <= uppercap
    for update;
    
    aud_count int;
    aud_capacity aud_cap;
begin
    
    select count(*) into aud_count from auditorium;
    dbms_output.put_line('aud count: ' || aud_count);

    open aud_cursor(0, 30);
    fetch aud_cursor into aud_capacity;
    while (aud_cursor%found)
    loop
        delete from auditorium
        where current of aud_cursor;
        fetch aud_cursor into aud_capacity;
    end loop;
    close aud_cursor;
    
       
    select count(*) into aud_count from auditorium;
    dbms_output.put_line('aud count: ' || aud_count);
    rollback;
end;


-- 19 ROWID - pseudo column
declare
    SUBTYPE AUD_CAP IS AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
    
    CURSOR AUD_CURSOR (LOWERCAP AUD_CAP, UPPERCAP AUD_CAP) IS
    SELECT ROWID FROM AUDITORIUM 
    WHERE AUDITORIUM_CAPACITY >= LOWERCAP AND AUDITORIUM_CAPACITY <= UPPERCAP 
    FOR UPDATE;    -- locking rows in the result set
    
    AUD_COUNT INT;
    AUD_ROWID VARCHAR(100);
begin
    OPEN AUD_CURSOR(0, 30);
    FETCH AUD_CURSOR INTO AUD_ROWID;
    WHILE (AUD_CURSOR%FOUND)
    LOOP
        DELETE FROM AUDITORIUM WHERE ROWID = AUD_ROWID;
        FETCH AUD_CURSOR INTO AUD_ROWID;
    END LOOP;
    CLOSE AUD_CURSOR;
    ROLLBACK;
end;


-- 20 
declare
    teacher_row teacher%rowtype;
    cursor teacher_cursor is 
    select *
    from teacher;
    
    counter int := 0;
begin
    for teacher_row in teacher_cursor
    loop
    counter := counter +1;
    
    dbms_output.put_line(teacher_row.teacher || ' - ' || teacher_row.teacher_name );

    if (mod(counter,3) = 0) then
        dbms_output.put_line('-----------------------');
    end if;
    
    end loop;
end;


--SELECT * FROM AUDITORIUM WHERE ROWNUM < 10; -- limits on the number of output records

