USE [ZSons]

GO

--Drop table m_cs

CREATE TABLE m_cs
(
cs_sno int identity(1001,1),
cs_id int,
cs_nam varchar(250),
cs_typ char(1),
cs_act bit
)

--Constraint 
--Not Null
alter table m_cs alter column cs_id int not null

--Primary Key
alter table m_cs add constraint PK_cs_csID primary key (cs_id)


