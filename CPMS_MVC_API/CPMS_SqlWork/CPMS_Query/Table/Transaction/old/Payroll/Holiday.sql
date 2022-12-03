USE MFI
GO


--drop table m_holi
create table m_holi
(
mholi_sno int identity(1001,1),
mholi_id int,
mholi_dat datetime,
mholi_dayact bit,
mholi_fovertime bit,
mholi_rmks varchar(1000),
mholi_typ char(1)
)

--Constraint
--Not Null
alter table m_holi alter column mholi_id int not null

--Primary key
alter table m_holi add constraint PK_MHOLI_MHOLIID primary key (mholi_id)

