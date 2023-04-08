-- 1 sga_size
select sum(value) from v$sga;

-- 2 sga_pools
select * from v$sga_dynamic_components where current_size > 0;

-- 3 granule_size
select component, granule_size from v$sga_dynamic_components where current_size > 0;

-- 4 free_memory_sga
select current_size from v$sga_dynamic_free_memory;

-- 5 keep_default_recycle
select * from v$sga_dynamic_components where component like '%cache%';

-- 6 table_into_keep

create table T1(
  num int primary key,
  str varchar(150)) storage(buffer_pool KEEP);

select * from user_segments where segment_name = 'T1';


-- 7 cache_default
create table T1_CACHE(
  num int primary key,
  str varchar(150))cache storage(buffer_pool default);

select * from user_segments where segment_name = 'T1_CACHE';

-- 8 show_log_buffer
show parameter log_buffer;

-- 9 biggest_object_shared_pool
select distinct pool, name, bytes 
from v$sgastat
where POOL = 'shared pool'
order by bytes desc fetch first 10 rows only;

-- 10 free_memory_large_pool
select * from v$sgastat where pool = 'large pool' and name = 'free memory';

-- 11_12 current_connections
select username, service_name, server 
from v$session 
where username is not null;

-- 13 most_used_objects
select * from v$db_object_cache order by executions desc;













