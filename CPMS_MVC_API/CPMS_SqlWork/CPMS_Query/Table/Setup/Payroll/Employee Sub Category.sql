
USE ZSONS
GO


create table m_emp_sub
(
memp_sub_sno int identity(1001,1),
memp_sub_id int,
memp_sub_nam varchar(250),
memp_sub_typ char(1),
memp_sub_salman bit
)

--Constraint
--Not Null
alter table m_emp_sub alter column memp_sub_id int not null

--Primary key
alter table m_emp_sub add constraint PK_Memp_sub_Memp_subID primary key (memp_sub_id)

