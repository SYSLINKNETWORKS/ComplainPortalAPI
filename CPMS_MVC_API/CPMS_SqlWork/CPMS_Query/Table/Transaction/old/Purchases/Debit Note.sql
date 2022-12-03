--drop table t_ddn
--drop table t_mdn


Create table t_mdn
(
mdn_sno int identity(1001,1),
mdn_id	int,
mdn_dat datetime,
mdn_typ char(1),
mdn_st int default 0,
mdn_rmk varchar(250),
mdn_rat float,
mdn_amt float,
mdn_tamt as mdn_amt*mdn_rat,
mpb_id int,
wh_id int,
m_yr_id char(2),
cur_id int,
mvch_id char(12)
)

--Constraint
--Not null
alter table t_mdn alter column mdn_id int not null
alter table t_mdn alter column m_yr_id char(2) not null

--Primary
alter table t_mdn add constraint PK_mdn_pbID primary key (mdn_id)

--Foreign Key
alter table t_mdn add constraint FK_mdn_pbID foreign key (mpb_id) references t_mpb (mpb_id)
alter table t_mdn add constraint FK_mdn_curID foreign key (cur_id) references m_cur (cur_id)
alter table t_mdn add constraint FK_mdn_whID foreign key (wh_id) references m_wh (wh_id)








create table t_ddn
(
ddn_sno int identity (1001,1),
ddn_id int,
ddn_qty float,
ddn_acc float,
ddn_nqty float,
ddn_rat float,
ddn_trat float,
ddn_amt float,
ddn_tamt float,
mdn_id int,
titm_id int,
ddn_exp datetime,
m_yr_id char(2)
)

--Constraint
--Not null
alter table t_ddn alter column ddn_id int not null
alter table t_ddn alter column m_yr_id char(2) not null

--Primary
alter table t_ddn add constraint PK_Tddn_ddnID primary key (ddn_id)

--Foreign Key
alter table t_ddn add constraint FK_ddn_mdnID foreign key (mdn_id) references t_mdn (mdn_id)
alter table t_ddn add constraint FK_ddn_TITMID foreign key (titm_id) references t_itm (titm_id)
alter table t_ddn add constraint FK_ddn_YRID foreign key (m_yr_id) references gl_m_yr (yr_id)
	


--select * from bat_det
