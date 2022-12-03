USE ZSONS
go

--alter table t_magg alter column magg_amt float

--drop table t_dagg
--drop table t_magg

Create table t_magg
(
magg_sno int identity(1001,1),
magg_id	int,
magg_no int,
magg_dat datetime,
magg_datfrm datetime,
magg_datto datetime,
magg_act int default 0,
magg_ckamt bit,
magg_amt float,
magg_rmk varchar(250),
com_id char(2),
br_id char(3),
m_yr_id char(2),
cus_id int,
magg_typ char(1),
magg_close bit,
mvch_id int,
ins_usr_id char(2),
ins_dat datetime,
upd_usr_id char(2),
upd_dat datetime
)


--Constraint
--Not null
alter table t_magg alter column magg_id int not null
alter table t_magg alter column com_id char(2) not null
alter table t_magg alter column br_id char(3) not null
alter table t_magg alter column m_yr_id char(2) not null
alter table t_magg alter column magg_no int not null

--Priimary
alter table t_magg add constraint PK_Magg_MaggID primary key (magg_id)

--Foreign Key
alter table t_magg add constraint FK_Magg_COMID foreign key (com_id) references m_com(com_id)
alter table t_magg add constraint FK_Magg_BRID foreign key (br_id) references m_br(br_id)
alter table t_magg add constraint FK_Magg_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)
alter table t_magg add constraint FK_Magg_CUSID foreign key (cus_id) references m_cus(cus_id)

--Unique key
alter table t_magg add constraint PK_Magg_COMID_BRID_MYRID_MaggNO unique (com_id,m_yr_id,magg_no)


create table t_dagg
(
dagg_sno int identity (1001,1),
dagg_id int,
dagg_perval float,
dagg_per1 float,
dagg_per2 float,
dagg_per3 float,
dagg_per4 float,
bd_id int,
itmsub_id int,
magg_id int
)



--Constraint
--Not null
alter table t_dagg alter column dagg_id int not null

--aggimary
alter table t_dagg add constraint PK_Dagg_aggID primary key (dagg_id)

--Foreign Key
alter table t_dagg add constraint FK_Dagg_aggID foreign key (Magg_id) references t_magg (Magg_id)
alter table t_dagg add constraint FK_Dagg_BDID foreign key (bd_id) references m_bd (bd_id)
alter table t_dagg add constraint FK_Dagg_ITMSUBID foreign key (itmsub_id) references m_itmsub (itmsub_id)


