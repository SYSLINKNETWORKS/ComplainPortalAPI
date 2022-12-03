USE MFI
GO
--drop table m_consiz

--Item Brand
create table m_consiz
(
consiz_sno	int identity(1001,1),
consiz_id int,
consiz_siz	varchar(100),
consiz_gwei float,
consiz_nwei float,
consiz_act	bit,
consiz_typ char(1)
)

--consizstraint
--Not Null
alter table m_consiz alter column consiz_id int not null

--Primary Key
alter table m_consiz add constraint PK_Mconsiz_consizID primary key (consiz_id)