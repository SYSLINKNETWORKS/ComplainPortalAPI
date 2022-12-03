USE MFI
GO

--drop table m_abs
create table m_abs
(
mabs_sno int identity(1001,1),
mabs_id int,
mabs_dat datetime,
emppro_macid int,
mabs_app bit,
mabs_typ char(1)
)

--Constraint
--Not Null
alter table m_abs alter column mabs_id int not null

--Primary key
alter table m_abs add constraint PK_Mabs_MabsID primary key (mabs_id)

