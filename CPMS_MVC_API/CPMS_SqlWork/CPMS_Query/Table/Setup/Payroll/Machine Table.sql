USE MFI
GO



create table m_mac
(
mac_sno int identity(1001,1),
mac_id int,
mac_act bit,
mac_nam varchar(250),
mac_ip char(100),
mac_prt int,
mac_cat char(100),
mac_com_id int,
mac_typ char(1)
)

--Constraint
--Not Null
alter table m_mac alter column mac_id int not null

--Primary key
alter table m_mac add constraint PK_MMAC_MACID primary key (mac_id)

--Foreign key
ALTER TABLE  m_mac ADD CONSTRAINT  FK_Mac_MAC_COM_ID  FOREIGN KEY( mac_com_id )REFERENCES  m_mac_com  ( mac_com_id )
