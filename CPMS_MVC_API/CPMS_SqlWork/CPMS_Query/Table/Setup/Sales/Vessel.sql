USE MFI
GO
--drop table m_ves

--Item Brand
create table m_ves
(
ves_sno	int identity(1001,1),
ves_id	int,
ves_nam	varchar(250),
ves_act	bit,
ves_typ char(1)
)

--Constraint
--Not Null
alter table m_ves alter column ves_id int not null

--Primary Key
alter table m_ves add constraint PK_Mves_vesID primary key (ves_id)
