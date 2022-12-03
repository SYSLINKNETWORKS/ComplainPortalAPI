USE NATHI
GO

--drop table t_dcn
--drop table t_mcn

Create table t_mcn	
(
mcn_sno int identity(1001,1),
mcn_id	int,
mcn_no int,
mcn_dat datetime,
mcn_rmk varchar(250),
mcn_qty float,
mcn_amt float,
mcn_disamt float,
mcn_gamt float,
mcn_freamt float,
mcn_namt float,
mcn_typ char(1),
mcn_act bit default 0,
mcn_can bit,
cus_id int,
wh_id int,
com_id char(2),
br_id char(3),
m_yr_id char(2),
minv_id int,
cur_id int,
mcn_currat float,
mvch_no int
)



--Constraint
--Not null
alter table t_mcn alter column mcn_id int not null
alter table t_mcn alter column mcn_no int not null
alter table t_mcn alter column com_id char(2) not null
alter table t_mcn alter column br_id char(3) not null
alter table t_mcn alter column m_yr_id char(2) not null

--primary key
alter table t_mcn add constraint PK_Mcn_McnID primary key (mcn_id)

--Foreign key
alter table t_mcn add constraint FK_MCN_MINVID foreign key (minv_id) references t_minv(minv_id)
alter table t_mcn add constraint FK_MCN_CUSID foreign key (cus_id) references m_cus(cus_id)
alter table t_mcn add constraint FK_MCN_COMID foreign key (com_id) references m_com(com_id)
alter table t_mcn add constraint FK_MCN_BRID foreign key (br_id) references m_br(br_id)
alter table t_mcn add constraint FK_MCN_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)
alter table t_mcn add constraint FK_MCN_CURID foreign key (cur_id) references m_cur(cur_id)
alter table t_mcn add constraint FK_MCN_whID foreign key (wh_id) references m_wh(wh_id)


go

create table t_dcn
(
dcn_sno int identity (1001,1),
dcn_id int,
dcn_qty float,
dcn_rat float,
dcn_amt float,
dcn_disper float,
dcn_disamt float,
dcn_namt float,
titm_id int,
itmqty_id int,
mcn_id int
)




--Constraint

--Not null
alter table t_dcn alter column dcn_id int not null

--Primary key
alter table t_dcn add constraint PK_dcn_id primary key (dcn_id)

--Foreign Key
alter table t_dcn add constraint FK_dcn_mcn foreign key (mcn_id) references t_mcn (mcn_id)
alter table t_dcn add constraint FK_dcn_TITMID foreign key (titm_id) references t_itm (titm_id)
alter table t_dcn add constraint FK_dcn_itmqtyID foreign key (itmqty_id) references m_itmqty (itmqty_id)
	
