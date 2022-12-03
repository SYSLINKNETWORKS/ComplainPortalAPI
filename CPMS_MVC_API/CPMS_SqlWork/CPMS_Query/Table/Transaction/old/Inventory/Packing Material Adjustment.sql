
USE MFI
GO
--drop table t_pkadj
--drop table t_dpkadj



create table t_Mpkadj
(
mpkadj_sno int identity(1001,1),
mpkadj_id	int,
mpkadj_dat datetime,
itmsub_id int,
bd_id int,
mpkadj_typ char(1),
mpkadj_rmk varchar(250)
)


--Constraint
--Not Null
alter table t_mpkadj alter column mpkadj_id int not null

--Primary Key
alter table t_mpkadj add constraint PK_Mpkadj_mpkadjID primary key (mpkadj_id)

--Foreign Key
alter table t_mpkadj add constraint FK_Mpkadj_itmSUB_ID foreign key (itmsub_id) references m_itmsub(itmsub_id)
alter table t_mpkadj add constraint FK_Mpkadj_BDID foreign key (bd_id) references m_bd(bd_id)




create table t_dpkadj
(
dpkadj_sno int identity(1001,1),
dpkadj_id	int,
titm_id int,
dpkadj_exp datetime,
dpkadj_rmk varchar(250),
dpkadj_rqty float,
dpkadj_iqty float,
dpkadj_rat float,
dpkadj_trat float,
mpkadj_id int,
bd_id int,
wh_id int
)

--Constraint
--Not Null
alter table t_dpkadj alter column dpkadj_id int not null

--Primary Key
alter table t_dpkadj add constraint PK_Mdpkadj_dpkadjID primary key(dpkadj_id)

--Foreign Key
alter table t_dpkadj add constraint FK_Mdpkadj_mpkadjID foreign key (mpkadj_id) references t_mpkadj(mpkadj_id)
alter table t_dpkadj add constraint FK_Mdpkadj_titmID foreign key (titm_id) references t_itm(titm_id)
alter table t_dpkadj add constraint FK_Mdpkadj_bdID foreign key (bd_id) references m_bd(bd_id)
alter table t_dpkadj add constraint FK_Mdpkadj_whID foreign key (wh_id) references m_wh(wh_id)



 