use MEIJI
go

create table m_cuscom
(
cuscom_sno    int identity(1001,1),
cuscom_id     int,
cuscom_dat    datetime ,
cuscom_com    float,
cuscom_fr	  float,
cus_id		  int,
titm_id		  int,
cuscom_typ	  char(1),
cuscom_act	  bit

) 
----Constraints
--Not Null
alter table m_cuscom alter column cuscom_id int not null

--Primary Key
alter table m_cuscom add constraint PK_Mcuscom_cuscomID primary key (cuscom_id)

--Forign Key
alter table m_cuscom add constraint FK_Mcuscom_cusID foreign key (cus_id) references m_cus(cus_id)
alter table m_cuscom add constraint FK_Mcuscom_titmID foreign key (titm_id) references t_itm(titm_id)


