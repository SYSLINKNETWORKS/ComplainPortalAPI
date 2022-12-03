
USE MFI
GO
--drop table t_prtexp
--drop table t_dprtexp



create table t_Mprtexp
(
mprtexp_sno int identity(1001,1),
mprtexp_id	int,
mprtexp_dat datetime,
itmsub_id int,
bd_id int,
mprtexp_typ char(1),
mprtexp_rmk varchar(250)
)


--Constraint
--Not Null
alter table t_mprtexp alter column mprtexp_id int not null

--Primary Key
alter table t_mprtexp add constraint PK_Mprtexp_mprtexpID primary key (mprtexp_id)

--Foreign Key
alter table t_mprtexp add constraint FK_Mprtexp_itmSUB_ID foreign key (itmsub_id) references m_itmsub(itmsub_id)
alter table t_mprtexp add constraint FK_Mprtexp_BDID foreign key (bd_id) references m_bd(bd_id)




create table t_dprtexp
(
dprtexp_sno int identity(1001,1),
dprtexp_id	int,
titm_id int,
dprtexp_exp datetime,
dprtexp_rmk varchar(250),
dprtexp_qty float,
dprtexp_rat float,
dprtexp_trat float,
mprtexp_id int,
bd_id int,
wh_id int
)

--Constraint
--Not Null
alter table t_dprtexp alter column dprtexp_id int not null

--Primary Key
alter table t_dprtexp add constraint PK_Mdprtexp_dprtexpID primary key(dprtexp_id)

--Foreign Key
alter table t_dprtexp add constraint FK_Mdprtexp_mprtexpID foreign key (mprtexp_id) references t_mprtexp(mprtexp_id)
alter table t_dprtexp add constraint FK_Mdprtexp_titmID foreign key (titm_id) references t_itm(titm_id)
alter table t_dprtexp add constraint FK_Mdprtexp_bdID foreign key (bd_id) references m_bd(bd_id)
alter table t_dprtexp add constraint FK_Mdprtexp_whID foreign key (wh_id) references m_wh(wh_id)



 