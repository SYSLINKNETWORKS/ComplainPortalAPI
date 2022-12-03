USE MFI
GO

--drop table m_Mscrm

--Standard Cost Raw Material
create table m_mscrm
(
mscrm_sno int identity(1001,1),
mscrm_id int,
mscrm_dat datetime,
mscrm_rat float,
mscrm_typ char(1),
mscrm_act bit,
titm_id int
)

--Constraint 
--Not Null
alter table m_mscrm alter column mscrm_id int not null

--Primary Key
alter table m_mscrm add constraint PK_mscrm_scrmID primary key (mscrm_id)

--Foreign key
alter table m_mscrm add constraint FK_mscrm_TITMID foreign key (titm_id) references t_itm(titm_id)

