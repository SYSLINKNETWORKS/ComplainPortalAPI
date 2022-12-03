USE PAGEY
GO

--drop table m_procat

create table m_procat
(
procat_sno int identity(1001,1),
procat_id int,
procat_nam varchar(250),
procat_act bit,
procat_typ char(1)
)

--Constraint 
--Not Null
alter table m_procat alter column procat_id int not null

--Primary Key
alter table m_procat add constraint PK_Mprocat_procatID primary key (procat_id)
