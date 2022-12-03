USE ZSONS
GO

create table m_dusr
(
dusr_sno int identity(1001,1),
dusr_id int,
usr_id CHAR(2),
usrgp_id int
)

--Constraint 
--Not Null
alter table m_dusr alter column dusr_id int not null
	
--primary Key
alter table m_dusr add constraint PK_mdusr_dusrid primary key (dusr_id)

--Foreign Key
alter table m_dusr add constraint FK_mdusr_usrgpid foreign key (usrgp_id) references m_usrgp(usrgp_id)
alter table m_dusr add constraint FK_mdusr_usrid foreign key (usr_id) references new_usr(usr_id)


