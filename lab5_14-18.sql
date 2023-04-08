-- 14 is archiving in progress or not
select GROUP#, ARCHIVED from V$LOG;

SELECT NAME, LOG_MODE FROM V$DATABASE;
select instance_name, archiver, active_state from v$instance;

-- 15 last archive number
select * from (select * from v$archive_dest_status order by dest_id desc) 
where rownum = 1;

-----------------------sql plus-------------------------
-- 16

-- Turn on archiving
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG; --
ALTER DATABASE OPEN;
archive log list;

-- 17
alter system switch logfile;
select * from V$archived_log;

-- 18 Turn off archiving
STARTUP MOUNT;
ALTER DATABASE NOARCHIVELOG; --
ALTER DATABASE OPEN;
archive log list;








