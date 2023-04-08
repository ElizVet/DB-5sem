create table XXX_t( x number(3) unique, s varchar2(50) );

INSERT INTO XXX_t VALUES (1, 'Hello1');
INSERT INTO XXX_t VALUES (2, 'Hello2');
INSERT INTO XXX_t VALUES (3, 'Hello3');
commit;
 
SELECT * FROM XXX_t;

update XXX_t set S = 'Bye' where x=2 or x=3;
commit;

SELECT * FROM XXX_t where x=2 or x=3;

DELETE FROM XXX_t where x=2;
commit;

SELECT count(*) as count FROM XXX_t;

create table XXX_t1( idd number(3), x number(3), FOREIGN KEY (x) REFERENCES XXX_t(x));

INSERT INTO XXX_t1 VALUES (1, 3);
INSERT INTO XXX_t1 VALUES (2, 1);
INSERT INTO XXX_t1 VALUES (3, 1);

SELECT * FROM XXX_t1;

-- inner join
SELECT t.s, t1.idd
FROM XXX_t t inner join XXX_t1 t1
on t.x = t1.x;

-- left join
SELECT t.s, t1.idd
FROM XXX_t t left join XXX_t1 t1
on t.x = t1.x;

-- right join
SELECT t.s, t1.idd
FROM XXX_t t right join XXX_t1 t1
on t.x = t1.x;

DROP TABLE XXX_t1;
DROP TABLE XXX_t;
