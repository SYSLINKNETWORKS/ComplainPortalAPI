USE zsons
GO


create table m_sms
(
sms_sno int identity(1001,1),
sms_id int,
sms_dat datetime,
sms_txt varchar(1000),
sms_mob varchar(1000),
sms_min int,
sms_cus varchar (250),
sms_act bit default 0,
sms_sdat datetime,
sms_typ char(1),
com_id char(2),
br_id char(2)
)

--Constraint
--Not Null
alter table m_sms alter column sms_id int not null

--Primary key 
alter table m_sms add constraint PK_sms_smsID primary key (sms_id)


