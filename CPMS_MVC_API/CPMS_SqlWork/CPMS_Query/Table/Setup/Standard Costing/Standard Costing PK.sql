USE MFI
GO

--drop table m_mscpk

--Standard Cost Raw Material
create table m_mscpk
(
mscpk_sno int identity(1001,1),
mscpk_id int,
mscpk_dat datetime,
mscpk_rat float,
mscpk_typ char(1),
mscpk_act bit,
titm_id int
)

--Constraint 
--Not Null
alter table m_mscpk alter column mscpk_id int not null

--Primary Key
alter table m_mscpk add constraint PK_mscpk_scrmID primary key (mscpk_id)

--Foreign key
alter table m_mscpk add constraint FK_mscpk_TITMID foreign key (titm_id) references t_itm(titm_id)

