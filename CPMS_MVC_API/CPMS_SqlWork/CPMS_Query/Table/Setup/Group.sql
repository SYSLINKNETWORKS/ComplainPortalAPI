USE phm
GO

create table m_grp
(
	grp_sno int identity(1001,1),
	grp_id int,
	grp_nam varchar(250),
	grp_act bit,
	grp_typ char(1),
	log_act char(1),
	log_dat datetime,
	log_ip varchar(100),
	usr_id int
)

--Not Null
alter table m_grp alter column grp_id int not null

--Primary Key
alter table m_grp add constraint PK_MGRP_GRPID primary key (grp_id)