--Item Qty
create table m_itmqty
(
itmqty_sno	int identity(1001,1),
itmqty_id	int,
itmqty_nam	varchar(250),
itmqty_act	bit,
itmqty_typ char(1)
)

--Constraint
--Not Null
alter table m_itmqty alter column itmqty_id int not null

--Primary Key
alter table m_itmqty add constraint PK_Mitmqty_itmqtyID primary key (itmqty_id)

--Unique
alter table m_itmqty add constraint UNI_ITMQTY_ITMQTYNAM unique (itmqty_nam)
