USE phm
GO

create table m_hos
(
hos_sno	int identity(1001,1),
hos_id	int,
hos_nam	varchar(250),
hos_act	bit,
hos_typ char(1),
log_act char(1),
log_dat datetime,
log_ip varchar(100),
usr_id int
)

--Constraint
--Not Null
alter table m_hos alter column hos_id int not null

--Primary Key
alter table m_hos add constraint PK_Mhos_hosID primary key (hos_id)
