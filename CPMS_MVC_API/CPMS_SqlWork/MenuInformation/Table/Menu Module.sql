USE ZSONS
GO

CREATE TABLE m_module
(
	module_sno int IDENTITY(1001,1),
	module_id int,
	module_nam varchar(250),
	module_typ char(1) ,
	module_act bit ,
)

--Constraint
--Not Null
alter table m_module alter column module_id int not null

--Primary key
alter table m_module add constraint PK_MMODULE_MODULEID primary key(module_id)
