USE MFI
GO
--Item Brand
create table m_supcat
(
supcat_sno	int identity(1001,1),
supcat_id	int,
supcat_nam	varchar(250),
supcat_act	bit,
supcat_typ char(1)
)

--Constraint
--Not Null
alter table m_supcat alter column supcat_id int not null

--Primary Key
alter table m_supcat add constraint PK_Msupcat_supcatID primary key (supcat_id)
