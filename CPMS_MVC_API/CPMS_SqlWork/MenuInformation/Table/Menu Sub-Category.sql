USE ZSONS
GO

create table m_mensubcat
(
mensubcat_sno int identity(1001,1),
mensubcat_id int,
mensubcat_nam varchar(250),
mensubcat_typ char(1),
mensubcat_act bit,
mencat_id int
)

--Constraint
--Not null
alter table m_mensubcat alter column mensubcat_id int not null

--primary Key
 alter table m_mensubcat add constraint PK_mmensubcat_mensbcatid primary key (mensubcat_id)


--Foreign Key
alter table m_mensubcat add constraint FK_mmensubcat_mensbcatid foreign key (mencat_id) references m_mencat(mencat_id)


