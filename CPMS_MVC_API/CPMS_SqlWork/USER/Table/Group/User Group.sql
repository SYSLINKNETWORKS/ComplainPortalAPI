USE ZSONS
GO

create table m_usrgp
(
usergp_sno int identity (1001,1),
usrgp_id int,
usrgp_nam varchar(250),
usrgp_typ char(10),
usrgp_act bit
)


--Constraint 
--Not Null
alter table m_usrgp alter column usrgp_id int not null
--Primrary key
 alter table m_usrgp add constraint PK_musrgp_usrgpid primary key (usrgp_id)


	