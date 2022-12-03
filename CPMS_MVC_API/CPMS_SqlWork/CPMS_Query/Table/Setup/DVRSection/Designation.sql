USE phm
GO

create table m_desig
(
desig_sno	int identity(1001,1),
desig_id	int,
desig_nam	varchar(250),
desig_abb	varchar(250),
descat_typ char(1)
)

--Constraint
--Not Null
alter table m_desig alter column desig_id int not null

--Primary Key
alter table m_desig add constraint PK_Mdesig_desigID primary key (desig_id)
