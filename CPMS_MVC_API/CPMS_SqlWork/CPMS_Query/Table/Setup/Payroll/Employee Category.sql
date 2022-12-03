USE MFI
GO


create table m_empcat
(
mempcat_sno int identity(1001,1),
mempcat_id int,
mempcat_nam varchar(250),
mempcat_snam varchar(100),
mempcat_typ char(1)
)



--Constraint
--Not Null
alter table m_empcat alter column mempcat_id int not null

--Primary key
alter table m_empcat add constraint PK_Mempcat_MempcatID primary key (mempcat_id)

