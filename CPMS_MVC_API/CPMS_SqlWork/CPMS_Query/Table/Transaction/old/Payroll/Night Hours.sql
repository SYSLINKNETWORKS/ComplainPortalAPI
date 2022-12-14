USE MFI
GO

--drop table m_nithrs
create table m_nithrs
(
nithrs_sno int identity(1001,1),
nithrs_id int,
nithrs_dat datetime,
emppro_id int,
nithrs_hrs float,
nithrs_app bit default 0,
nithrs_typ char(1)
)

--Constraint
--Not Null
alter table m_nithrs alter column nithrs_id int not null

--Primary key
alter table m_nithrs add constraint PK_Mnithrs_MnitHRSID primary key (nithrs_id)

--Foreign key
alter table m_nithrs add constraint FK_Mnithrs_emppro_id foreign key (emppro_id) references m_emppro(emppro_id)
