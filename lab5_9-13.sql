-- 9 redo logs (groups)
select Group#,Status,Members from V$LOG;

-- 10 redo logs (files)
select * from V$LOGFILE;

-- 11
select * from V$LOG; 
-- 19-OCT-22
-- 2:14 PM 10/19/2022

alter system switch logfile;
select GROUP#, SEQUENCE#,STATUS,FIRST_CHANGE#  From V$LOG;

-- 12 create group with 3 files
alter database add logfile group 4 'C:\app\ora_install_user\oradata\orcl\REDO04.LOG' size 50m blocksize 512;

alter database add logfile member 'C:\app\ora_install_user\oradata\orcl\REDO041.LOG' to group 4;
alter database add logfile member 'C:\app\ora_install_user\oradata\orcl\REDO042.LOG' to group 4;
alter database add logfile member 'C:\app\ora_install_user\oradata\orcl\REDO043.LOG' to group 4;

------------------CHECK----------------
select GROUP#, SEQUENCE#,STATUS,FIRST_CHANGE#  From V$LOG;


-- 13
alter database drop logfile member 'C:\app\ora_install_user\oradata\orcl\REDO041.LOG';
alter database drop logfile member 'C:\app\ora_install_user\oradata\orcl\REDO042.LOG';
alter database drop logfile member 'C:\app\ora_install_user\oradata\orcl\REDO043.LOG';

alter database drop logfile group 4;



