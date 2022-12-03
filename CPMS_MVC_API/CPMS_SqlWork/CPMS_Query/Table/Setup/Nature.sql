USE PAGEY
GO
--drop table m_nat

create table m_nat
(
nat_sno int identity(1001,1),
nat_id int,
nat_nam char(250),
nat_typ char(1)
)

--Constraint 
--Not Null
alter table m_nat alter column nat_id int not null

--Primary Key
alter table m_nat add constraint PK_Mnat_natID primary key (nat_id)
