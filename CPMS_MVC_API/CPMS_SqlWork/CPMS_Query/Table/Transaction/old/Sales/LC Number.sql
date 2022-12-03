
USE PAGEY
GO
--drop table m_lc

create table m_lc
(
lc_sno int identity (1001,1),
lc_id int,
lc_nam varchar(250),
lc_typ char(1)
)



--Constraint
--Not null
alter table m_lc alter column lc_id int not null
--Primary
alter table m_lc add constraint PK_lc_lcID primary key (lc_id)

--Unique
alter table m_lc add constraint uq_lcnam UNIQUE(lc_nam);