--1.
select * from student;

select name, id, weight from student;

select 
    name || '''s ID : ' || id || ', WEIGHT is ' || weight || 'Kg' AS "ID AND WEIGHT"
from student;

--2.
select ename, ename, ename, ename from emp;
select ename, job from emp;

select ename || '(' || job || ') , ' || ename || '''' || job || '''' "NAME AND JOB"
from emp;

--3. 
select * from emp;
select ename, sal from emp;

select ename || '''s sal is $' || sal AS "Name and Sal" from emp;


