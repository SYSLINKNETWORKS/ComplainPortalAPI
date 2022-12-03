USE MFI
GO
--Item Brand
create table m_cuscat
(
cuscat_sno	int identity(1001,1),
cuscat_id	int,
cuscat_nam	varchar(250),
cuscat_act	bit,
cuscat_typ char(1)
)

--Constraint
--Not Null
alter table m_cuscat alter column cuscat_id int not null

--Primary Key
alter table m_cuscat add constraint PK_Mcuscat_cuscatID primary key (cuscat_id)
