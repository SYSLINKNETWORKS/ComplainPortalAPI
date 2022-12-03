USE MFI
GO
--drop table m_port

--Item Brand
create table m_port
(
port_sno	int identity(1001,1),
port_id	int,
port_nam	varchar(250),
port_act	bit,
port_typ char(1),
port_cat char(1)
)

--Constraint
--Not Null
alter table m_port alter column port_id int not null

--Primary Key
alter table m_port add constraint PK_Mport_portID primary key (port_id)
