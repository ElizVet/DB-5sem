ALTER PLUGGABLE DATABASE OPEN;
-- DBMS_OUPUT - to output information for debugging
set serveroutput on; -- so that the DBMS_OUTPUT output is displayed in SQL+

-- 1	the simplest anonymous PL/SQL block
begin
   null; -- section of executed commands
end;


-- 2 create an AB that outputs "Hello World!"
begin
   dbms_output.put_line('Hello World!');
end;


-- 3 exception and sqlerrm, sqlcode operators
declare
   n auditorium.auditorium_name%type;
   v_code number;
   v_errm varchar2(164);
begin
   select auditorium_name into n 
   from auditorium 
   where auditorium_type = '******';
exception
  when others -- any exceptional situation
  then dbms_output.put_line('My error:  ' || sqlcode || '- ' || sqlerrm); -- SQLCODE - error number; SQLERRM - error message
end;


-- 4 nested block and exceptions
DECLARE
  x INTEGER := 1;
  y INTEGER := 0;
  z INTEGER := 0;
BEGIN
  dbms_output.put_line('x = ' || x || ', y = ' || y );
              begin
                    z := x / y;
                    DBMS_OUTPUT.PUT_LINE('nested block z = ' || Z ); -- not output because there was an error earlier
              exception when others 
                    then DBMS_OUTPUT.PUT_LINE('code = ' || SQLCODE || ', error = ' || SQLERRM);
              end;
  dbms_output.put_line('external block z = ' || z); -- output
END;

-- 5	compiler warning types
show parameter plsql_warnings;

-- 6	all PL/SQL special characters
SELECT keyword FROM v$reserved_words WHERE length = 1 AND keyword != 'A';

-- 7	all PL/SQL keywords
SELECT keyword FROM v$reserved_words WHERE length > 1 ORDER BY keyword;

-- 8	all Oracle Server parameters related to PL/SQL
SELECT NAME, VALUE FROM V$PARAMETER WHERE NAME LIKE 'plsql%';
show parameters plsql;

-- 9 OUTPUT THE RESULTS TO THE OUTPUT SERVER STREAM:
-- 10 integer number variables
DECLARE x INTEGER := 1;
BEGIN
  dbms_output.put_line(x);
END;

-- 11 arithmetic operations, division with remainder
DECLARE
  X NUMBER := 5;
  y NUMBER := 7;
BEGIN
  dbms_output.put_line('amount = ' || (x + y) ||', minus = ' || (y - x) ||  ', division = ' || (y / x) || ', mod = ' || (MOD(X, Y)));
END;

-- 12 number fixed-point variables
declare x number(10, 4) := 6666.66666666666; -- 10 - total number of digits; 2 - after the decimal point
begin
  dbms_output.put_line(x);
end;

-- 13 number variables with fixed point and negative scale
declare x number(8, -1) := 125.8; --------------- 127 ------------ 7 replace 0 and round off 2
                  y NUMBER(8, -1) := 125.2;
begin
  dbms_output.put_line(x || ', ' || y);
END;

-- 14 BINARY_FLOAT-variable
declare
  x binary_float := 123.2341234;                          -- 32-bit
begin
  dbms_output.put_line(x);
end;

-- 15  BINARY_DOUBLE-variable;
declare
  x binary_double := 123.23412343456789;  -- 64-bit
begin
  dbms_output.put_line(x);
end;

-- 16 declaring number variables with a dot and using the symbol E (power of 10)
declare
  x number(25, 0) := 123.2E10; -- symbol E (power of 10)
begin
  dbms_output.put_line(x);
end;

-- 17 BOOLEAN-variable.  
declare
  x boolean;
begin
  if x is null then dbms_output.put_line('null'); end if;
   x := false;
  if not x then dbms_output.put_line('false'); end if;
  x := true;
  if x then DBMS_OUTPUT.PUT_LINE('true'); end if;
end;

-- 18 AB with consts: VARCHAR2, CHAR, NUMBER
declare
  X CONSTANT varchar2(20) := 'varchar2';
  Y CONSTANT char not null default 'f';
  Z CONSTANT number not null := 12;
begin
  X := '2';
  DBMS_OUTPUT.PUT_LINE(Z);
  EXCEPTION when OTHERS then
  DBMS_OUTPUT.PUT_LINE('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

-- 19 AB with %TYPE option
declare
   auditName AUDITORIUM.AUDITORIUM_NAME%TYPE default 'f'; -- based on another variable or table field
begin
    DBMS_OUTPUT.PUT_LINE(auditName);
    select AUDITORIUM_NAME into AUDITNAME from AUDITORIUM where AUDITORIUM = '314-4';
    DBMS_OUTPUT.PUT_LINE(auditName);
END;

--20	AB with %ROWTYPE option
declare
  p PULPIT%ROWTYPE; -- based on a table or cursor
begin
  P.PULPIT_NAME := 'pulp_name';
  P.PULPIT := 'pulp_pulp';
  dbms_output.put_line(p.PULPIT_NAME || ', ' || p.PULPIT);
  EXCEPTION WHEN OTHERS THEN
  dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
END;

-- 21-22 IF
declare
  x integer := 17;
begin
      IF x > 10 THEN dbms_output.put_line('> 10'); END IF;
end;
-----------------------
declare
  X integer := 17;
begin
      if X > 10 then DBMS_OUTPUT.PUT_LINE('> 10'); 
      else DBMS_OUTPUT.PUT_LINE('<= 10');
      END IF;
end;
-----------------------
declare
  X integer := 17;
begin
      if X > 10 
      then 
            DBMS_OUTPUT.PUT_LINE('> 10'); 
      else-if X = 10 
      then 
            DBMS_OUTPUT.PUT_LINE('= 10'); 
      else 
            dbms_output.put_line('< 10'); 
      end if;
end;


-- 23 CASE
DECLARE
  x PLS_INTEGER := 9;
begin
      CASE 
      WHEN x > 10
      THEN 
            dbms_output.put_line('pulpit > 10');
      WHEN x < 10
      THEN 
            dbms_output.put_line('pulpit < 10');
      ELSE 
            dbms_output.put_line('else');
      END CASE;
END;

-- 24 LOOP.
DECLARE
  x PLS_INTEGER := 0;
BEGIN
  LOOP
    dbms_output.put_line(x);
    EXIT WHEN x > 5;
    x := x + 1;
  END LOOP;
END;

-- 25 WHILE
DECLARE
  x PLS_INTEGER := 0;
BEGIN
  WHILE (x < 10)
  LOOP
    x := x + 1;
    dbms_output.put_line(x);
  END LOOP;
END;

-- 26 FOR
BEGIN
  FOR k IN 1..10
  LOOP
    dbms_output.put_line(k);
  END LOOP;
END;








 