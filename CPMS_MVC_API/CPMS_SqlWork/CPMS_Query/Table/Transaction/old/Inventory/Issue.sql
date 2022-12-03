USE MFI
GO
--drop table t_miss
--drop table t_diss


--Item Brand
create table t_miss
(
miss_sno int identity(1001,1),
miss_id	int,
miss_dat datetime,
miss_nob float,
titm_id int,
miss_act bit,
mso_id int,
miss_ckso bit,
miss_typ char(1),
cus_id int,
bd_id int,
mvch_id char(12)
)


--Constraint
--Not Null
alter table t_miss alter column miss_id int not null

--Primary Key
alter table t_miss add constraint PK_Mmiss_missID primary key (miss_id)

--Foreign Key
alter table t_miss add constraint FK_Mmiss_titm_ID foreign key (titm_id) references t_itm(titm_id)
alter table t_miss add constraint FK_MISS_CUSID foreign key (cus_id) references m_cus(cus_id)
alter table t_miss add constraint FK_MISS_BDID foreign key (bd_id) references m_bd(bd_id)




create table t_diss
(
diss_sno int identity(1001,1),
diss_id	int,
diss_qty float,
diss_rat float,
diss_namt as diss_qty*diss_rat,
diss_exp datetime,
wh_id int,
titm_id int,
miss_id int
)

--Constraint
--Not Null
alter table t_diss alter column diss_id int not null

--Primary Key
alter table t_diss add constraint PK_Mdiss_dissID primary key(diss_id)

--Foreign Key
alter table t_diss add constraint FK_Mdiss_missID foreign key (miss_id) references t_miss(miss_id)
alter table t_diss add constraint FK_Mdiss_titmID foreign key (titm_id) references t_itm(titm_id)



 