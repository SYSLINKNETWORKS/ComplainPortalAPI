USE ZSons
GO
--drop table m_stdcatmas

create table m_stdcatmas
(
stdcatmas_sno int identity(1001,1),
stdcatmas_id int,
stdcatmas_nam char(25),
stdcatmas_act bit,
stdcatmas_typ char(1)
)

--Constraint 
--Not Null
alter table m_stdcatmas alter column stdcatmas_id int not null

--Primary Key
alter table m_stdcatmas add constraint PK_Mstdcatmas_stdcatmasID primary key (stdcatmas_id)
