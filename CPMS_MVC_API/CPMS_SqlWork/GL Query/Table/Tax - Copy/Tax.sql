USE ZSONS
GO


create table m_tax
(
tax_sno	int identity(1001,1),
tax_id	int,
tax_nam	varchar(250),
tax_snm	varchar(10),
tax_act	bit,
tax_typ char(1)
)

--Constraint
--Not Null
alter table m_tax alter column tax_id int not null

--Primary Key
alter table m_tax add constraint PK_Mtax_taxID primary key (tax_id)
