USE PAGEY
GO


create table m_exp
(
exp_sno int identity(1001,1),
exp_id int,
exp_nam varchar(100),
exp_typ char(1)
)

--Constraint
--Not Null
alter table m_exp alter column exp_id int not null

--Primary key 
alter table m_exp add constraint PK_Mexp_expID primary key (exp_id)


