-- 1 bg_process
select * from v$bgprocess;

-- 2 running_bg_process
select * from v$bgprocess where paddr != '00';

-- 3 running_dbwn_process
select count(*) from v$bgprocess 
where paddr!= '00' and name like 'DBW%';

-- 4_5 list_current_session_and_their_modes
select username, status, server 
from v$session 
where username is not null;

-- 6 services
select name, network_name, pdb from v$services;

-- 7 dispatchers_parameters
show parameter dispatcher;

-- 8 cmd --> services.msc --> OracleOraDB12Home1TNSListener

-- 9 current_connection_instance
select paddr, username, service_name, server, osuser, machine, program
from v$session where username is not null;

-- 10 listner_ora
-- connect string

-- 11 cmd --> lsnrctl --> help

-- 12 --> services
