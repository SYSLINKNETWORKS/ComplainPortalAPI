USE MFI
GO
--DROP TABLE m_mac_com
create table m_mac_com
(
mac_com_sno int identity(1001,1),
mac_com_id int,
mac_com_nam varchar(250),
mac_com_typ char(1)
)

--Constraint
--Not Null
alter table m_mac_com alter column mac_com_id int not null

--Primary key
alter table m_mac_com add constraint PK_Mmac_com_Mac_comID primary key (mac_com_id)

