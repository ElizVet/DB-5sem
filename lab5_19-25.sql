-- 19 list of control files
select * from v$controlfile;


-- 20 parameters in the control file
select * from v$controlfile_record_section;


-- 21 location of the parameters file

--sql plus /nolog
--connect /as sysdba
show parameter spfile;

-- 22 Create a PFILE
create pfile = 'SEK_PFILE.ORA' from spfile;

-- 23 location of the password file
--sql plus

-- 24 list of directories for message and dialog files
select * from v$diag_info;





