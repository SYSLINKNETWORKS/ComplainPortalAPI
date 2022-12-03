
USE PAGEY
GO

create table m_lot
(
lot_sno int identity (1001,1),
lot_id int,
lot_nam varchar(250),
lot_typ char(1),
lot_act bit
)



--Constraint
--Not null
alter table m_lot alter column lot_id int not null

--Primary
alter table m_lot add constraint PK_lot_PRID primary key (lot_id)

