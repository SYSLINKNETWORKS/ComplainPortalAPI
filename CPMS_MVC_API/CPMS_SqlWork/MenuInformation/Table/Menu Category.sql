USE ZSONS
GO

create table m_mencat
(
mencat_sno int identity(1001,1),
mencat_id int,
mencat_nam varchar(250),
mencat_typ char(1),
mencat_act bit
)

--Constraint 
--Not Null
alter table m_mencat alter column mencat_id int not null 

 --primary Key
 alter table m_mencat add constraint PK_mmencat_mencatid primary key (mencat_id)
