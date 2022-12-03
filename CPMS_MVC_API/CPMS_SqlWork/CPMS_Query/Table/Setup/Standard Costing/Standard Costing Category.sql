USE MFI
GO

--drop table m_sccat


create table m_sccat
(
sccat_sno int identity(1001,1),
sccat_id int,
sccat_nam char(250),
sccat_typ char(1),
sccat_act bit
)

--Constraint 
--Not Null
alter table m_sccat alter column sccat_id int not null

--Primary Key
alter table m_sccat add constraint PK_Msccat_sccatID primary key (sccat_id)
