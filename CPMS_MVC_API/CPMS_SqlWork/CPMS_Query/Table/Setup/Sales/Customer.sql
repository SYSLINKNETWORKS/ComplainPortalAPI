USE PHM
GO


--select * from m_cus


create table m_cus
(
cus_sno int identity (1001,1),
cus_id int,
cus_nam varchar(100),
cus_cp varchar(100),
cus_add varchar(250),
cus_pho varchar(100),
cus_mob varchar(100),
cus_fax varchar(100),
cus_eml varchar(100),
cus_web varchar(100),
cus_ntn varchar(100),
cus_stn varchar(100),
cus_act bit,
cus_creday float,
cus_amtltd float,
cus_typ char(1),
cuscat_id int,
brk_id int,
cur_id int,
acc_id char(20)
)


--Constrants
--Not Null
alter table m_cus alter column cus_id int not null

--Primary Key
alter table m_cus add constraint PK_Mcus_cusID primary key (cus_id)

--Foreign key
alter table m_cus add constraint FK_MCUS_CUSCATID foreign key (cuscat_id) references m_cuscat(cuscat_id)
alter table m_cus add constraint FK_MCUS_curID foreign key (cur_id) references m_cur(cur_id)
alter table m_cus add constraint FK_MCUS_brkID foreign key (brk_id) references m_brk(brk_id)



