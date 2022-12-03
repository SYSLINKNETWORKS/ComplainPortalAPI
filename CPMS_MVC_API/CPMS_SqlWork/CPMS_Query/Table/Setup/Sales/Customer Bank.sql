USE ZSONS
GO
--Customer Category
create table m_cusbk
(
cusbk_sno	int identity(1001,1),
cusbk_id	int,
cusbk_nam	varchar(250),
cusbk_snm	char(10),
cusbk_act	bit,
cusbk_typ char(1)
)

--Constraint
--Not Null
alter table m_cusbk alter column cusbk_id int not null

--Primary Key
alter table m_cusbk add constraint PK_Mcusbk_cusbkID primary key (cusbk_id)
