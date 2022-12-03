USE ZSONS
GO

--drop table m_anl
create table m_anl
(
manl_sno int identity(1001,1),
manl_id int,
manl_dat datetime,
emppro_macid int,
manl_app bit,
manl_typ char(1)
)

--Constraint
--Not Null
alter table m_anl alter column manl_id int not null

--Primary key
alter table m_anl add constraint PK_Manl_ManlID primary key (manl_id)
