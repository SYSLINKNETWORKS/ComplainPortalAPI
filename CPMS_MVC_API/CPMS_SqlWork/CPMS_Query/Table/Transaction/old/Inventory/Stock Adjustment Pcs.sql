
USE rough
GO
--drop table t_mstkadj
--drop table t_dstkadj



--Item Brand
create table t_mstkadj
(
mstkadj_sno int identity(1001,1),
mstkadj_id	int,
mstkadj_dat datetime,
mstkadj_fdat datetime,
mstkadj_tdat datetime,
mstkadj_pc bit,
itm_id int,
itmsub_id int,
mstkadj_typ char(1),
mstkadj_rmk varchar(250),
mvch_id char(12)
)


--Constraint
--Not Null
alter table t_mstkadj alter column mstkadj_id int not null

--Primary Key
alter table t_mstkadj add constraint PK_Mmstkadj_mstkadjID primary key (mstkadj_id)

--Foreign Key
alter table t_mstkadj add constraint FK_Mmstkadj_itmSUB_ID foreign key (itmsub_id) references m_itmsub(itmsub_id)
alter table t_mstkadj add constraint FK_mstkadj_itm foreign key (itm_id) references m_itm(itm_id)




create table t_dstkadj
(
dstkadj_sno int identity(1001,1),
dstkadj_id	int,
mso_id int,
titm_id int,
bd_id int,
dstkadj_bat varchar(100),
dstkadj_exp datetime,
dstkadj_maf datetime,
wh_id int,
dstkadj_rmk varchar(250),
dstkadj_qty float,
pack_mso_id int,
pack_titm_id int,
pack_bd_id int,
pack_dstkadj_exp datetime,
miss_id int,
mstkadj_id int
)

--Constraint
--Not Null
alter table t_dstkadj alter column dstkadj_id int not null

--Primary Key
alter table t_dstkadj add constraint PK_Mdstkadj_dstkadjID primary key(dstkadj_id)

--Foreign Key
alter table t_dstkadj add constraint FK_Mdstkadj_mstkadjID foreign key (mstkadj_id) references t_mstkadj(mstkadj_id)
alter table t_dstkadj add constraint FK_Mdstkadj_titmID foreign key (titm_id) references t_itm(titm_id)



 