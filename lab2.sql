-- ex1
CREATE TABLESPACE TS_SEK
Datafile 'C:\app\ora_install_user\TS_SEK.dbf' 
size 7M
autoextend ON NEXT 5M
maxsize 20M;

-- ex2
CREATE TEMPORARY TABLESPACE TS_SEK_TEMP 
tempfile 'C:\app\ora_install_user\TS_SEK_TEMP.dbf' 
size 5 m 
autoextend ON NEXT 3 m
maxsize 30 m
extent management local;

-- ex3
SELECT tablespace_name, STATUS, contents logging FROM sys.dba_tablespaces;

SELECT file_name,
    tablespace_name,
    status,
    maxbytes,
    user_bytes
  FROM DBA_DATA_FILES
  UNION
  SELECT file_name,
    tablespace_name,
    status,
    maxbytes,
    user_bytes
  FROM DBA_TEMP_FILES;

-- ex4
CREATE ROLE C##RL_SEKCORE;

SELECT * FROM dba_roles WHERE role like 'C##RL%';

GRANT CREATE SESSION,
                CREATE TABLE,
                CREATE VIEW, 
                CREATE PROCEDURE TO C##RL_SEKCORE;

-- ex5
SELECT * FROM DBA_SYS_PRIVS where GRANTEE = 'C##RL_SEKCORE';

-- ex6
CREATE PROFILE C##PF_SEKCORE limit
  password_life_time 180
  sessions_per_user 3
  failed_login_attempts 7
  password_lock_time 1
  password_reuse_time 1
  password_grace_time default
  connect_time 180
  idle_time 30

-- ex7
SELECT * from DBA_PROFILES;

SELECT * from DBA_PROFILES where PROFILE = 'C##PF_SEKCORE';

SELECT * from DBA_PROFILES where PROFILE = 'DEFAULT';
 
 -- ex8
 CREATE USER c##SEKCORE IDENTIFIED BY 12345 -- password
default TABLESPACE TS_SEK quota unlimited on TS_SEK
temporary TABLESPACE TS_SEK_TEMP 
PROFILE C##PF_SEKCORE
ACCOUNT UNLOCK
PASSWORD EXPIRE;  -- you need to change the password
 
-- ex9
GRANT C##RL_SEKCORE TO C##SEKCORE;

-- ex10
CREATE table students
(idd number(10) not null,
last_name varchar(20) not null,
course number(10)
);

CREATE view task10 as 
select idd, last_name, course from students;

-- ex11
CREATE tablespace SEK_QDATA
datafile 'C:\app\ora_install_user\SEK_QDATA.dbf'
size 10M
autoextend on next 5M
maxsize 20M
offline;

alter tablespace SEK_QDATA online;

drop tablespace SEK_QDATA
alter user c##SEKCORE quota 2m on SEK_QDATA;


CREATE TABLE SEK_T1
(teacher_id number(10) not null primary key,
teacher_name varchar(20) not null,
teacher_age number(10) not null);

INSERT into SEK_T1(teacher_id,teacher_name,teacher_age) values (1,'Ivan',19);
INSERT into SEK_T1(teacher_id,teacher_name,teacher_age) values (2,'Dima',20);
INSERT into SEK_T1(teacher_id,teacher_name,teacher_age) values (3,'Kirill',18);

SELECT * from SEK_T1;





drop TABLESPACE TS_SEK;
drop ROLE C##RL_SEKCORE;
drop PROFILE C##PF_SEKCORE;
drop USER SEKCORE;
drop table students;
drop view task10;
drop tablespace SEK_QDATA;
drop TABLE SEK_T1;






