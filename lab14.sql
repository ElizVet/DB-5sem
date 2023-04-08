alter pluggable database all open;

-- SYSTEM_to_CDB
create table system_table ( num int primary key, str nvarchar2(20) );
insert into system_table values (1, 'str 1');
commit;
select * from system_table;

---------- CREATE ---------- from sys_to_cdb
create database link to_system_cdb
connect to system
identified by password
using 'ORCL';

---------- CHECK ---------- from system_to_ord
select * from dba_db_links;

-- SELECT, INSERT, UPDATE
select * from system_table@to_system_cdb; -- remote_db_table@db_link_name
insert into system_table@to_system_cdb values (2, 'str 2');
update system_table@to_system_cdb set str = 'HELLO' where num = 2;

select * from system_table@to_system_cdb;
delete from system_table@to_system_cdb where num = 2;



---------- CREATE GLOBAL ---------- from sys_to_cdb
create public database link to_system_global_cdb
connect to system
identified by password
using 'ORCL';



---------- SELECT, INSERT, UPDATE ---------- from sys_to_cdb
select * from system_table@to_system_global_cdb;
insert into system_table@to_system_global_cdb values (2, 'str 2');
update system_table@to_system_global_cdb set str = 'HELLO' where num = 2;
select * from system_table@to_system_global_cdb;
delete from system_table@to_system_global_cdb where num = 2;
  

-- alter session close database link anotherdb;

drop database link to_system_cdb;
drop public database link to_system_global_cdb;



