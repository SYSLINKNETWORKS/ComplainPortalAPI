USE PAGEY
GO

--select * from m_sup

create table m_sup
(
sup_sno int identity (1001,1),
sup_id int,
sup_nam varchar(100),
sup_cp varchar(100),
sup_add varchar(250),
sup_pho varchar(100),
sup_mob varchar(100),
sup_fax varchar(100),
sup_eml varchar(100),
sup_web varchar(100),
sup_ntn varchar(100),
sup_stn varchar(100),
sup_act bit,
sup_creday float,
sup_amtltd float,
sup_typ char(1),
supcat_id int,
cur_id int,
acc_id char(20)
)


--Constrants
--Not Null
alter table m_sup alter column sup_id int not null

--Primary Key
alter table m_sup add constraint PK_MSUP_SUPID primary key (sup_id)

--Foreign Key
alter table m_sup add constraint FK_Msupcat_supcatID foreign key (supcat_id) references m_supcat (supcat_id)
alter table m_sup add constraint FK_Mcur_curID foreign key (cur_id) references m_cur (cur_id)

--Unique
alter table m_sup add constraint UQ_MSUP_SUPNAM Unique (sup_nam)


