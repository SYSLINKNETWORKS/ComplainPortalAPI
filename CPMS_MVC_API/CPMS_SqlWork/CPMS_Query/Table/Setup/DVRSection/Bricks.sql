USE phm
GO
--drop table m_brk

create table m_brk
(
brk_sno int identity(1001,1),
brk_id int,
brk_nam varchar(250),
brk_typ char(1),
terr_id int,
log_act char(1),
log_dat datetime,
usr_id int,
log_ip varchar(100)
)

--Constraint 
--Not Null
alter table m_brk alter column brk_id int not null

--Primary Key
alter table m_brk add constraint PK_mbrk_brkID primary key (brk_id)

--Foriegn Key
alter table m_brk add constraint FK_mBRK_TERRID foreign key (terr_id) references m_terr(terr_id)

