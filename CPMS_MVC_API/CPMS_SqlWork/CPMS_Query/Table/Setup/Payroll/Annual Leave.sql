
USE zsons
GO

--drop table m_empanl


create TABLE m_empanl
(
empanl_sno			int  IDENTITY(1001,1)  ,
empanl_id			int   ,
empanl_dat datetime,
empanl_name varchar (100),
empanl_al float,
empanl_sl float,
empanl_cl float,
empanl_ck_al bit,
empanl_ck_sl bit ,
empanl_ck_cl bit ,
empanl_typ char(1)
)
--Constraint
--Not Null
alter table m_empanl alter column empanl_id int not null

--Primary key
alter table m_empanl add constraint PK_MANL_EMPANLID primary key (empanl_id)
