ALTER PLUGGABLE DATABASE ALL OPEN;


-- 1 list of teachers working at the Department - ISIT
declare
    procedure get_teachers (pcode teacher.pulpit%type)
    as
        cursor curs is 
        select * from teacher where pulpit = pcode;
        row curs%rowtype;
    begin
        for row in curs
        loop
            dbms_output.put_line(row.teacher || ' '  || row.teacher_name);
        end loop;
    end;
begin
    get_teachers('ISiT');
end;


-- 2 number of teachers working at the Department - ISIT
declare
    function get_num_teachers (PCODE TEACHER.PULPIT%type)
    return int
    as num int;
        begin
            select count(*) into num from teacher where pulpit = pcode;
            return num;
        end;
begin
    dbms_output.put_line(get_num_teachers('ISiT'));
end;


-- 3 list of teachers working at the Faculty - IDiP
declare
    procedure get_teachers (FCODE FACULTY.FACULTY%type) as
        cursor curs is select teacher, teacher_name
        from teacher inner join pulpit on teacher.pulpit = pulpit.pulpit
        where faculty = FCODE;
        
        row curs%rowtype;
        begin
              for row in curs
              loop
                    dbms_output.put_line(row.teacher || ' '  || row.teacher_name);
              end loop; 
              exception when others
                    then dbms_output.put_line('exception :' || sqlerrm);
        end;
begin
    get_teachers('IDiP');
end;


-- list of disciplines of the Department - ISiT
declare
      procedure get_subjects (PCODE SUBJECT.PULPIT%TYPE)
      as
            cursor curs is  select * from subject where pulpit = PCODE;
            row curs%rowtype;
            begin
                for row in curs
                loop
                    dbms_output.put_line(row.subject_name);
                end loop;
            end;
begin
    get_subjects('ISiT');
end;


-- 4 -- number of teachers working at the Faculty - IDiP
declare
    function get_num_teachers (FCODE FACULTY.FACULTY%type) return int as num int;
        begin
            select count(*) into num
            from teacher inner join pulpit on teacher.pulpit = pulpit.pulpit
            where faculty = FCODE;
            return num;
        end;
begin
    dbms_output.put_line(get_num_teachers('IDiP'));
end;

-- number of disciplines of the Department - ISiT
declare
    function get_num_subjects (PCODE SUBJECT.PULPIT%type) return int as num int;
        begin
            select count(*) into num from subject  where pulpit = PCODE;
            return num;
        end;
begin
    dbms_output.put_line(get_num_subjects('ISiT'));
end;

-- 5 create package
create or replace package teachers as                                     -- package specification
      procedure get_teachers (fcode faculty.faculty%type);
      procedure get_subjects (pcode subject.pulpit%type);
      function get_num_teachers (fcode faculty.faculty%type) return int;
      function get_num_subjects (pcode subject.pulpit%type) return int;
end teachers;


create or replace package body teachers as                        --  -- package body

      procedure get_teachers (FCODE FACULTY.FACULTY%type) as
          cursor curs is select teacher, teacher_name
          from teacher inner join pulpit on teacher.pulpit = pulpit.pulpit
          where faculty = FCODE;
          row curs%rowtype;
          begin
                for row in curs
                loop
                      dbms_output.put_line(row.teacher || ' '  || row.teacher_name);
                end loop;
          end;
          
      procedure get_subjects (PCODE SUBJECT.PULPIT%TYPE)
          as cursor curs is  select * from subject where pulpit = PCODE;
          row curs%rowtype;
          begin
              for row in curs
              loop
                  dbms_output.put_line(row.subject_name);
              end loop;
          end;
      
       function get_num_teachers (FCODE FACULTY.FACULTY%type) return int as num int;
          begin
              select count(*) into num
              from teacher inner join pulpit on teacher.pulpit = pulpit.pulpit
              where faculty = FCODE;
              return num;
          end;
              
      function get_num_subjects (PCODE SUBJECT.PULPIT%type) return int as num int;
          begin
              select count(*) into num from subject  where pulpit = PCODE;
              return num;
          end;
    
END teachers;


-- 6
begin 
    -- package_name.package_element();
    teachers.get_teachers('IDiP');
    dbms_output.put_line(teachers.get_num_teachers('IDiP'));
    
    teachers.get_subjects('ISiT');
    dbms_output.put_line(teachers.get_num_subjects('ISiT'));
end;
