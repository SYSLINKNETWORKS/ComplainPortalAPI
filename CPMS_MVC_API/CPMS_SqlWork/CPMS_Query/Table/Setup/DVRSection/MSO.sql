USE phm
GO

create table m_mso
(
mso_sno	int identity(1001,1),
mso_id	int,
mso_nam	varchar(250),
mso_act	bit,
mso_typ char(1),
rm_id int,
sm_id int,
nsm_id int,
mm_id int,
log_act char(1),
log_dat datetime,
log_ip varchar(100),
usr_id int
)

--Constraint
--Not Null
alter table m_mso alter column mso_id int not null

--Primary Key
alter table m_mso add constraint PK_Mmso_msoID primary key (mso_id)
