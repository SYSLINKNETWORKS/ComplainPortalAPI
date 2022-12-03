
USE MFI
GO
--drop table t_mstkadjmon
--drop table t_dstkadjmon



create table t_mstkadjmon
(
mstkadjmon_sno int identity(1001,1),
mstkadjmon_id	int,
mstkadjmon_dat datetime,
itm_id int,
itmsub_id int,
mstkadjmon_typ char(1),
mstkadjmon_rmk varchar(250),
mvch_id char(12)
)


--Constraint
--Not Null
alter table t_mstkadjmon alter column mstkadjmon_id int not null

--Primary Key
alter table t_mstkadjmon add constraint PK_Mmstkadjmon_mstkadjmonID primary key (mstkadjmon_id)

--Foreign Key
alter table t_mstkadjmon add constraint FK_Mmstkadjmon_itmSUB_ID foreign key (itmsub_id) references m_itmsub(itmsub_id)
alter table t_mstkadjmon add constraint FK_mstkadjmon_itm foreign key (itm_id) references m_itm(itm_id)




create table t_dstkadjmon
(
dstkadjmon_sno int identity(1001,1),
dstkadjmon_id	int,
mso_id int,
titm_id int,
bd_id int,
dstkadjmon_bat varchar(100),
dstkadjmon_exp datetime,
dstkadjmon_maf datetime,
wh_id int,
dstkadjmon_rmk varchar(250),
dstkadjmon_qty float,
mstkadjmon_id int
)

--Constraint
--Not Null
alter table t_dstkadjmon alter column dstkadjmon_id int not null

--Primary Key
alter table t_dstkadjmon add constraint PK_Mdstkadjmon_dstkadjmonID primary key(dstkadjmon_id)

--Foreign Key
alter table t_dstkadjmon add constraint FK_Mdstkadjmon_mstkadjmonID foreign key (mstkadjmon_id) references t_mstkadjmon(mstkadjmon_id)
alter table t_dstkadjmon add constraint FK_Mdstkadjmon_titmID foreign key (titm_id) references t_itm(titm_id)



 