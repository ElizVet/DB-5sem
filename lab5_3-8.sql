-- 3 segments before drop

-- from C##SEK
select distinct * from user_segments where tablespace_name = 'SEK_QDATA';

-- 4 segments after drop
drop table SEK_TABLE;

select distinct * from user_segments where tablespace_name = 'SEK_QDATA';

select * from user_recyclebin;

-- 5 flashback
flashback table SEK_TABLE to before drop;

select * from SEK_TABLE;

-- 6 insert into sek_table 10000 values (PL/SQL-script)
declare i int:= 0;
begin 
    loop i:=i+1;
        insert into sek_table values (i, 1);
        COMMIT;
        exit when(i = 10000);
    end loop;
end;

select count(*) from sek_table;

-- 7 how many extents are there in a segment
select * from user_segments where tablespace_name = 'SEK_QDATA';

select * from user_extents where tablespace_name = 'SEK_QDATA';

-- 8 drop tablespaces and files

-- from sys
drop tablespace SEK_QDATA including contents and datafiles;



