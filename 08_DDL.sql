/* ***********************************************************************************
DDL - databass 객체(ex. table, user ...)를 관리한다.
      (객체를 생성, 수정, 삭제)
      - 생성: create
      - 수정: alter
      - 삭제: drop

테이블 생성
- 구문
create table 테이블 이름(
  컬럼 설정
)

제약조건 설정 
- 컬럼 레벨 설정
    - 컬럼 설정에 같이 설정
- 테이블 레벨 설정
    - 컬럼 설정뒤에 따로 설정

- 기본 문법 : constraint 제약조건이름 제약조건타입
- 테이블 제약 조건 조회
    - USER_CONSTRAINTS 딕셔너리 뷰에서 조회
    
테이블 삭제
- 구분
DROP TABLE 테이블이름 [CASCADE CONSTRAINTS]

rollback / commit -> DML에만 적용. DDL은 바로 적용됨.
*********************************************************************************** */

create table parent_tb(
        no  number constraint pk_parent_tb primary key,    -- 제약조건에 이름을 준다. (그냥 primary key 라고 하면 랜덤으로 이름 생성됨)
        name nvarchar(30) not null, 
        birthday date default sysdate,    -- 기본값 설정(현재 날짜로). insert시 값을 넣지 않으면 기본값이 들어감.
        email varchar2(100) constraint uk_parent_tb_email unique,    -- nuique 제약조건에 이름을 준다. (유일값)
        gender char(1) not null, constraint ck_parent_tb_gender check(gender in ('M', 'F')    -- m과 f만 들어가게 하겠다. check key. where절 조건처럼 들어감.
);

insert into prent_tb values (1, '홍길동', '2000/01/01', 'a@a.com', 'M')
insert into prent_tb (no, name, gender) values (2, '이순신', 'M')    -- 날짜 데이터 넣지 않아서 기본값(sysdate)가 들어감. email은 기본값 설정 안 해서 null.
insert into prent_tb values (3, '홍길동2', null, 'b@a.com', 'M')    -- 명시적으로 null을 넣으면 default 값이 아니라 null 값이 insert 된다. (null이라는 값이 있는 것)
insert into prent_tb values (4, '홍길동3', null, 'b@a.com', 'M')    -- email은 unique key이기 때문에 오류 발생.
insert into prent_tb values (5, '홍길동4', null, 'c@a.com', 'm')    -- check key에 할당하지 않은 값이기 때문에 오류 발생(gender)


create table child_tb(
        no number,    -- pk
        jumin_num char(14) not null,    -- uk
        age number(3) default 0,    -- 0 ~ 90 ck
        parent_no number    -- parent_tb를 참조하는 fk
        constraint pk_child_tb primary key(no),
        constraint uk_child_tb unique key(jumin_num),
        constraint ch_child_tb check(age between 10 and 90),
        constraint fk_child_tb_parent_tb foreign key(parent_no) reference parant_tb(no)      
);



/* ************************************************************************************
ALTER : 테이블 수정

컬럼 관련 수정

- 컬럼 추가
  ALTER TABLE 테이블이름 ADD (추가할 컬럼설정 [, 추가할 컬럼설정])
  - 하나의 컬럼만 추가할 경우 ( ) 는 생략가능

- 컬럼 수정
  ALTER TABLE 테이블이름 MODIFY (수정할컬럼명  변경설정 [, 수정할컬럼명  변경설정])
	- 하나의 컬럼만 수정할 경우 ( )는 생략 가능
	- 숫자/문자열 컬럼은 크기를 늘릴 수 있다. (안에 들어있는 값이 있기 때문)
		- 크기를 줄일 수 있는 경우 : 열에 값이 없거나 모든 값이 줄이려는 크기보다 작은 경우
	- 데이터가 모두 NULL이면 데이터타입을 변경할 수 있다. (단 CHAR<->VARCHAR2 는 가능.)

- 컬럼 삭제	
  ALTER TABLE 테이블이름 DROP COLUMN 컬럼이름 [CASCADE CONSTRAINTS]
    - CASCADE CONSTRAINTS : 삭제하는 컬럼이 Primary Key인 경우 그 컬럼을 참조하는 다른 테이블의 Foreign key 설정을 모두 삭제한다.
	- 한번에 하나의 컬럼만 삭제 가능.
	
  ALTER TABLE 테이블이름 SET UNUSED (컬럼명 [, ..])
  ALTER TABLE 테이블이름 DROP UNUSED COLUMNS
	- SET UNUSED 설정시 컬럼을 바로 삭제하지 않고 삭제 표시를 한다. 
	- 설정된 컬럼은 사용할 수 없으나 실제 디스크에는 저장되 있다. 그래서 속도가 빠르다.
	- DROP UNUSED COLUMNS 로 SET UNUSED된 컬럼을 디스크에서 삭제한다. 

- 컬럼 이름 바꾸기
  ALTER TABLE 테이블이름 RENAME COLUMN 원래이름 TO 바꿀이름;

**************************************************************************************  
제약 조건 관련 수정
-제약조건 추가
  ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건 설정

- 제약조건 삭제
  ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건이름
  PRIMARY KEY 제거: ALTER TABLE 테이블명 DROP PRIMARY KEY [CASCADE]    --> pk는 한 테이블에 하나이기 때문에 컬럼명 주지 않아도 된다.
	- CASECADE : 제거하는 Primary Key를 Foreign key 가진 다른 테이블의 Foreign key 설정을 모두 삭제한다.

- NOT NULL <-> NULL 변환은 컬럼 수정을 통해 한다.
   - ALTER TABLE 테이블명 MODIFY (컬럼명 NOT NULL),  - ALTER TABLE 테이블명 MODIFY (컬럼명 NULL)  
************************************************************************************ */

-- customer 카피해서 cust
-- select 결과 set 테이블 생성 (not null 제약조건만 copy되고 나머지는 안됨)
create table cust
as
select * from customers;

create tabel cust2
as
select cust_id, cust_name, address from customers;

create table cust3
as
select * from customers
where 1 = 0;    -- false. 값은 안나오고 컬럼만 나옴 (컬럼명만 카피)


-- 컬럼 추가
alter table cust3 add(age number default 0 not null, point number);    -- 제약조건

-- 컬럼 수정
alter table cust3 modify(age number(3));    -- 제약조건 수정
alter table cust3 modify(cust_email null)    -- not null이었던 제약조건 null로 수정

-- 컬럼명 변경
alter table cust3 rename column cust_email to email;

-- 컬럼 삭제 
alter table cust3 drop column age;

desc cust3;    -- 확인용



--TODO: emp 테이블을 카피해서 emp2를 생성(틀만 카피)
create table emp2
as
select * from emp where 1 = 0;


--TODO: gender 컬럼을 추가: type char(1)



--TODO: email 컬럼 추가. type: varchar2(100),  not null  컬럼



--TODO: jumin_num(주민번호) 컬럼을 추가. type: char(14), null 허용. 유일한 값을 가지는 컬럼.



--TODO: emp_id 를 primary key 로 변경


  
--TODO: gender 컬럼의 M, F 저장하도록  제약조건 추가


 
--TODO: salary 컬럼에 0이상의 값들만 들어가도록 제약조건 추가


--TODO: email 컬럼을 null을 가질 수 있되 다른 행과 같은 값을 가지지 못하도록 제약 조건 변경



--TODO: emp_name 의 데이터 타입을 varchar2(100) 으로 변환



--TODO: job_id를 not null 컬럼으로 변경



--TODO: dept_id를 not null 컬럼으로 변경



--TODO: job_id  를 null 허용 컬럼으로 변경



--TODO: dept_id  를 null 허용 컬럼으로 변경



--TODO: 위에서 지정한 emp2_email_uk 제약 조건을 제거



--TODO: 위에서 지정한 emp2_salary_ck 제약 조건을 제거



--TODO: primary key 제약조건 제거



--TODO: gender 컬럼제거



--TODO: email 컬럼 제거



/* **************************************************************************************************************
시퀀스 : SEQUENCE (오라클 문법)
- 자동증가하는 숫자를 제공하는 오라클 객체
- 테이블 컬럼이 자동증가하는 고유번호를 가질때 사용한다. (ex. 게시판 글 번호 ...)
	- 하나의 시퀀스를 여러 테이블이 공유하면 중간이 빈 값들이 들어갈 수 있다.

생성 구문
CREATE SEQUENCE sequence이름
	[INCREMENT BY n]	
	[START WITH n]                		  
	[MAXVALUE n | NOMAXVALUE] -> 증가 (nomax/min)-> 끝까지
	[MINVALUE n | NOMINVALUE] -> 감소
	[CYCLE | NOCYCLE(기본)]		
	[CACHE n | NOCACHE]		  

- INCREMENT BY n: 증가치 설정. 생략시 1
- START WITH n: 시작 값 설정. 생략시 0
	- 시작값 설정시
	 - 증가: MINVALUE 보다 크커나 같은 값이어야 한다.
	 - 감소: MAXVALUE 보다 작거나 같은 값이어야 한다.
- MAXVALUE n: 시퀀스가 생성할 수 있는 최대값을 지정
- NOMAXVALUE : 시퀀스가 생성할 수 있는 최대값을 오름차순의 경우 10^27 의 값. 내림차순의 경우 -1을 자동으로 설정. 
- MINVALUE n :최소 시퀀스 값을 지정
- NOMINVALUE :시퀀스가 생성하는 최소값을 오름차순의 경우 1, 내림차순의 경우 -(10^26)으로 설정
- CYCLE 또는 NOCYCLE : 최대/최소값까지 갔을때 순환할 지 여부. NOCYCLE이 기본값(순환반복하지 않는다.)
- CACHE|NOCACHE : 캐쉬 사용여부 지정.(오라클 서버가 시퀀스가 제공할 값을 미리 조회해 메모리에 저장) NOCACHE가 기본값(CACHE를 사용하지 않는다. )


시퀀스 자동증가값 조회
 - sequence이름.nextval  : 다음 증감치 조회
 - sequence이름.currval  : 현재 시퀀스값 조회


시퀀스 수정
ALTER SEQUENCE 수정할 시퀀스이름
	[INCREMENT BY n]	               		  
	[MAXVALUE n | NOMAXVALUE]   
	[MINVALUE n | NOMINVALUE]	
	[CYCLE | NOCYCLE(기본)]		
	[CACHE n | NOCACHE]	

수정후 생성되는 값들이 영향을 받는다. (그래서 start with 절은 수정대상이 아니다.)	  


시퀀스 제거
DROP SEQUENCE sequence이름
	
************************************************************************************************************** */

-- 1부터 1씩 자동증가하는 시퀀스
create sequence dept_id_seq;    -- 이름 관례: 시퀀스를사용할컬럼명_seq

-- 사용
select dept_id_seq.nextval from dual;    -- 다음값
select dept_id_seq.currval from dual;    -- 현재값

insert into dept value (dept_id_seq.nextval, '새부서', '서울');    -- dept 테이블에 값을 넣는다.


-- 1부터 50까지 10씩 자동증가 하는 시퀀스
create sequence ex1_seq
       increment by 10
       maxvalue 50;    -- 최대값 나온 뒤로는 오류남.

select  ex1_seq.nextval from dual;


-- 100 부터 150까지 10씩 자동증가하는 시퀀스
create sequence ex2_seq
       increment by 10
       start with 100
       maxvalue 150;

select ex2_seq.nextval from dual;


-- 100 부터 150까지 2씩 자동증가하되 최대값에 다다르면 순환하는 시퀀스
-- 순환(cycle) 할 때 증가(increment by 양수): minvalue(기본값: 1)에서 시작
-- 순환(cycle) 할 때 감소(increment by 음수): maxvalue(기본값: -1)에서 시작
create sequence ex3_seq
       increment by 2
       start with 100
       maxvalue 150
       minvalue 100
       cycle;

select ex3_seq.nextval from dual;


-- -1부터 자동 감소하는 시퀀스
create sequence ex4_seq
       increment by -1;

select ex4_seq.nextval from dual;


-- -1부터 -50까지 -10씩 자동 감소하는 시퀀스
create sequence ex5_seq
       increment by -10
       minvalue -50;

select ex5_seq.nextval from dual;


-- 100 부터 -100까지 -100씩 자동 감소하는 시퀀스
create sequence ex6_seq
       increment by -100
       start with 100
       minvalue -100
       maxvalue 100;
       -- maxvalue -1 -> 감소 시 maxvalue는 start with 보다 크거나 같아야 한다. (증가 시 minvalue는 start with 보다는 작거나 같아야 함.)
       
select ex6_seq.nextval from dual;


-- 15에서 -15까지 1씩 감소하는 시퀀스 작성
create sequence ex7_seq
       increment by 1
       start with 15
       minvalue -15
       maxvalue 15;
       
select ex7_seq.nextval from dual;


-- -10 부터 1씩 증가하는 시퀀스 작성
create sequence ex8_seq
       increment by 1
       start with -10
       minvalue -10;
       
select ex8_seq.nextval from dual;


-- Sequence를 이용한 값 insert
insert into 




-- TODO: 부서ID(dept.dept_id)의 값을 자동증가 시키는 sequence를 생성. 10 부터 10씩 증가하는 sequence
-- 위에서 생성한 sequence를 사용해서  dept_copy에 5개의 행을 insert.





-- TODO: 직원ID(emp.emp_id)의 값을 자동증가 시키는 sequence를 생성. 10 부터 1씩 증가하는 sequence
-- 위에서 생성한 sequence를 사용해 emp_copy에 값을 5행 insert






