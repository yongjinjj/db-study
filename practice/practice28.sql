CREATE TABLE TABLE_DATA_1
(
no number(10),
create_date DATE
);

CREATE TABLE TABLE_DATA_2
(
no number(10),
create_date DATE
);

CREATE TABLE TABLE_COLC
(
std_date DATE,
CHECK_DATA1 VARCHAR2(6),
CHECK_DATA2 VARCHAR2(6)
);

INSERT INTO TABLE_DATA_1 VALUES (1, '2023-04-01');
INSERT INTO TABLE_DATA_1 VALUES (2, '2023-04-02');
INSERT INTO TABLE_DATA_1 VALUES (3, '2023-04-03');
INSERT INTO TABLE_DATA_1 VALUES (4, '2023-04-04');

INSERT INTO TABLE_DATA_2 VALUES (1, '2023-04-02');
INSERT INTO TABLE_DATA_2 VALUES (2, '2023-04-03');
INSERT INTO TABLE_DATA_2 VALUES (3, '2023-04-04');
INSERT INTO TABLE_DATA_2 VALUES (4, '2023-04-05');

select * from TABLE_DATA_1;
select * from TABLE_DATA_2;
select * from TABLE_COLC
order by std_date;

select * from TABLE_COLC
where check_data1 = 'N';  --'Y' / 'N'   'T' / 'F'   1 / 0  

--A업체데이터 처리 기준
MERGE INTO TABLE_COLC C
USING TABLE_DATA_1 T
ON (C.std_date = T.create_date)
WHEN MATCHED THEN  --날짜가 있는 경우
    UPDATE SET C.CHECK_DATA1 = 'Y'   -- 'Y' / 'N'
WHEN NOT MATCHED THEN --날짜가 없는 경우
    INSERT VALUES (T.create_date, 'Y', 'N');

--B업체데이터 처리 기준
MERGE INTO TABLE_COLC C
USING TABLE_DATA_2 T
ON (C.std_date = T.create_date)
WHEN MATCHED THEN  --날짜가 있는 경우
    UPDATE SET C.CHECK_DATA2 = 'Y'   -- 'Y' / 'N'
WHEN NOT MATCHED THEN --날짜가 없는 경우
    INSERT VALUES (T.create_date, 'N', 'Y');
    
    
