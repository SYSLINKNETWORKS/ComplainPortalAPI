USE ZSONS
GO
--drop table m_taxrat

create table m_taxrat
(
taxrat_sno	int identity(1001,1),
taxrat_id	int,
taxrat_dat datetime,
taxrat_typ char(1),
taxrat_per float,
tax_id int
)

--Constraint
--Not Null
alter table m_taxrat alter column taxrat_id int not null

--Primary Key
alter table m_taxrat add constraint PK_Mtaxrat_taxratID primary key (taxrat_id)


--foreign Key
alter table m_taxrat add constraint FK_taxrat_taxID foreign key (tax_id) references m_tax (tax_id)
