--alter table m_emppro add 

USE MFI
GO



create TABLE m_emppro 
(
	 emppro_sno			int  IDENTITY(1001,1)  ,
	 emppro_id			int   ,
	 emppro_cat			char (1)  ,
	 emppro_macid		int   ,
	 emppro_nam			varchar (250)  ,
	 emppro_fnam		varchar (250)  ,
	 memp_sub_id		int,
	 emppro_add			varchar (1000)  ,
	 emppro_doj			datetime   ,
	 dpt_id				char (2)  ,
	 emppro_gen			char (1)  ,
	 emppro_mar			char (1)  ,
	 emppro_dob			datetime   ,
	 emppro_cnic		char (15)  ,
	 emppro_ntn			char (20)  ,
	 emppro_ref			varchar (250)  ,
	 emppro_pho			varchar (100)  ,
	 emppro_mob			varchar (100)  ,
	 emppro_eml			varchar (100)  ,
	 emppro_expcom		varchar (100)  ,
	 emppro_expdes		varchar (100)  ,
	 emppro_expyrfrm	datetime   ,
	 emppro_expyrto		datetime   ,
	 emppro_exprmk		varchar (100)  ,
	 emppro_quains		varchar (100)  ,
	 emppro_quaqua		varchar (50)  ,
	 emppro_quayr		datetime   ,
	 emppro_quarmk		varchar (100)  ,
	 emppro_sal			float   ,
	 emppro_salgra		bit   ,
	 emppro_saleobi		bit   ,
	 emppro_salsessi	bit   ,
	 emppro_salsp		bit   ,
	 emppro_reg			bit   ,
	 emppro_reg_dat		datetime,
	 emppro_reg_rmk		varchar(100),
	 emppro_st			bit   ,
	 emppro_typ			char (1)  ,
	 emppro_img			image   ,
	 ros_id				int   ,
	 empros_id			int   ,
	 emppro_salpay		char (1)  ,
	 emppro_ot			bit   ,
	 emppro_att			bit	,
	 emppro_saleobi_dor datetime   ,
	 emppro_saleobi_reg varchar (50)  ,
	 emppro_salpay_acc  varchar (100)  ,
	 emppro_salpt		float   ,
	 emppro_salpot		float   ,
	 memp_sub_id		int,
	 emppro_ho			bit,
	 emppro_rat			float,
	 emppro_lde			bit,
	 emppro_sot			bit,
	 emppro_fot			bit,
	 msal_id			int   
--alter table m_emppro add memp_sub_id int
--alter table m_emppro add emppro_ho bit
--alter table m_emppro add emppro_rat float
--alter table m_emppro add emppro_lde bit
--alter table m_emppro add emppro_sot bit
--alter table m_emppro add emppro_fot bit
)

--Constraint
--Not Null

alter table m_emppro alter column emppro_id int not null
alter table m_emppro alter column emppro_cat char(1) not null

--Primary key
alter table m_emppro add constraint PK_EMPPRO_EMPPROID primary key (emppro_id)

--ALTER TABLE  m_emppro drop CONSTRAINT  FK_EMPPRO_ROSID
--Foreign key
ALTER TABLE  m_emppro ADD CONSTRAINT  FK_EMPPRO_ROSGPID  FOREIGN KEY( ros_id )REFERENCES  m_rosgp  ( rosgp_id )
alter table m_emppro add constraint FK_EMPPRO_EMPSUB foreign key (memp_sub_id) references m_emp_sub(memp_sub_id)

--Unique Key
alter table m_emppro add constraint UQ_EMPPRO_EMPPROMACID_EMPPRO_CAT unique (emppro_macid,emppro_cat)

