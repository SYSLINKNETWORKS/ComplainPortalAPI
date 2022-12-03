USE MFI
GO
--drop table m_contyp

--Item Brand
create table m_contyp
(
contyp_sno	int identity(1001,1),
contyp_id	int,
contyp_ctyp	varchar(250),
contyp_act	bit,
contyp_typ char(1)
)

--Constraint
--Not Null
alter table m_contyp alter column contyp_id int not null

--Primary Key
alter table m_contyp add constraint PK_Mcontyp_contypID primary key (contyp_id)
