USE ZSONS
GO

--drop table t_diarc
--drop table t_miarc

create table t_miarc
(
miarc_sno int identity(1001,1),
miarc_id int,
miarc_dat datetime,
miarc_tbl varchar(250),
miarc_col1 varchar(250),
miarc_col2 varchar(250),
miarc_data1 varchar(1000),
miarc_data2 varchar(1000),
miarc_typ char(1),
module_id int,
mensubcat_id int,
men_id int,
com_id char(2),
br_id char(3),
m_yr_id char(2)
)


--Constraint
alter table t_miarc alter column miarc_id int not null
alter table t_miarc alter column com_id char(2) not null
alter table t_miarc alter column br_id char(3) not null
alter table t_miarc alter column m_yr_id char(2) not null

--Primary key
alter table t_miarc add constraint PK_TMIARC_COMID_BRID_MIARCID primary key (com_id,br_id,miarc_id)

--Foreign key
alter table t_miarc add constraint FK_TMIARC_MODULEID foreign key (module_id) references m_module(module_id)
alter table t_miarc add constraint FK_TMIARC_MENSUBCATID foreign key (mensubcat_id) references m_mensubcat(mensubcat_id)
alter table t_miarc add constraint FK_TMIARC_MENID foreign key (men_id) references m_men(men_id)


go

create table t_diarc
(
diarc_sno int identity(1001,1),
diarc_id int,
diarc_filepath varchar(1000),
diarc_filename varchar(1000),
diarc_extension varchar(1000),
diarc_col1 varchar(1000),
miarc_id int,
com_id char(2),
br_id char(3)
)

--Constraint
--Not null
alter table t_diarc alter column diarc_id int not null
alter table t_diarc alter column miarc_id int not null
alter table t_diarc alter column com_id char(2) not null
alter table t_diarc alter column br_id char(3) not null

--Primary Key
alter table t_diarc add constraint PK_DIARC_DIARCID primary key (com_id,br_id,diarc_id)

--Foreign key
alter table t_diarc add constraint FK_DIARC_COMID_BRID_MIARCID foreign key (com_id,br_id,miarc_id) references t_miarc (com_id,br_id,miarc_id)

