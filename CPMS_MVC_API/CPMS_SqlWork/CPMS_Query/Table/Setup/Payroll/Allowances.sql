USE MFI
GO
--Allowance of Salary
create table m_all 
(
all_sno int identity(1001,1),
all_id int,
all_nam varchar(100),
all_amt float,
all_fix bit,
all_typ char(1)
)


--Not Null
alter table m_all alter column all_id int not null

--Primary Key
alter table m_all add constraint PK_MALL_ALLID primary key (all_id)
