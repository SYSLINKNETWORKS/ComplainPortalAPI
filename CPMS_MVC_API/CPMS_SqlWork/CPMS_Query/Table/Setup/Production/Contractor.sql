USE meiji_rusk
GO

create table m_con
(
con_sno int identity (1001,1),
con_id int,
con_nam varchar(100),
con_cp varchar(100),
con_add varchar(250),
con_pho varchar(100),
con_mob varchar(100),
con_fax varchar(100),
con_eml varchar(100),
con_web varchar(100),
con_ntn varchar(100),
con_stn varchar(100),
con_act bit,
con_creday float,
con_amtltd float,
con_typ char(1),
supcat_id int,
cur_id int,
acc_id char(20),
com_id char(2),
br_id char(3),
con_idold varchar(1000),
con_snm varchar(10),
con_app bit,
acc_no int
)


--Constrants
--Not Null
alter table m_con alter column con_id int not null

--Primary Key
alter table m_con add constraint PK_Mcon_ConID primary key (con_id)

--Foreign Key
alter table m_con add constraint FK_MCON_supcatID foreign key (supcat_id) references m_supcat (supcat_id)
alter table m_con add constraint FK_MCON_curID foreign key (cur_id) references m_cur (cur_id)
alter table m_con add constraint FK_MCON_COMID foreign key (com_id) references m_com(com_id)
alter table m_con add constraint FK_MCON_BRID foreign key (br_id) references m_br(br_id)

--Unique
alter table m_con add constraint UQ_Mcon_CONNAM Unique (con_nam)


