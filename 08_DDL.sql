/* ***********************************************************************************
DDL - databass ��ü(ex. table, user ...)�� �����Ѵ�.
      (��ü�� ����, ����, ����)
      - ����: create
      - ����: alter
      - ����: drop

���̺� ����
- ����
create table ���̺� �̸�(
  �÷� ����
)

�������� ���� 
- �÷� ���� ����
    - �÷� ������ ���� ����
- ���̺� ���� ����
    - �÷� �����ڿ� ���� ����

- �⺻ ���� : constraint ���������̸� ��������Ÿ��
- ���̺� ���� ���� ��ȸ
    - USER_CONSTRAINTS ��ųʸ� �信�� ��ȸ
    
���̺� ����
- ����
DROP TABLE ���̺��̸� [CASCADE CONSTRAINTS]

rollback / commit -> DML���� ����. DDL�� �ٷ� �����.
*********************************************************************************** */

create table parent_tb(
        no  number constraint pk_parent_tb primary key,    -- �������ǿ� �̸��� �ش�. (�׳� primary key ��� �ϸ� �������� �̸� ������)
        name nvarchar(30) not null, 
        birthday date default sysdate,    -- �⺻�� ����(���� ��¥��). insert�� ���� ���� ������ �⺻���� ��.
        email varchar2(100) constraint uk_parent_tb_email unique,    -- nuique �������ǿ� �̸��� �ش�. (���ϰ�)
        gender char(1) not null, constraint ck_parent_tb_gender check(gender in ('M', 'F')    -- m�� f�� ���� �ϰڴ�. check key. where�� ����ó�� ��.
);

insert into prent_tb values (1, 'ȫ�浿', '2000/01/01', 'a@a.com', 'M')
insert into prent_tb (no, name, gender) values (2, '�̼���', 'M')    -- ��¥ ������ ���� �ʾƼ� �⺻��(sysdate)�� ��. email�� �⺻�� ���� �� �ؼ� null.
insert into prent_tb values (3, 'ȫ�浿2', null, 'b@a.com', 'M')    -- ��������� null�� ������ default ���� �ƴ϶� null ���� insert �ȴ�. (null�̶�� ���� �ִ� ��)
insert into prent_tb values (4, 'ȫ�浿3', null, 'b@a.com', 'M')    -- email�� unique key�̱� ������ ���� �߻�.
insert into prent_tb values (5, 'ȫ�浿4', null, 'c@a.com', 'm')    -- check key�� �Ҵ����� ���� ���̱� ������ ���� �߻�(gender)


create table child_tb(
        no number,    -- pk
        jumin_num char(14) not null,    -- uk
        age number(3) default 0,    -- 0 ~ 90 ck
        parent_no number    -- parent_tb�� �����ϴ� fk
        constraint pk_child_tb primary key(no),
        constraint uk_child_tb unique key(jumin_num),
        constraint ch_child_tb check(age between 10 and 90),
        constraint fk_child_tb_parent_tb foreign key(parent_no) reference parant_tb(no)      
);



/* ************************************************************************************
ALTER : ���̺� ����

�÷� ���� ����

- �÷� �߰�
  ALTER TABLE ���̺��̸� ADD (�߰��� �÷����� [, �߰��� �÷�����])
  - �ϳ��� �÷��� �߰��� ��� ( ) �� ��������

- �÷� ����
  ALTER TABLE ���̺��̸� MODIFY (�������÷���  ���漳�� [, �������÷���  ���漳��])
	- �ϳ��� �÷��� ������ ��� ( )�� ���� ����
	- ����/���ڿ� �÷��� ũ�⸦ �ø� �� �ִ�. (�ȿ� ����ִ� ���� �ֱ� ����)
		- ũ�⸦ ���� �� �ִ� ��� : ���� ���� ���ų� ��� ���� ���̷��� ũ�⺸�� ���� ���
	- �����Ͱ� ��� NULL�̸� ������Ÿ���� ������ �� �ִ�. (�� CHAR<->VARCHAR2 �� ����.)

- �÷� ����	
  ALTER TABLE ���̺��̸� DROP COLUMN �÷��̸� [CASCADE CONSTRAINTS]
    - CASCADE CONSTRAINTS : �����ϴ� �÷��� Primary Key�� ��� �� �÷��� �����ϴ� �ٸ� ���̺��� Foreign key ������ ��� �����Ѵ�.
	- �ѹ��� �ϳ��� �÷��� ���� ����.
	
  ALTER TABLE ���̺��̸� SET UNUSED (�÷��� [, ..])
  ALTER TABLE ���̺��̸� DROP UNUSED COLUMNS
	- SET UNUSED ������ �÷��� �ٷ� �������� �ʰ� ���� ǥ�ø� �Ѵ�. 
	- ������ �÷��� ����� �� ������ ���� ��ũ���� ����� �ִ�. �׷��� �ӵ��� ������.
	- DROP UNUSED COLUMNS �� SET UNUSED�� �÷��� ��ũ���� �����Ѵ�. 

- �÷� �̸� �ٲٱ�
  ALTER TABLE ���̺��̸� RENAME COLUMN �����̸� TO �ٲ��̸�;

**************************************************************************************  
���� ���� ���� ����
-�������� �߰�
  ALTER TABLE ���̺�� ADD CONSTRAINT �������� ����

- �������� ����
  ALTER TABLE ���̺�� DROP CONSTRAINT ���������̸�
  PRIMARY KEY ����: ALTER TABLE ���̺�� DROP PRIMARY KEY [CASCADE]    --> pk�� �� ���̺� �ϳ��̱� ������ �÷��� ���� �ʾƵ� �ȴ�.
	- CASECADE : �����ϴ� Primary Key�� Foreign key ���� �ٸ� ���̺��� Foreign key ������ ��� �����Ѵ�.

- NOT NULL <-> NULL ��ȯ�� �÷� ������ ���� �Ѵ�.
   - ALTER TABLE ���̺�� MODIFY (�÷��� NOT NULL),  - ALTER TABLE ���̺�� MODIFY (�÷��� NULL)  
************************************************************************************ */

-- customer ī���ؼ� cust
-- select ��� set ���̺� ���� (not null �������Ǹ� copy�ǰ� �������� �ȵ�)
create table cust
as
select * from customers;

create tabel cust2
as
select cust_id, cust_name, address from customers;

create table cust3
as
select * from customers
where 1 = 0;    -- false. ���� �ȳ����� �÷��� ���� (�÷��� ī��)


-- �÷� �߰�
alter table cust3 add(age number default 0 not null, point number);    -- ��������

-- �÷� ����
alter table cust3 modify(age number(3));    -- �������� ����
alter table cust3 modify(cust_email null)    -- not null�̾��� �������� null�� ����

-- �÷��� ����
alter table cust3 rename column cust_email to email;

-- �÷� ���� 
alter table cust3 drop column age;

desc cust3;    -- Ȯ�ο�



--TODO: emp ���̺��� ī���ؼ� emp2�� ����(Ʋ�� ī��)
create table emp2
as
select * from emp where 1 = 0;


--TODO: gender �÷��� �߰�: type char(1)



--TODO: email �÷� �߰�. type: varchar2(100),  not null  �÷�



--TODO: jumin_num(�ֹι�ȣ) �÷��� �߰�. type: char(14), null ���. ������ ���� ������ �÷�.



--TODO: emp_id �� primary key �� ����


  
--TODO: gender �÷��� M, F �����ϵ���  �������� �߰�


 
--TODO: salary �÷��� 0�̻��� ���鸸 ������ �������� �߰�


--TODO: email �÷��� null�� ���� �� �ֵ� �ٸ� ��� ���� ���� ������ ���ϵ��� ���� ���� ����



--TODO: emp_name �� ������ Ÿ���� varchar2(100) ���� ��ȯ



--TODO: job_id�� not null �÷����� ����



--TODO: dept_id�� not null �÷����� ����



--TODO: job_id  �� null ��� �÷����� ����



--TODO: dept_id  �� null ��� �÷����� ����



--TODO: ������ ������ emp2_email_uk ���� ������ ����



--TODO: ������ ������ emp2_salary_ck ���� ������ ����



--TODO: primary key �������� ����



--TODO: gender �÷�����



--TODO: email �÷� ����



/* **************************************************************************************************************
������ : SEQUENCE (����Ŭ ����)
- �ڵ������ϴ� ���ڸ� �����ϴ� ����Ŭ ��ü
- ���̺� �÷��� �ڵ������ϴ� ������ȣ�� ������ ����Ѵ�. (ex. �Խ��� �� ��ȣ ...)
	- �ϳ��� �������� ���� ���̺��� �����ϸ� �߰��� �� ������ �� �� �ִ�.

���� ����
CREATE SEQUENCE sequence�̸�
	[INCREMENT BY n]	
	[START WITH n]                		  
	[MAXVALUE n | NOMAXVALUE] -> ���� (nomax/min)-> ������
	[MINVALUE n | NOMINVALUE] -> ����
	[CYCLE | NOCYCLE(�⺻)]		
	[CACHE n | NOCACHE]		  

- INCREMENT BY n: ����ġ ����. ������ 1
- START WITH n: ���� �� ����. ������ 0
	- ���۰� ������
	 - ����: MINVALUE ���� ũĿ�� ���� ���̾�� �Ѵ�.
	 - ����: MAXVALUE ���� �۰ų� ���� ���̾�� �Ѵ�.
- MAXVALUE n: �������� ������ �� �ִ� �ִ밪�� ����
- NOMAXVALUE : �������� ������ �� �ִ� �ִ밪�� ���������� ��� 10^27 �� ��. ���������� ��� -1�� �ڵ����� ����. 
- MINVALUE n :�ּ� ������ ���� ����
- NOMINVALUE :�������� �����ϴ� �ּҰ��� ���������� ��� 1, ���������� ��� -(10^26)���� ����
- CYCLE �Ǵ� NOCYCLE : �ִ�/�ּҰ����� ������ ��ȯ�� �� ����. NOCYCLE�� �⺻��(��ȯ�ݺ����� �ʴ´�.)
- CACHE|NOCACHE : ĳ�� ��뿩�� ����.(����Ŭ ������ �������� ������ ���� �̸� ��ȸ�� �޸𸮿� ����) NOCACHE�� �⺻��(CACHE�� ������� �ʴ´�. )


������ �ڵ������� ��ȸ
 - sequence�̸�.nextval  : ���� ����ġ ��ȸ
 - sequence�̸�.currval  : ���� �������� ��ȸ


������ ����
ALTER SEQUENCE ������ �������̸�
	[INCREMENT BY n]	               		  
	[MAXVALUE n | NOMAXVALUE]   
	[MINVALUE n | NOMINVALUE]	
	[CYCLE | NOCYCLE(�⺻)]		
	[CACHE n | NOCACHE]	

������ �����Ǵ� ������ ������ �޴´�. (�׷��� start with ���� ��������� �ƴϴ�.)	  


������ ����
DROP SEQUENCE sequence�̸�
	
************************************************************************************************************** */

-- 1���� 1�� �ڵ������ϴ� ������
create sequence dept_id_seq;    -- �̸� ����: ��������������÷���_seq

-- ���
select dept_id_seq.nextval from dual;    -- ������
select dept_id_seq.currval from dual;    -- ���簪

insert into dept value (dept_id_seq.nextval, '���μ�', '����');    -- dept ���̺� ���� �ִ´�.


-- 1���� 50���� 10�� �ڵ����� �ϴ� ������
create sequence ex1_seq
       increment by 10
       maxvalue 50;    -- �ִ밪 ���� �ڷδ� ������.

select  ex1_seq.nextval from dual;


-- 100 ���� 150���� 10�� �ڵ������ϴ� ������
create sequence ex2_seq
       increment by 10
       start with 100
       maxvalue 150;

select ex2_seq.nextval from dual;


-- 100 ���� 150���� 2�� �ڵ������ϵ� �ִ밪�� �ٴٸ��� ��ȯ�ϴ� ������
-- ��ȯ(cycle) �� �� ����(increment by ���): minvalue(�⺻��: 1)���� ����
-- ��ȯ(cycle) �� �� ����(increment by ����): maxvalue(�⺻��: -1)���� ����
create sequence ex3_seq
       increment by 2
       start with 100
       maxvalue 150
       minvalue 100
       cycle;

select ex3_seq.nextval from dual;


-- -1���� �ڵ� �����ϴ� ������
create sequence ex4_seq
       increment by -1;

select ex4_seq.nextval from dual;


-- -1���� -50���� -10�� �ڵ� �����ϴ� ������
create sequence ex5_seq
       increment by -10
       minvalue -50;

select ex5_seq.nextval from dual;


-- 100 ���� -100���� -100�� �ڵ� �����ϴ� ������
create sequence ex6_seq
       increment by -100
       start with 100
       minvalue -100
       maxvalue 100;
       -- maxvalue -1 -> ���� �� maxvalue�� start with ���� ũ�ų� ���ƾ� �Ѵ�. (���� �� minvalue�� start with ���ٴ� �۰ų� ���ƾ� ��.)
       
select ex6_seq.nextval from dual;


-- 15���� -15���� 1�� �����ϴ� ������ �ۼ�
create sequence ex7_seq
       increment by 1
       start with 15
       minvalue -15
       maxvalue 15;
       
select ex7_seq.nextval from dual;


-- -10 ���� 1�� �����ϴ� ������ �ۼ�
create sequence ex8_seq
       increment by 1
       start with -10
       minvalue -10;
       
select ex8_seq.nextval from dual;


-- Sequence�� �̿��� �� insert
insert into 




-- TODO: �μ�ID(dept.dept_id)�� ���� �ڵ����� ��Ű�� sequence�� ����. 10 ���� 10�� �����ϴ� sequence
-- ������ ������ sequence�� ����ؼ�  dept_copy�� 5���� ���� insert.





-- TODO: ����ID(emp.emp_id)�� ���� �ڵ����� ��Ű�� sequence�� ����. 10 ���� 1�� �����ϴ� sequence
-- ������ ������ sequence�� ����� emp_copy�� ���� 5�� insert






