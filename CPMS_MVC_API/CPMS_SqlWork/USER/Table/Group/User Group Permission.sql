USE ZSONS
GO


create table m_gpper
(
gpper_sno int identity(1001,1),
gpper_id int,
gpper_view bit,
gpper_new bit,
gpper_upd bit,
gpper_del bit,
gpper_print bit,
gpper_tax bit,
usrgp_id int,
men_id int
)

--Constraint
--Not Null
alter table m_gpper alter column gpper_id int not null

--Primary Key
alter table m_gpper add constraint PK_mgpper_gppertid primary key (gpper_id)
 
 --foreign key
alter table m_gpper add constraint PK_mgpper_usrgpid foreign key (usrgp_id) references m_usrgp(usrgp_id)
alter table m_gpper add constraint PK_mgpper_menid foreign key (men_id) references m_men(men_id)

