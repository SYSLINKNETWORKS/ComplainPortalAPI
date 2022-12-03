
USE NTHA
GO

--drop table m_bd_rat

create table m_bd_rat
(
bd_sno	int identity(1001,1),
bd_rat_id	int,
bd_rat_dat	datetime,
bd_mas_dis float,
bd_disrat float,
bd_rat_act	bit,
bd_rat_typ char(1),
itmsub_id int,
bd_id int,
titm_id int,
itmqty_id int
)


--Constraint
--Not Null
alter table m_bd_rat alter column bd_rat_id int not null

--Primary Key
alter table m_bd_rat add constraint PK_bdrat_bdratID primary key (bd_rat_id)

--Foreign key
alter table m_bd_rat add constraint FK_bdRAT_bdID foreign key (bd_id) references m_bd(bd_id)
alter table m_bd_rat add constraint FK_bdRAT_ITMSUBID foreign key (itmsub_id) references m_itmsub(itmsub_id)
alter table m_bd_rat add constraint FK_bdRAT_TITMID foreign key (titm_id) references t_itm(titm_id)
alter table m_bd_rat add constraint FK_bdRAT_ITMQTYID foreign key (itmqty_id) references m_itmqty(itmqty_id)



