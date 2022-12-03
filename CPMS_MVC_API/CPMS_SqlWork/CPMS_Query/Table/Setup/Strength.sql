USE phm
GO

--strufacture
create table m_str
(
str_sno	int identity(1001,1),
str_id	int,
str_nam	varchar(250),
str_oldid varchar(100),
str_typ char(1),
str_act bit,
log_act char(1),
log_dat datetime,
log_ip varchar(100),
usr_id int
)

--Constraint
--Not Null
alter table m_str alter column str_id int not null

--Primary Key
alter table m_str add constraint PK_Mstr_strID primary key (str_id)

