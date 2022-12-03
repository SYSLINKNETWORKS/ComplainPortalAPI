USE ZSons
GO

--drop table t_drec
--drop table t_mrec
--alter table t_mrec add mrec_chqdat datetime
--update t_mrec set mrec_can=0

--Master table of plier recment
create table t_mrec
(
mrec_sno int identity(1001,1),
mrec_id int,
mrec_no int,
mrec_dat datetime,
mrec_amt float,
mrec_epl float,
mrec_cb char(1),
mrec_chq int,
mrec_chqdat datetime,
mrec_rmk varchar(250),
mrec_rat float,
mrec_can bit,
cus_id int,
cur_id int,
com_id char(2),
br_id char(3),
m_yr_id char(2),
mvch_no int,
mvch_no_epl int,
acc_no int
)
--Not Null
alter table t_mrec alter column mrec_id int not null
alter table t_mrec alter column mrec_no int not null
alter table t_mrec alter column com_id char(2) not null
alter table t_mrec alter column br_id char(3) not null
alter table t_mrec alter column m_yr_id char(2) not null

--Primary key
alter table t_mrec add constraint PK_MrecID  primary key (mrec_id)

--Foreign key
alter table t_mrec add constraint FK_Mrec_cusID foreign key (cus_id) references m_cus(cus_id)
alter table t_mrec add constraint FK_Mrec_COMID foreign key (com_id) references m_com(com_id)
alter table t_mrec add constraint FK_Mrec_BRID foreign key (br_id) references m_br(br_id)
alter table t_mrec add constraint FK_Mrec_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)


GO
--Detail table of plier recment
create table t_drec
(
drec_id int,
drec_amt float,
drec_epl float,
minv_id int,
mrec_id int
)
--Not Null
alter table t_drec alter column drec_id int not null

--Primary key
alter table t_drec add constraint PK_DrecID primary key (drec_id)

--Foreign key
alter table t_drec add constraint FK_TMinv_MinvID foreign key (minv_id) references t_minv(minv_id)
alter table t_drec add constraint FK_Mrec_MrecID foreign key (mrec_id) references t_mrec(mrec_id)





