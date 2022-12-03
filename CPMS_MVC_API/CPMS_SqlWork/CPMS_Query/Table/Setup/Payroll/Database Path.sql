USE MFI
GO

--drop table m_path
create table m_path 
(
path_sno int identity(1001,1),
path_id int,
path_act bit,
path_path varchar(250),
path_tab_nam varchar(100),
path_tab_id varchar(100),
path_tab_tim varchar(100),
path_utab_nam varchar(100),
path_utab_id varchar(100),
path_utab_macid varchar(100),
path_utab_unam varchar(100),
path_typ char(1)
)


--Not Null
alter table m_path alter column path_id int not null

--Primary Key
alter table m_path add constraint PK_Mpath_pathID primary key (path_id)
