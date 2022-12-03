use zsons
go
--drop table t_sm2
--drop table t_dsm2

--Item Brand
create table t_sm2
(
sm2_sno int identity(1001,1),
sm2_id	int,
sm2_dat datetime,
sm2_act bit,
sm2_typ char(1),
sm2_qty float,
titm_id int,
m_yr_id char(2)
)


--Constraint
--Not Null
alter table t_sm2 alter column sm2_id int not null

--Primary Key
alter table t_sm2 add constraint PK_Msm2_sm2ID primary key (sm2_id)

--Foreign Key
alter table t_sm2 add constraint FK_Tsm2_titm_ID foreign key (titm_id) references t_itm(titm_id)
alter table t_sm2 add constraint FK_Tsm2_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)






create table t_dsm2
(
dsm2_sno int identity(1001,1),
dsm2_id	int,
dsm2_bat varchar(100),
dsm2_rec float,
dsm2_wstg float,
dsm2_scrp float,
dsm2_rat float,
titm_id int,
sm2_id int,
wh_id int
)

--Constraint
--Not Null
alter table t_dsm2 alter column dsm2_id int not null

--Primary Key
alter table t_dsm2 add constraint PK_Mdsm2_dsm2ID primary key(dsm2_id)

--Foreign Key
alter table t_dsm2 add constraint FK_Tdsm2_sm2ID foreign key (sm2_id) references t_sm2(sm2_id)
alter table t_dsm2 add constraint FK_Tdsm2_titmID foreign key (titm_id) references t_itm(titm_id)
alter table t_dsm2 add constraint FK_Tdsm2_WHID foreign key (wh_id) references m_wh(wh_id)

 