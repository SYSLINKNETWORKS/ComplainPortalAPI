--drop table t_supadv
create table t_supadv
(
supadv_sno int identity(1001,1),
supadv_id int,
supadv_dat datetime,
supadv_rat float,
supadv_amt float,
supadv_tamt as supadv_rat*supadv_amt,
supadv_cb char(1),
supadv_chq int,
supadv_rmk varchar(250),
cur_id int,
mpo_id int,
m_yr_id char(2),
mvch_id char(12),
mvch_typ char(2),
acc_id char(20)
)
--Not Null
alter table t_supadv alter column supadv_id int not null
alter table t_supadv alter column m_yr_id char(2) not null

--Primary key
alter table t_supadv add constraint PK_supadvID  primary key (supadv_id)

--Foreign key
alter table t_supadv add constraint FK_supadv_MPOID foreign key (mpo_id) references t_mpo(mpo_id)
alter table t_supadv add constraint FK_supadv_curID foreign key (cur_id) references m_cur(cur_id)
alter table t_supadv add constraint FK_supadv_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)