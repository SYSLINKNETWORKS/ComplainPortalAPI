USE phm
GO

--Manufacture
create table m_man
(
man_sno	int identity(1001,1),
man_id	int,
man_nam	varchar(250),
man_oldid varchar(100),
man_typ char(1),
man_act bit,
log_act char(1),
log_dat datetime,
log_ip varchar(100),
usr_id int
)

--Constraint
--Not Null
alter table m_man alter column man_id int not null

--Primary Key
alter table m_man add constraint PK_Mman_manID primary key (man_id)

