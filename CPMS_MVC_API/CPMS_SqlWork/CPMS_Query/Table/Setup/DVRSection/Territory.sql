USE phm
GO



create table m_terr
(
terr_sno int identity(1001,1),
terr_id int,
terr_nam varchar(250),
terr_typ char(1),
reg_id int,
log_act char(1),
log_dat datetime,
usr_id int,
log_ip varchar(100)
)

--Constraint 
--Not Null
alter table m_terr alter column terr_id int not null

--Primary Key
alter table m_terr add constraint PK_mterr_terrID primary key (terr_id)

--Foriegn Key
alter table m_terr add constraint FK_MTERR_REGID foreign key (reg_id) references m_reg(reg_id)
