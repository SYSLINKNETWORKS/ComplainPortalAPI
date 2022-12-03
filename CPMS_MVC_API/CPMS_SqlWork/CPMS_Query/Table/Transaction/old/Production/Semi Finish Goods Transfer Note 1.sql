use zsons

go

--drop table t_dsm1

--Item Brand
create table t_sm1
(
sm1_sno int identity(1001,1),
sm1_id	int,
sm1_dat datetime,
sm1_act bit,
sm1_typ char(1),
m_yr_id char(2)
)


--Constraint
--Not Null
alter table t_sm1 alter column sm1_id int not null

--Primary Key
alter table t_sm1 add constraint PK_Msm1_sm1ID primary key (sm1_id)

--Foreign Key
alter table t_sm1 add constraint FK_sm1_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)






create table t_dsm1
(
dsm1_sno int identity(1001,1),
dsm1_id	int,
dsm1_bat int,
dsm1_exp datetime,
dsm1_rec float,
dsm1_rat float,
dsm1_wstg float,
dsm1_scrp float,
titm_id int,
sm1_id int,
wh_id int,
miss_id int
)

--Constraint
--Not Null
alter table t_dsm1 alter column dsm1_id int not null

--Primary Key
alter table t_dsm1 add constraint PK_Tdsm1_dsm1ID primary key(dsm1_id)

--Foreign Key
alter table t_dsm1 add constraint FK_Tdsm1_sm1ID foreign key (sm1_id) references t_sm1(sm1_id)
alter table t_dsm1 add constraint FK_Tdsm1_titmID foreign key (titm_id) references t_itm(titm_id)

alter table t_dsm1 add constraint FK_Tdsm1_WHID foreign key (wh_id) references m_wh(wh_id)
alter table t_dsm1 add constraint FK_Tdsm1_missID foreign key (miss_id) references t_miss(miss_id)

 