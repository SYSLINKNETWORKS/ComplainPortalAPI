use phm
go

create table m_ger
(
ger_sno int identity(1001,1),
ger_id int,
ger_nam varchar(100),
ger_act bit,
ger_typ char(1),
log_act char(1),
log_dat datetime,
log_ip varchar(100),
usr_id int
)
--select * from m_ger
--Constraint 
--Not Null
alter table m_ger alter column ger_id int not null

--Primary Key
alter table m_ger add constraint PK_Mger_gerID primary key (ger_id)