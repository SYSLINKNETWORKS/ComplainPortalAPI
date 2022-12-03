USE MFI
GO

--drop table m_shli

--select * from m_shli


create table m_shli
(
shli_sno int identity (1001,1),
shli_id int,
shli_nam varchar(100),
shli_cp varchar(100),
shli_add varchar(250),
shli_pho varchar(100),
shli_mob varchar(100),
shli_fax varchar(100),
shli_eml varchar(100),
shli_web varchar(100),
shli_ntn varchar(100),
shli_stn varchar(100),
shli_act bit,
shli_typ char(1)

)


--Constrants
--Not Null
alter table m_shli alter column shli_id int not null

--Primary Key
alter table m_shli add constraint PK_Mshli_shliID primary key (shli_id)




