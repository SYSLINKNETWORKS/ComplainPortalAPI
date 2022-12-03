--drop table t_dqc
--drop table t_mqc
--alter table t_mqc add mqc_rat float,mqc_amt float,mqc_tamt as [mqc_rat* mqc_amt],cur_id int
--alter table t_dqc add dqc_rat float,dqc_trat float,dqc_amt float,dqc_tamt float
--update t_dqc set dqc_rat=0,dqc_trat=0,dqc_amt=0,dqc_tamt=0

Create table t_mqc
(
mqc_sno int identity(1001,1),
mqc_id	int,
mqc_dat datetime,
mqc_typ char(1),
mqc_act int default 0,
sup_dc varchar(100),
mqc_rmk varchar(250),
mqc_rat float,
mqc_amt float,
mqc_tamt as mqc_rat*mqc_amt,
mqc_nw float,
cur_id int,
mgrn_id int,
wh_id int,
sca_id int,
m_yr_id char(2)
)



--Constraint
--Not null
alter table t_mqc alter column mqc_id int not null
alter table t_mqc alter column m_yr_id char(2) not null

--Primary
alter table t_mqc add constraint PK_Mqc_qcID primary key (mqc_id)
--Foreign Key
alter table t_mqc add constraint FK_Mqc_MGRNID foreign key (mgrn_id) references t_mgrn(mgrn_id)
alter table t_mqc add constraint FK_Mqc_curID foreign key (cur_id) references m_cur(cur_id)
alter table t_mqc add constraint FK_Mqc_scaID foreign key (sca_id) references m_sca(sca_id)


create table t_dqc
(
dqc_sno int identity (1001,1),
dqc_id int,
dqc_man datetime,
dqc_exp datetime,
dqc_qty float,
dqc_rat float,
dqc_trat float,
dqc_amt float,
dqc_tamt float,
dqc_st int default 0,
dqc_rmk varchar(1000),
dqc_typ char(1),
mqc_id int,
titm_id int,
m_yr_id char(2)
)




--Constraint
--Not null
alter table t_dqc alter column dqc_id int not null
alter table t_dqc alter column m_yr_id char(2) not null

--Primary
alter table t_dqc add constraint PK_TDqc_DqcID primary key (dqc_id)

--Foreign Key
alter table t_dqc add constraint FK_Dqc_MqcID foreign key (mqc_id) references t_mqc (mqc_id)
alter table t_dqc add constraint FK_Dqc_TITMID foreign key (titm_id) references t_itm (titm_id)
alter table t_dqc add constraint FK_Dqc_YRID foreign key (m_yr_id) references gl_m_yr (yr_id)
