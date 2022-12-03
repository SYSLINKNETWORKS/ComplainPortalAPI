USE CPMS
GO

--drop table t_dcomp_img

--drop table t_mcomp

Create table t_mcomp
(
mcomp_sno int identity(1001,1),
mcomp_id	int,
mcomp_no	int,
mcomp_dat datetime,
mcomp_dat_app datetime,
mcomp_dat_ck datetime,
mcomp_dat_can datetime,
mcomp_app bit default 0,
mcomp_ck bit default 0,
mcomp_act bit default 0,
mcomp_can bit default 0,
mcomp_comp varchar(max),
mcomp_rmk varchar(MAX),
mcomp_ck_rmk varchar(max),
mcomp_app_rmk varchar(max),
mcomp_comp_by varchar(250),
mcomp_pr char(1),
mcomp_act_rmk varchar(1000),
mcomp_dat_act datetime,
mcomp_att int,
mcomp_typ char(1),
com_id char(2),
br_id char(3),
usr_id int,
usr_id_app int,
usr_id_ck int,
usr_id_can int,
usr_id_act int
)

--Constraint
--Not null
alter table t_mcomp alter column mcomp_id int not null
alter table t_mcomp alter column mcomp_no int not null
alter table t_mcomp alter column com_id char(2) not null
alter table t_mcomp alter column br_id char(3) not null

--Primary Key
alter table t_mcomp add constraint PK_Mcomp_McompID primary key (mcomp_id)

--Foreign Key
alter table t_mcomp add constraint FK_Mcomp_COMID foreign key (com_id) references m_com(com_id)
alter table t_mcomp add constraint FK_Mcomp_BRID foreign key (br_id) references m_br(br_id)
alter table t_mcomp add constraint FK_Mcomp_USRID foreign key (usr_id) references new_usr(usr_id)
alter table t_mcomp add constraint FK_Mcomp_USRIDAPP foreign key (usr_id_app) references new_usr(usr_id)
alter table t_mcomp add constraint FK_Mcomp_USRIDCK foreign key (usr_id_ck) references new_usr(usr_id)
alter table t_mcomp add constraint FK_Mcomp_USRIDCAN foreign key (usr_id_can) references new_usr(usr_id)
alter table t_mcomp add constraint FK_Mcomp_USRIDACT foreign key (usr_id_act) references new_usr(usr_id)


--Unique Key
alter table t_mcomp add constraint UNQ_Mcomp_COMID_BRID_MCOMPNO UNIQUE (com_id,br_id,mcomp_no)



create table t_dcomp_img
(
dcomp_img_sno int identity (1001,1),
dcomp_img_id int,
dcomp_img_file varchar(max),
mcomp_id int
)

--Constraint
--Not null
alter table t_dcomp_img alter column dcomp_img_id int not null

--primary
alter table t_dcomp_img add constraint PK_dcomp_img_dcomp_imgID primary key (dcomp_img_id)

--Foreign Key
alter table t_dcomp_img add constraint FK_dcomp_img_dcomp_imgID foreign key (mcomp_id) references t_mcomp (mcomp_id)
