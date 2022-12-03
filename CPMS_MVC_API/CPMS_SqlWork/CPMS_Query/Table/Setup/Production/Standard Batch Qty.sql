USE MFI
GO

--Stand Batch Qty
create table m_batqty
(
batqty_sno	int identity(1001,1),
batqty_id	int,
batqty_dat datetime,
batqty_qty	float,
batqty_rat float,
batqty_pc as batqty_qty*batqty_rat,
batqty_typ char(1),
titm_id int,
itmqty_id int,
)

--Constraint
--Not Null
alter table m_batqty alter column batqty_id int not null

--Primary Key
alter table m_batqty add constraint PK_Mbatqty_batqtyID primary key (batqty_id)


--Foreign Key
alter table m_batqty add constraint FK_MBATQTY_ITMQTYID foreign key (itmqty_id) references m_itmqty(itmqty_id)
alter table m_batqty add constraint FK_MBATQTY_TITMID foreign key (titm_id) references t_itm(titm_id)
