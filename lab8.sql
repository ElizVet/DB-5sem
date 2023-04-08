---- 1 config files

D:\app\OracleUser\product\12.1.0\dbhome_2\network\admin\sqlnet.ora
D:\app\OracleUser\product\12.1.0\dbhome_2\network\admin\tnsnames.ora               -- file with info about network connections


---- 2 parameter instance

system
--password

show parameter instance


---- 3 system_to_SEK_PDB info

connect system/password1@localhost:1521/SEK_PDB

select tablespace_name, contents from dba_tablespaces;
select name from dba_data_files;
select username, user_id from all_users;
select role from dba_roles;


-- 4 HKEY_LOCAL_MACHINE
-- configuration parameters to locate files and specify run-time parameters common 
-- to all Oracle products

regedit
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Oracle


-- 5 Net Manager

-- Start -> All programs -> Oracle OraDB12Home1 -> Configuration and Migration tools -> Net Manager
create connection in Net Manager: SEK_PDB
connection in SQL Developer: U1_SEK_PDB_to_SEK_PDB_TNS


-- 6 connect

connect U1_SEK_PDB/Password2@SEK_PDB


-- 7 any select

select * from SEK_TABLE;


-- 8 commands help and timing

help
help timing
set timing on;
select * from SEK_TABLE;
set timing off;


-- 9 command DESCRIBE

connect U1_SEK_PDB/Password2@SEK_PDB
describe SEK_TABLE; -- null and type


-- 10 list segments with owner U1_SEK_PDB

connect U1_SEK_PDB/Password2@SEK_PDB
select segment_type, tablespace_name, blocks, extents from user_segments;


-- 11 extents_and_others

connect SYS/password2@SEK_PDB as sysdba
create view EXTENTS as select extents, blocks, bytes from dba_segments;
select * from EXTENTS;




