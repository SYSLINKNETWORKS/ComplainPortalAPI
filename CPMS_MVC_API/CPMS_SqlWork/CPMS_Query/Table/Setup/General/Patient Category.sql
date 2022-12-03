USE phm
GO

create table m_patcat
(
patcat_sno	int identity(1001,1),
patcat_id	int,
patcat_nam	varchar(250),
patcat_act	bit,
patcat_typ char(1),
log_act char(1),
log_dat datetime,
log_ip varchar(100),
usr_id int
)

--Constraint
--Not Null
alter table m_patcat alter column patcat_id int not null

--Primary Key
alter table m_patcat add constraint PK_Mpatcat_patcatID primary key (patcat_id)
