USE epharm
GO

--drop table m_destrans
create table m_destrans
(
destrans_sno	int identity(1001,1),
destrans_id	int,
destrans_typ char(1),
destrans_dat datetime,
emppro_id int,
memp_sub_id int,
newdes_id int,
log_act char(1),
log_dat datetime,
log_ip varchar(100),
usr_id int
)

--Constraint
--Not Null
alter table m_destrans alter column destrans_id int not null

--Primary Key
alter table m_destrans add constraint PK_Mdestrans_destransID primary key (destrans_id)

--Foriegn Key
alter table m_destrans add constraint FK_Mdestrans_empproid foreign key (emppro_id) references m_emppro(emppro_id)
alter table m_destrans add constraint FK_Mdestrans_mempsubid foreign key (memp_sub_id) references m_emp_sub(memp_sub_id)
alter table m_destrans add constraint FK_Mdestrans_newdesid foreign key (newdes_id) references m_emp_sub(memp_sub_id)


