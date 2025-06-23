1. professor 테이블과 department 테이블을 조회하여 
각 학과별로 입사일이 가장 오래된 교수의 교수번호와 이름, 학과명을 출력하세요
(입사일 순으로 오름차순 정렬)
;

select p.profno, p.name, d.dname
from professor p, department d
where (p.deptno, p.hiredate) IN 
        (select deptno, MIN(hiredate)
            from professor
           group by deptno)
    AND p.deptno = d.deptno
ORDER BY hiredate
;

select * from department;

select deptno, MIN(hiredate)
from professor
group by deptno;


select p1.profno, 
        p1.name, 
        (select d.dname 
            from department d
            where d.deptno = p1.deptno) dname
from professor p1
where p1.hiredate = (select MIN(p2.hiredate)
                    from professor p2
                    where p2.deptno = p1.deptno                   
                    );

select MIN(hiredate)
from professor
where deptno = 101;


select profno, name, dname
from (
    select profno, name,
           deptno, hiredate,
           RANK() OVER (PARTITION BY deptno ORDER BY hiredate) rank
    from professor) A, department B
where rank = 1
AND A.deptno = B.deptno;



2. emp2 테이블 조회하여 
직급별로 해당 직급에서 최대 연봉을 받는 직원의 이름과 직급, 연봉을 출력하세요
(연봉순으로 오름차순 정렬)
;

select name, position, pay
from emp2
where (position, pay) IN (
                        select position, MAX(pay)
                        from emp2
                        group by position)
ORDER BY pay;



