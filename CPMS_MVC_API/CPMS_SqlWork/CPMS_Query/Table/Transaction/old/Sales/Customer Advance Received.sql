
USE ZSONS
GO

--drop table t_dcusadv
--drop table t_cusadv

create table t_cusadv
(
cusadv_sno int identity(1001,1),
cusadv_id int,
cusadv_no int,
cusadv_dat datetime,
cusadv_rat float,
cusadv_amt float,
cusadv_cb char(1),
cusadv_chq int,
cusadv_chqdat datetime,
cusadv_rmk varchar(250),
cus_id int,
cur_id int,
mso_id int,
cusadv_ckso bit,
cusadv_can bit,
mvch_no int,
com_id char(2),
br_id char(3),
m_yr_id char(2),
acc_no int,
ins_usr_id char(2),
ins_dat datetime,
upd_usr_id char(2),
upd_dat datetime
)
--Not Null
alter table t_cusadv alter column cusadv_id int not null
alter table t_cusadv alter column cusadv_no int not null
alter table t_cusadv alter column com_id char(2) not null
alter table t_cusadv alter column br_id char(3) not null
alter table t_cusadv alter column m_yr_id char(2) not null

--Primary key
alter table t_cusadv add constraint PK_cusadvID  primary key (cusadv_id)

--Foreign key
alter table t_cusadv add constraint FK_cusadv_msoID foreign key (mso_id) references t_mso(mso_id)
alter table t_cusadv add constraint FK_cusadv_curID foreign key (cur_id) references m_cur(cur_id)
alter table t_cusadv add constraint FK_cusadv_cusID foreign key (cus_id) references m_cus(cus_id)
alter table t_cusadv add constraint FK_cusadv_COMID foreign key (com_id) references m_com(com_id)
alter table t_cusadv add constraint FK_cusadv_BRID foreign key (br_id) references m_br(br_id)
alter table t_cusadv add constraint FK_cusadv_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)







create table t_dcusadv
(
dcusadv_sno int identity(1001,1),
dcusadv_id int,
dcusadv_amt float,
cusadv_id int,
minv_id int
)
--Not Null
alter table t_dcusadv alter column dcusadv_id int not null

--Primary key
alter table t_dcusadv add constraint PK_dcusadvID primary key (dcusadv_id)

--Foreign key
alter table t_dcusadv add constraint FK_dcusadv_cusadvID foreign key (cusadv_id) references t_cusadv(cusadv_id)
