USE zsons
GO


--select * from m_cussubcat


create table m_cussubcat
(
cussubcat_id int ,
cussubcat_nam varchar(100),
cussubcat_act bit,
cussubcat_typ char(1)
)


--Constrants
--Not Null
alter table m_cussubcat alter column cussubcat_id int not null

--Primary Key
alter table m_cussubcat add constraint PK_Mcus_cussubcatID primary key (cussubcat_id)

----Foreign key
--alter table m_cus add constraint FK_MCUS_CUSSUBCATID foreign key (cuscat_id) references m_cussubcat(cuscat_id)
----alter table m_cus add constraint FK_MCUS_curID foreign key (cur_id) references m_cur(cur_id)