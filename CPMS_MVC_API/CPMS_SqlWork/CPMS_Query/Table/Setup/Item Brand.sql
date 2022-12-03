
--Item Brand
create table m_bd
(
bd_sno	int identity(1001,1),
bd_id	int,
bd_nam	varchar(250),
bd_act	bit,
bd_genact bit,
bd_typ char(1)
)

--Constraint
--Not Null
alter table m_bd alter column bd_id int not null

--Primary Key
alter table m_bd add constraint PK_Mbd_bdID primary key (bd_id)
