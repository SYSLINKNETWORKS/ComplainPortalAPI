--drop table m_wh
create table m_wh
(
wh_sno int identity(1001,1),
wh_id int,
wh_nam varchar(100),
br_id char(3)
itm_id int
wh_typ char(1)
)

--Constraint
--Not Null
alter table m_wh alter column wh_id int not null

--Primary key
alter table m_wh add constraint PK_MWH_WHID primary key (wh_id)

--Foreign key
alter table m_wh add constraint FK_MWH_ITMID foreign key (itm_id) references m_itm(itm_id)
alter table m_wh add constraint FK_MWH_BRID foreign key (br_id) references m_br(br_id)