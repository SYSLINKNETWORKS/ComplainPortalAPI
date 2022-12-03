USE ZSons
GO


create table m_city
(
city_sno int identity(1001,1),
city_id int,
city_nam char(25),
city_act bit,
city_typ char(1),
coun_id int
)

--Constraint 
--Not Null
alter table m_city alter column city_id int not null

--Primary Key
alter table m_city add constraint PK_Mcity_cityID primary key (city_id)

--Foreign key
alter table m_city add constraint FK_MCITY_COUNTRYID foreign key (coun_id) references m_coun (coun_id)