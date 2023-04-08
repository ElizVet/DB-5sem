-- 1 existing pdbs
select name, open_mode from v$pdbs;

-- 2 list of instances
select * from v$instance;

-- 3 list of installed DBMS components
select comp_name, version, status from dba_registry;

-- 4
-- create pdb with Database Configuration Assistant

-- SQLPlus:
 -- connect /as sysdba
-- alter pluggable database all  open;

-- 5 existing pdbs
select name, open_mode from v$pdbs;

-- 6 -- use connection SYS_to_SEK_PDB
CREATE TABLESPACE TS_SEK_PDB
Datafile 'C:\app\ora_install_user\tablespaces\TS_SEK_PDB.dbf' 
size 7M
autoextend ON NEXT 5M
maxsize 20M;
SELECT tablespace_name, STATUS, contents logging FROM sys.dba_tablespaces;

CREATE TEMPORARY TABLESPACE TS_SEK_PDB_TEMP
TEMPFILE 'C:\app\ora_install_user\tablespaces\TS_SEK_PDB_TEMP_PDB.dbf'
SIZE 5M
AUTOEXTEND ON NEXT 3M
MAXSIZE 30M
EXTENT MANAGEMENT LOCAL;

--ALTER SESSION SET "_ORACLE_SCRIPT"=true;

CREATE ROLE RL_SEKCORE_PDB;

GRANT CREATE SESSION,
      CREATE TABLE,
      CREATE VIEW,
      CREATE PROCEDURE,
      DROP ANY TABLE,
      DROP ANY VIEW,
      DROP ANY PROCEDURE TO RL_SEKCORE_PDB;

CREATE PROFILE PR_SEKCORE_PDB LIMIT
password_life_time 180 --NUMBER OF PASSWORD'S DAYS ALIVE
sessions_per_user 3 -- NUMBER OF USER'S SESSIONS
failed_login_attempts 7 --NUMBER OF LOGGIN ATTEMPTS
password_lock_time 1 --NUMBER OF LOCKED DAYS AFTER FAILED LOGIN
password_reuse_time 10 --AFTER THIS DAYS NUMBER YOU CAN REPEAT PASSWORD
password_grace_time DEFAULT --DAYS NUMBER OF WARNING ABOUT CHANGE PASSWORD
connect_time 180 --IN MINUTE
idle_time 30 --IN MINUTE

CREATE USER U1_SEK_PDB IDENTIFIED BY Password2
DEFAULT TABLESPACE TS_SEK_PDB QUOTA UNLIMITED ON TS_SEK_PDB
TEMPORARY TABLESPACE TS_SEK_PDB_TEMP
PROFILE PR_SEKCORE_PDB
ACCOUNT UNLOCK;
  
GRANT RL_SEKCORE_PDB TO U1_SEK_PDB;

SELECT tablespace_name, STATUS, contents logging FROM sys.dba_tablespaces;
SELECT * FROM DBA_SYS_PRIVS where grantee = 'RL_SEKCORE_PDB';

-- 7 -- use connection U1_SEK_PDB_to_SEK_PDB
create table SEK_table(x int, y int);

insert into SEK_table values (0, 0);
insert into SEK_table values (1, 1);

select * from SEK_table;

-- 8 -- use connection SYS_to_SEK_PDB
SELECT tablespace_name, status, contents FROM user_tablespaces;

SELECT file_name, status  FROM dba_data_files;
SELECT file_name, status FROM dba_temp_files;

SELECT * FROM dba_roles;
SELECT * FROM dba_role_privs order by grantee;

SELECT * FROM dba_profiles;
SELECT * FROM dba_users;

SELECT u.username, r.granted_role FROM dba_users u
JOIN dba_role_privs r ON u.username = r.grantee;
  
  -- 9 
CREATE USER C##SEK IDENTIFIED BY Password3
ACCOUNT UNLOCK;

GRANT CREATE SESSION TO C##SEK;

-- SEK_to_CDB

-- SEK_to_SEK_PDB






