use phm
go
--drop table m_gger

create table m_gger
(
gger_sno int identity(1001,1),
gger_id int,
gger_nam varchar(100),
gger_act bit,
gger_typ char(1),
log_act char(1),
log_dat datetime,
log_ip varchar(100),
usr_id int
)
--select * from m_gergp
--Constraint 
--Not Null
alter table m_gger alter column gger_id int not null

--Primary Key
alter table m_gger add constraint PK_Mgger_ggerID primary key (gger_id)