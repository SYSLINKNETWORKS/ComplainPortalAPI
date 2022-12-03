USE phm
GO

create table m_seg
(
	seg_sno int identity(1001,1),
	seg_id int,
	seg_nam varchar(100),
	seg_act bit,
	seg_typ char(1),
	log_act char(1),
	log_dat datetime,
	log_ip varchar(100),
	usr_id int
)

--Not Null
alter table m_seg alter column seg_id int not null

--Primary Key
alter table m_seg add constraint PK_MSEG_SEGID primary key (seg_id)