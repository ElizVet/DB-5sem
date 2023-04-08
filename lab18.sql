create table LOADER_TABLE
(
    num number,
    str nvarchar2(10),
    date_mark date check (EXTRACT(Month from date_mark)=2)
);

-- sqlldr userid=sysdba/12345 control=param.ctl

select * from LOADER_TABLE;

-- connections -> LOADER_TABLE -> right click -> export

drop table LOADER_TABLE;