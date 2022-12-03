--drop table t_cusadv
create table t_cusadv
(
cusadv_sno int identity(1001,1),
cusadv_id int,
cusadv_dat datetime,
cusadv_rat float,
cusadv_amt float,
cusadv_tamt as cusadv_rat*cusadv_amt,
cusadv_cb char(1),
cusadv_chq int,
cusadv_rmk varchar(250),
cur_id int,
mso_id int,
m_yr_id char(2),
mvch_id char(12),
mvch_typ char(2),
acc_id char(20)
)
--Not Null
alter table t_cusadv alter column cusadv_id int not null
alter table t_cusadv alter column m_yr_id char(2) not null

--Primary key
alter table t_cusadv add constraint PK_cusadvID  primary key (cusadv_id)

--Foreign key
alter table t_cusadv add constraint FK_cusadv_MsoID foreign key (mso_id) references t_mso(mso_id)
alter table t_cusadv add constraint FK_cusadv_curID foreign key (cur_id) references m_cur(cur_id)
alter table t_cusadv add constraint FK_cusadv_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)