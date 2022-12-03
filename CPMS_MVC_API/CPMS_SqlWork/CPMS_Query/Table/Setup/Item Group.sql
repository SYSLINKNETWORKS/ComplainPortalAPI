USE phm
GO

--itmgp
create table m_itmgp
(
itmgp_sno	int identity(1001,1),
itmgp_id	int,
itmgp_nam	varchar(250),
itmgp_typ char(1),
itmgp_act bit,
log_act char(1),
log_dat datetime,
log_ip varchar(100),
usr_id int
)

--Constraint
--Not Null
alter table m_itmgp alter column itmgp_id int not null

--Primary Key
alter table m_itmgp add constraint PK_Mitmgp_itmgpID primary key (itmgp_id)

