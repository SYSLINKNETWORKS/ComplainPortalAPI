USE PHM
GO
--Item Brand
create table m_prcat
(
prcat_sno	int identity(1001,1),
prcat_id	int,
prcat_nam	varchar(250),
prcat_act	bit,
prcat_typ char(1)
)

--Constraint
--Not Null
alter table m_prcat alter column prcat_id int not null

--Primary Key
alter table m_prcat add constraint PK_Mprcat_prcatID primary key (prcat_id)
