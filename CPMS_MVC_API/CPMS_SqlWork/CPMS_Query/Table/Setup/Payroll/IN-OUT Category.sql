
USE MFI
GO

create table m_inoutcat
(
inoutcat_sno int identity(1001,1),
inoutcat_id int,
inoutcat_nam varchar(250),
inoutcat_typ char(1)
)

--Constraint
--Not Null
alter table m_inoutcat alter column inoutcat_id int not null

--Primary key
alter table m_inoutcat add constraint PK_inoutcat_inoutcatID primary key (inoutcat_id)

