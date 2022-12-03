USE ZSONS
GO
--select * from m_taxclose



create table m_taxclose
(
taxclose_sno	int identity(1001,1),
taxclose_id	int,
taxclose_dat1 datetime,
taxclose_dat2 datetime,
taxclose_act	bit,
taxclose_typ char(1)
)

--Constraint
--Not Null
alter table m_taxclose alter column taxclose_id int not null

--Primary Key
alter table m_taxclose add constraint PK_Mtaxclose_taxcloseID primary key (taxclose_id)
