USE BDTS1
GO
--drop table new_usr
----New User
CREATE TABLE [dbo].[new_usr](
	[usr_sno] [int] IDENTITY(1001,1) NOT NULL,
	[usr_id] int ,
	[usr_no] int,
	[usr_nam] [varchar](100) ,
	[usr_pwd] [varchar](50) ,
	[usr_add] [varchar](100) ,
	[usr_pho] [varchar](100) ,
	[usr_mob] [varchar](100) ,
	[usr_eml] [varchar](100) ,
	[gp_id] [char](2) ,
	[com_id] [int] ,
	[br_id] [int] ,
	[usr_typ] [char](1) ,
	)
	--Not Null
	alter table new_usr alter column usr_id int not null
	
	--Primary key
	alter table new_usr add constraint NEWUSR_USRID primary key (usr_id)
	
	--Foreign Key
	alter table new_usr add constraint FK_NEWUSR_COMID foreign key (com_id) references m_com(com_id)
	alter table new_usr add constraint FK_NEWUSR_BRID foreign key (br_id) references m_br(br_id)

	--Unique Key
	alter table new_usr add constraint UNQ_NEWUSR_USRNAM unique (usr_nam)
	alter table new_usr add constraint UNQ_NEWUSR_COMID_BRID_USRNO unique (com_id,br_id,usr_nam)

