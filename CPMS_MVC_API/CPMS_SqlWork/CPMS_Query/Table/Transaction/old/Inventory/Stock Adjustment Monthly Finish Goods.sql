
USE MFI
GO
--drop table t_mstkadjmonfg
--drop table t_dstkadjmonfg



create table t_mstkadjmonfg
(
mstkadjmonfg_sno int identity(1001,1),
mstkadjmonfg_id	int,
mstkadjmonfg_dat datetime,
mstkadjmonfg_typ char(1),
mvch_id char(12)
)


--Constraint
--Not Null
alter table t_mstkadjmonfg alter column mstkadjmonfg_id int not null

--Primary Key
alter table t_mstkadjmonfg add constraint PK_Mmstkadjmonfg_mstkadjmonfgID primary key (mstkadjmonfg_id)

create table t_dstkadjmonfg
(
dstkadjmonfg_sno int identity(1001,1),
dstkadjmonfg_id	int,
mso_id int,
titm_id int,
bd_id int,
dstkadjmonfg_bat varchar(100),
dstkadjmonfg_exp datetime,
dstkadjmonfg_maf datetime,
wh_id int,
dstkadjmonfg_rmk varchar(250),
dstkadjmonfg_qty float,
mstkadjmonfg_id int
)

--Constraint
--Not Null
alter table t_dstkadjmonfg alter column dstkadjmonfg_id int not null

--Primary Key
alter table t_dstkadjmonfg add constraint PK_Mdstkadjmonfg_dstkadjmonfgID primary key(dstkadjmonfg_id)

--Foreign Key
alter table t_dstkadjmonfg add constraint FK_Mdstkadjmonfg_mstkadjmonfgID foreign key (mstkadjmonfg_id) references t_mstkadjmonfg(mstkadjmonfg_id)
alter table t_dstkadjmonfg add constraint FK_Mdstkadjmonfg_titmID foreign key (titm_id) references t_itm(titm_id)



 