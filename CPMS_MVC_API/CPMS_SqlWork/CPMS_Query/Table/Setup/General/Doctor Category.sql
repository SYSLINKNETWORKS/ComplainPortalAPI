USE phm
GO

create table m_doccat
(
doccat_sno	int identity(1001,1),
doccat_id	int,
doccat_nam	varchar(250),
doccat_act	bit,
doccat_typ char(1)
)

--Constraint
--Not Null
alter table m_doccat alter column doccat_id int not null

--Primary Key
alter table m_doccat add constraint PK_Mdoccat_doccatID primary key (doccat_id)
