-- 2
create tablespace SEK_QDATA
  datafile 'C:\app\ora_install_user\tablespaces\SEK_QDATA.dbf'
  size 10 m
  autoextend on next 5 m
  maxsize 30 m
  extent management local
  offline;

alter tablespace SEK_QDATA online;

alter user C##SEK default tablespace SEK_QDATA quota 2m on SEK_QDATA;

--------------------------------
-- CHECK
select * from dba_ts_quotas;
SELECT tablespace_name, STATUS, contents logging FROM sys.dba_tablespaces;
--------------------------------

GRANT CREATE SESSION,
      CREATE TABLE,
      CREATE VIEW,
      CREATE PROCEDURE,
      DROP ANY TABLE,
      DROP ANY VIEW,
      DROP ANY PROCEDURE TO C##SEK;

--from C##SEK
create table sek_table (
    num1 number(5) primary key,
    num2 number(5)) tablespace SEK_QDATA;
    
insert into sek_table values (1, 1);
insert into sek_table values (2, 1);
insert into sek_table values (3, 1);

select * from sek_table;
commit;




