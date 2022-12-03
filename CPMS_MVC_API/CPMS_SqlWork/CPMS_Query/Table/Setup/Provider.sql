USE PAGEY
GO
--drop table m_prd

create table m_prd
(
prd_sno int identity(1001,1),
prd_id int,
prd_nam varchar(250),
prd_web varchar(250),
prd_typ char(1)
)

--Constraint 
--Not Null
alter table m_prd alter column prd_id int not null

--Primary Key
alter table m_prd add constraint PK_Mprd_prdID primary key (prd_id)
