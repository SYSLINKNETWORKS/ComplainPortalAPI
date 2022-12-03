USE ZSONS
GO
--drop table m_taxrat
--drop table m_dtaxrat

create table m_taxrat
(
taxrat_sno	int identity(1001,1),
taxrat_id	int,
taxrat_dat datetime,
taxrat_typ char(1),
taxrat_nam char(1)
)

--Constraint
--Not Null
alter table m_taxrat alter column taxrat_id int not null

--Primary Key
alter table m_taxrat add constraint PK_Mtaxrat_taxratID primary key (taxrat_id)


go
create table m_dtaxrat
(
dtaxrat_sno	int identity(1001,1),
dtaxrat_id	int,
dtaxrat_per float,
taxrat_id int
)

--Constraint
--Not Null
alter table m_dtaxrat alter column dtaxrat_id int not null

--Primary Key
alter table m_dtaxrat add constraint PK_dtaxrat_dtaxratID primary key (dtaxrat_id)

--Forign key
alter table m_dtaxrat add constraint FK_MTAXRAT_TAXRAT foreign key (taxrat_id) references m_taxrat(taxrat_id)
