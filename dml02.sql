/****************************************/
DML
MERGE


--신발가게 날짜별 매출
CREATE TABLE T_SHOE
(
    work_date DATE,  --영업일
    store_code NUMBER(3),  --매장 고유 코드 (PK) (10, 20, 30, 40 ..)
    sales_income NUMBER(10) --매출금액  
);

--옷가게 날짜별 매출
CREATE TABLE T_CLOTH
(
    work_date DATE,  --영업일
    store_code NUMBER(3),  --매장 고유 코드 (PK) (1,2,3,4...)
    sales_income NUMBER(10) --매출금액  
);


--본사 날짜별 전체 매출 취합
CREATE TABLE T_COMPANY
(
    work_date DATE,  --영업일
    store_code NUMBER(3),  --매장 고유 코드 (PK)
    sales_income NUMBER(10) --매출금액  
);

INSERT ALL
INTO T_SHOE VALUES (TO_DATE('2025-03-01'), 1, 5000)
INTO T_SHOE VALUES (TO_DATE('2025-03-02'), 1, 15000)
INTO T_SHOE VALUES (TO_DATE('2025-03-03'), 1, 30000)
INTO T_SHOE VALUES (TO_DATE('2025-03-02'), 2, 4000)
INTO T_SHOE VALUES (TO_DATE('2025-03-03'), 2, 90000)
INTO T_SHOE VALUES (TO_DATE('2025-03-04'), 2, 120000)
INTO T_SHOE VALUES (TO_DATE('2025-03-04'), 1, 90000)
select * from dual;

INSERT INTO T_SHOE VALUES (TO_DATE('2025-03-04'), 1, 90000);


INSERT ALL
INTO T_CLOTH VALUES (TO_DATE('2025-03-01'), 10, 59000)
INTO T_CLOTH VALUES (TO_DATE('2025-03-02'), 10, 25000)
INTO T_CLOTH VALUES (TO_DATE('2025-03-03'), 10, 33000)
INTO T_CLOTH VALUES (TO_DATE('2025-03-04'), 20, 4400)
INTO T_CLOTH VALUES (TO_DATE('2025-03-05'), 20, 99000)
INTO T_CLOTH VALUES (TO_DATE('2025-03-06'), 20, 790000)
select * from dual;

DELETE FROM T_CLOTH;


T_SHOE
T_CLOTH   >>> T_COMPANY

INSERT INTO T_COMPANY
SELECT work_date, store_code, sales_income from T_SHOE;

INSERT INTO T_COMPANY
SELECT work_date, store_code, sales_income from T_CLOTH;

select * from T_COMPANY;
select * from T_SHOE;
select * from T_CLOTH;


select store_code, SUM(sales_income)
from T_COMPANY
group by store_code;

select work_date, SUM(sales_income)
from T_COMPANY
group by work_date;

--주기적으로 (Batch) 취합 실행

1) 전부 DELETE 하고 다시 INSERT

DELETE FROM T_COMPANY;

INSERT INTO T_COMPANY
SELECT work_date, store_code, sales_income from T_SHOE;

INSERT INTO T_COMPANY
SELECT work_date, store_code, sales_income from T_CLOTH;

2) MERGE 

MERGE INTO 최종저장될테이블명
USING 가져올테이블명
ON (병합/비교 기준조건)
WHEN MATCHED THEN
    --있을때
    UPDATE SET
    DELETE WHERE 삭제조건
WHEN NOT MATCHED THEN
    --없을때
    INSERT
;

--날짜 1개만 기준
MERGE INTO T_COMPANY CP
USING T_CLOTH CL
ON (cp.work_date = cl.work_date)
WHEN MATCHED THEN
    UPDATE SET cp.sales_income = cl.sales_income
WHEN NOT MATCHED THEN
    INSERT VALUES (cl.work_date, cl.store_code, cl.sales_income);
    
MERGE INTO T_COMPANY CP
USING T_SHOE T
ON (cp.work_date = T.work_date)  --날짜 하나로는 병합기준으로 사용 불가능!
                                --동일 날짜가 겹쳐서 진행이 안됨
WHEN MATCHED THEN
    UPDATE SET cp.sales_income = T.sales_income
WHEN NOT MATCHED THEN
    INSERT VALUES (T.work_date, T.store_code, T.sales_income);

select * from T_COMPANY;
select * from T_SHOE;
select * from T_CLOTH;

UPDATE T_CLOTH
SET sales_income = 38000
WHERE work_date = '2025-03-03';


--영업날짜 + 매장코드   병합기준
MERGE INTO T_COMPANY CP
USING T_CLOTH CL
ON (cp.work_date = cl.work_date AND cp.store_code = cl.store_code)
WHEN MATCHED THEN
    UPDATE SET cp.sales_income = cl.sales_income
WHEN NOT MATCHED THEN
    INSERT VALUES (cl.work_date, cl.store_code, cl.sales_income);


MERGE INTO T_COMPANY CP
USING T_SHOE T
ON (cp.work_date = T.work_date AND cp.store_code = T.store_code)
WHEN MATCHED THEN
    UPDATE SET cp.sales_income = T.sales_income
WHEN NOT MATCHED THEN
    INSERT VALUES (T.work_date, T.store_code, T.sales_income);


UPDATE T_CLOTH
SET sales_income = 29900
WHERE work_date = '2025-03-02';

UPDATE T_SHOE
SET sales_income = 4900
WHERE work_date = '2025-03-02' AND store_code = 2;



/*************************************************/
--본사 날짜별 전체 매출 취합 + 매장 판매유형 구분코드 추가 버전
CREATE TABLE T_COMPANY_TYPE
(
    work_date DATE,  --영업일
    store_code NUMBER(3),  --매장 고유 코드 (PK)
    sales_income NUMBER(10), --매출금액  
    store_type VARCHAR2(8)  --매장 유형 구분코드 'C' 옷가게 / 'S' 신발가게 
);


MERGE INTO T_COMPANY_TYPE CP
USING T_CLOTH CL
ON (cp.work_date = cl.work_date AND cp.store_code = cl.store_code)
WHEN MATCHED THEN
    UPDATE SET cp.sales_income = cl.sales_income
WHEN NOT MATCHED THEN
    INSERT VALUES (cl.work_date, cl.store_code, cl.sales_income, 'C');


MERGE INTO T_COMPANY_TYPE CP
USING T_SHOE T
ON (cp.work_date = T.work_date AND cp.store_code = T.store_code)
WHEN MATCHED THEN
    UPDATE SET cp.sales_income = T.sales_income
WHEN NOT MATCHED THEN
    INSERT VALUES (T.work_date, T.store_code, T.sales_income, 'S');
    
select * 
from T_COMPANY_TYPE
WHERE store_type = 'C';

select 
    store_type,
    store_code,
    SUM(sales_income)
from T_COMPANY_TYPE
group by store_type, store_code;
